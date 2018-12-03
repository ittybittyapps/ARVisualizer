//
//  Copyright © 2018 Itty Bitty Apps Pty Ltd. All rights reserved.
//

import Core
import SceneKit

final class PlaneAnchorNode: SCNNode {

    enum Mode {
        case none
        case extent
        case geometry
    }

    var mode: Mode {
        didSet {
            self.applyMode()
        }
    }

    init(planeAnchor: PlaneAnchor, mode: Mode) {
        self.mode = mode

        super.init()

        self.name = planeAnchor.name ?? planeAnchor.alignment.anchorName

        // Prepare geometry for extent-based nodes
        let extentFillGeometry = SCNGeometry.makeExtentFill()
        extentFillGeometry.materials = [ self.fillMaterial ]
        self.extentFillNode.geometry = extentFillGeometry

        let extentOutlineGeometry = SCNGeometry.makeExtentOutline()
        extentOutlineGeometry.materials = [ PlaneAnchorNode.outlineMaterial ]
        self.extentOutlineNode.geometry = extentOutlineGeometry

        // Extent-based nodes are represented by XY planes which need to be rotated
        let planeRotation = SCNVector3(-Float.pi / 2, 0, 0)
        self.extentFillNode.eulerAngles = planeRotation
        self.extentOutlineNode.eulerAngles = planeRotation

        self.addChildNode(self.extentFillNode)
        self.addChildNode(self.extentOutlineNode)
        self.addChildNode(self.geometryFillNode)
        self.addChildNode(self.geometryOutlineNode)
        self.addChildNode(self.gizmoNode)
        self.applyMode()

        self.update(with: planeAnchor)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(with planeAnchor: PlaneAnchor) {
        self.simdTransform = planeAnchor.transform

        // Update extent-based nodes
        let extentSize = planeAnchor.extentSize
        let extentScale = SCNVector3(x: SCNFloat(extentSize.width), y: SCNFloat(extentSize.height), z: 1)

        self.extentFillNode.simdPosition = planeAnchor.center
        self.extentFillNode.scale = extentScale

        self.extentOutlineNode.simdPosition = planeAnchor.center
        self.extentOutlineNode.scale = extentScale

        // Update geometry-based nodes
        if let planeGeometry = planeAnchor.geometry {
            let fillGeometry = SCNGeometry.makeFill(with: planeGeometry)
            fillGeometry.materials = [ self.fillMaterial ]
            self.geometryFillNode.geometry = fillGeometry

            let outlineGeometry = SCNGeometry.makeOutline(with: planeGeometry)
            outlineGeometry.materials = [ PlaneAnchorNode.outlineMaterial ]
            self.geometryOutlineNode.geometry = outlineGeometry
        }
    }

    // MARK: - Private

    private enum Constants {
        static let gizmoSize: CGFloat = 0.1
    }

    private static let outlineMaterial = SCNMaterial(solidColor: .white, fillMode: .lines, isDoubleSided: true)

    private let fillMaterial = SCNMaterial(solidColor: .makePlaneRandom(), isDoubleSided: true)

    private let extentFillNode = SCNNode()
    private let extentOutlineNode = SCNNode()
    private let geometryFillNode = SCNNode()
    private let geometryOutlineNode = SCNNode()

    private let gizmoNode = AxesGizmoNode(size: Constants.gizmoSize)

    private func applyMode() {
        let shouldHideExtent = self.mode != .extent
        let shouldHideGeometry = self.mode != .geometry

        self.extentFillNode.isHidden = shouldHideExtent
        self.extentOutlineNode.isHidden = shouldHideExtent

        self.geometryFillNode.isHidden = shouldHideGeometry
        self.geometryOutlineNode.isHidden = shouldHideGeometry

        self.gizmoNode.isHidden = self.mode == .none
    }

}

// MARK: - Private extensions

private extension PlaneAnchor {

    var extentSize: CGSize {
        return CGSize(width: CGFloat(self.extent.x), height: CGFloat(self.extent.z))
    }

}

private extension PlaneAnchor.Alignment {

    var anchorName: String {
        switch self {
        case .horizontal:
            return "HorizontalPlaneAnchor"
        case .vertical:
            return "VerticalPlaneAnchor"
        }
    }

}

private extension Color {

    static func makePlaneRandom() -> Self {
        return self.init(hue: CGFloat.random(in: 0...1), saturation: CGFloat.random(in: 0...1), brightness: 1, alpha: 0.5)
    }

}

private extension SCNGeometry {

    static func makeExtentFill() -> SCNPlane {
        return SCNPlane(width: 1, height: 1)
    }

    static func makeExtentOutline() -> SCNGeometry {
        /// 1x1 XY plane made out of line segments
        let vertices: [SCNVector3] = [
            .init(-0.5, -0.5, 0),
            .init(-0.5, 0.5, 0),
            .init(0.5, 0.5, 0),
            .init(0.5, -0.5, 0),
        ]
        let vertexSource = SCNGeometrySource(vertices: vertices)

        let indices: [Int8] = [
            0, 1,   1, 2,   2, 3,   3, 0
        ]
        let element = SCNGeometryElement(indices: indices, primitiveType: .line)

        return SCNGeometry(sources: [ vertexSource ], elements: [ element ])
    }

    static func makeFill(with planeGeometry: PlaneGeometry) -> SCNGeometry {
        let vertexSource = SCNGeometrySource(vertices: .init(start: planeGeometry.vertices, count: Int(planeGeometry.vertexCount)))
        let textureCoordinateSource = SCNGeometrySource(textureCoordinates: .init(start: planeGeometry.textureCoordinates, count: Int(planeGeometry.textureCoordinateCount)))

        let element = SCNGeometryElement(triangleIndices: .init(start: planeGeometry.triangleIndices, count: Int(planeGeometry.triangleIndexCount)))

        return SCNGeometry(sources: [ vertexSource, textureCoordinateSource ], elements: [ element ])
    }

    static func makeOutline(with planeGeometry: PlaneGeometry) -> SCNGeometry {
        let vertexSource = SCNGeometrySource(vertices: .init(start: planeGeometry.boundaryVertices, count: Int(planeGeometry.boundaryVertexCount)))

        let vertexCount = UInt16(planeGeometry.boundaryVertexCount)
        let lineVertexIndices = (0..<vertexCount)
            .flatMap { [$0, ($0 + 1) % vertexCount] }
        let element = SCNGeometryElement(indices: lineVertexIndices, primitiveType: .line)

        return SCNGeometry(sources: [ vertexSource ], elements: [ element ])
    }

}
