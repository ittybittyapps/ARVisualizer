//
//  Copyright © 2018 Itty Bitty Apps Pty Ltd. All rights reserved.
//

import SceneKit
import Core

public final class SceneController: NSObject, SCNSceneRendererDelegate {

    public enum PointCloudMode: Int, CaseIterable {
        case none
        case lastFrame
        case accumulated
    }

    public enum PlaneAnchorsMode: Int, CaseIterable {
        case none
        case extents
        case geometry
    }

    public let scene = SCNScene()
    public let cameraController: CameraController

    public var pointCloudMode = PointCloudMode.accumulated {
        didSet {
            self.updatePointCloudGeometry()
        }
    }

    public var planeAnchorsMode = PlaneAnchorsMode.geometry {
        didSet {
            let nodeMode = self.planeAnchorsMode.nodeMode
            self.planeAnchorNodes.forEach { $0.mode = nodeMode }
        }
    }

    public override init() {
        self.cameraController = CameraController(cameraNode: self.cameraNode, deviceCameraNode: self.deviceCameraNode)

        super.init()

        [ self.cameraNode,
          self.worldOriginNode,
          self.deviceCameraNode,
          self.boundingBoxNode,
          self.floorPlaneNode,
          self.pointCloudNode ]
            .forEach(self.scene.rootNode.addChildNode(_:))

        self.updateMeasurements()
    }

    // MARK: - Internal

    private(set) var model = SessionModel()

    func updateFrame(_ frame: Frame) {
        self.model.update(with: frame)
        self.lastFrame = frame

        self.deviceCameraNode.simdTransform = frame.camera.transform
        self.cameraController.viewingOrientationAngle = frame.viewingOrientationAngle

        self.updateMeasurements()
    }

    func updatePointCloud(_ pointCloud: PointCloud) {
        self.model.update(with: pointCloud)
        self.lastPointCloud = pointCloud

        self.updatePointCloudGeometry()
        self.updateMeasurements()
    }

    func addAnchor(_ anchor: Anchor) {
        self.model.updateAnchor(anchor)

        let anchorNode: SCNNode
        switch anchor {
        case let planeAnchor as PlaneAnchor:
            anchorNode = PlaneAnchorNode(planeAnchor: planeAnchor, mode: self.planeAnchorsMode.nodeMode)
        default:
            anchorNode = BasicAnchorNode(anchor: anchor)
        }

        self.anchorNodes[anchor.identifier] = anchorNode
        self.scene.rootNode.addChildNode(anchorNode)
    }

    func updateAnchor(_ anchor: Anchor) {
        guard let anchorNode = self.anchorNodes[anchor.identifier] else {
            self.addAnchor(anchor)
            return
        }

        self.model.updateAnchor(anchor)

        switch (anchor, anchorNode) {
        case let (anchor as PlaneAnchor, anchorNode as PlaneAnchorNode):
            anchorNode.update(with: anchor)

        case let (_, anchorNode as BasicAnchorNode):
            anchorNode.update(with: anchor)

        default:
            assertionFailure("Unexpected node \(type(of: anchorNode)) for anchor \(anchor)!")
        }
    }

    func removeAnchor(_ anchor: Anchor) {
        self.model.removeAnchor(anchor)

        if let node = self.anchorNodes.removeValue(forKey: anchor.identifier) {
            node.removeFromParentNode()
        }
    }

    // MARK: - SCNSceneRendererDelegate

    public func renderer(_ renderer: SCNSceneRenderer, didApplyConstraintsAtTime time: TimeInterval) {
        self.cameraController.update()
    }

    // MARK: - Private

    private enum Constants {
        static let worldOriginGizmoSize: CGFloat = 0.5
    }

    private let cameraNode = CameraNode()
    private let worldOriginNode = AxesGizmoNode(size: Constants.worldOriginGizmoSize)
    private let deviceCameraNode = DeviceCameraNode()
    private let boundingBoxNode = BoundingBoxNode()
    private let floorPlaneNode = GridNode()
    private let pointCloudNode = PointCloudNode()
    private var anchorNodes = [UUID: SCNNode]()

    private var planeAnchorNodes: [PlaneAnchorNode] {
        return self.anchorNodes.values.compactMap { $0 as? PlaneAnchorNode }
    }

    private var lastFrame: Frame?
    private var lastPointCloud: PointCloud?

    private func updatePointCloudGeometry() {
        self.pointCloudNode.isHidden = self.pointCloudMode == .none

        switch self.pointCloudMode {
        case .none:
            self.pointCloudNode.updateWithPointCloud(nil)

        case .lastFrame:
            self.pointCloudNode.updateWithPointCloud(self.lastPointCloud)

        case .accumulated:
            self.pointCloudNode.updateWithAccumulatedPointCloud(self.model.accumulatedPointCloud)
        }
    }

    private func updateMeasurements() {
        let aggregateBB = self.model.featurePointsBoundingBox

        self.boundingBoxNode.update(with: aggregateBB)
        self.pointCloudNode.material.setHeightRange(min: aggregateBB.minCorner.y, max: aggregateBB.maxCorner.y)

        let boundingBoxSize = aggregateBB.size
        let boundingBoxCenter = aggregateBB.center
        self.floorPlaneNode.size = CGSize(width: CGFloat(boundingBoxSize.x),
                                          height: CGFloat(boundingBoxSize.z))
        self.floorPlaneNode.simdPosition = simd_float3(x: boundingBoxCenter.x,
                                                       y: self.model.floorPosition,
                                                       z: boundingBoxCenter.z)
    }

}

// MARK: - Extensions

extension SceneController.PointCloudMode: CustomStringConvertible {

    public var description: String {
        switch self {
        case .none:
            return NSLocalizedString("None", comment: "Point cloud mode title")
        case .lastFrame:
            return NSLocalizedString("Last frame", comment: "Point cloud mode title")
        case .accumulated:
            return NSLocalizedString("Accumulated", comment: "Point cloud mode title")
        }
    }

}

extension SceneController.PlaneAnchorsMode: CustomStringConvertible {

    public var description: String {
        switch self {
        case .none:
            return NSLocalizedString("None", comment: "Plane anchors mode title")
        case .extents:
            return NSLocalizedString("Extents", comment: "Plane anchors mode title")
        case .geometry:
            return NSLocalizedString("Geometry", comment: "Plane anchors mode title")
        }
    }

}

// MARK: - Private extensions

private extension SceneController.PlaneAnchorsMode {

    var nodeMode: PlaneAnchorNode.Mode {
        switch self {
        case .none:
            return .none
        case .extents:
            return .extent
        case .geometry:
            return .geometry
        }
    }

}
