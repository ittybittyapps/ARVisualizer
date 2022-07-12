//
//  Copyright © 2018 Itty Bitty Apps Pty Ltd. All rights reserved.
//

import SceneKit

final class DeviceCameraNode: SCNNode {

    override init() {
        super.init()

        self.name = "DeviceCamera"

        let geometry = SCNPyramid(width: Constants.pyramidSize, height: Constants.pyramidSize, length: Constants.pyramidSize)
        geometry.materials = [ DeviceCameraNode.material ]

        let pyramidNode = SCNNode(geometry: geometry)
        pyramidNode.pivot = SCNMatrix4MakeTranslation(0, SCNFloat(Constants.pyramidSize), 0)
        pyramidNode.eulerAngles.x = .pi / 2
        self.addChildNode(pyramidNode)

        let gizmoNode = AxesGizmoNode(size: Constants.gizmoSize)
        self.addChildNode(gizmoNode)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - Private

    private enum Constants {
        static let pyramidSize: CGFloat = 0.1
        static let gizmoSize: CGFloat = 0.1
    }

    private static let material = SCNMaterial(solidColor: .yellow, fillMode: .lines, isDoubleSided: true)

}
