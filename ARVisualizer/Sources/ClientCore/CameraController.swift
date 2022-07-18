//
//  Copyright © 2018 Itty Bitty Apps Pty Ltd. All rights reserved.
//

import SceneKit

public final class CameraController {

    public enum Mode: Int, CaseIterable {
        case firstPerson
        case thirdPerson
        case topLocked
        case freeTurntable
        case freeFly
    }

    public let cameraNode: SCNNode
    public let deviceCameraNode: SCNNode

    public var mode = Mode.thirdPerson {
        didSet {
            if self.mode != oldValue {
                self.updateCameraManagement()
            }
        }
    }

    public weak var sceneCameraController: SceneCameraControllable? {
        didSet {
            self.updateCameraManagement()
        }
    }

    public init(cameraNode: SCNNode, deviceCameraNode: SCNNode) {
        self.cameraNode = cameraNode
        self.deviceCameraNode = deviceCameraNode

        self.updateCameraManagement()
    }

    // MARK: - Internal

    var viewingOrientationAngle: Float = 0 {
        didSet {
            if self.viewingOrientationAngle != oldValue {
                self.updateCameraManagement()
            }
        }
    }

    // MARK: - Private

    private func updateCameraManagement() {
        let constraints: [SCNConstraint]
        let interactionMode: SCNInteractionMode?

        switch self.mode {
        case .firstPerson:
            let replicator = SCNReplicatorConstraint(target: self.deviceCameraNode)
            replicator.orientationOffset = SCNQuaternion(angle: self.viewingOrientationAngle, axis: SCNVector3(x: 0, y: 0, z: 1))

            constraints = [ replicator ]
            interactionMode = nil

        case .thirdPerson:
            let replicator = SCNReplicatorConstraint(target: self.deviceCameraNode)
            replicator.orientationOffset = SCNQuaternion(angle: self.viewingOrientationAngle, axis: SCNVector3(x: 0, y: 0, z: 1))

            let positionConstraint = SCNTransformConstraint.positionConstraint(inWorldSpace: true) { [deviceCameraNode = self.deviceCameraNode] node, position -> SCNVector3 in
                // Move the camera 1 meter behind the device camera, following its "look at" vector, and a little bit higher
                return position - deviceCameraNode.worldFront * 1 + SCNVector3(0, 0.3, 0)
            }

            constraints = [ replicator, positionConstraint ]
            interactionMode = nil

        case .topLocked:
            let replicator = SCNReplicatorConstraint(target: self.deviceCameraNode)
            replicator.positionOffset = SCNVector3(x: 0, y: 1, z: 0)
            replicator.replicatesOrientation = false
            replicator.replicatesScale = false

            let rotationConstraint = SCNTransformConstraint.orientationConstraint(inWorldSpace: true) { _, _ -> SCNQuaternion in
                return SCNQuaternion(angle: -.pi / 2, axis: SCNVector3(x: 1, y: 0, z: 0))
            }

            constraints = [ replicator, rotationConstraint ]
            interactionMode = nil

        case .freeTurntable:
            constraints = []
            interactionMode = .orbitTurntable

        case .freeFly:
            constraints = []
            interactionMode = .fly
        }
        
        self.cameraNode.constraints = constraints

        if let sceneCameraController = self.sceneCameraController {
            if let interactionMode = interactionMode {
                sceneCameraController.allowsCameraControl = true
                sceneCameraController.defaultCameraController.interactionMode = interactionMode
            } else {
                sceneCameraController.allowsCameraControl = false
                sceneCameraController.pointOfView = self.cameraNode
            }
        }

        // Hide the camera node in first-person mode to avoid obstructing the view
        self.deviceCameraNode.isHidden = self.mode == .firstPerson
    }

}

// MARK: - Scene controllable protocol

public protocol SceneCameraControllable: AnyObject {
    var allowsCameraControl: Bool { get set }
    var pointOfView: SCNNode? { get set }
    var defaultCameraController: SCNCameraController { get }
}

extension SCNView: SceneCameraControllable { }

// MARK: - Extensions

extension CameraController.Mode: CustomStringConvertible {

    public var description: String {
        switch self {
        case .firstPerson:
            return NSLocalizedString("First Person", comment: "Camera controller mode title")
        case .thirdPerson:
            return NSLocalizedString("Third Person", comment: "Camera controller mode title")
        case .topLocked:
            return NSLocalizedString("Top-Down", comment: "Camera controller mode title")
        case .freeTurntable:
            return NSLocalizedString("Turntable", comment: "Camera controller mode title")
        case .freeFly:
            return NSLocalizedString("Fly", comment: "Camera controller mode title")
        }
    }

}

