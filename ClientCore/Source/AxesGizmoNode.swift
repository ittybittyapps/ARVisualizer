//
//  Copyright © 2018 Itty Bitty Apps Pty Ltd. All rights reserved.
//

import SceneKit

final class AxesGizmoNode: SCNNode {

    init(size: CGFloat) {
        super.init()

        self.name = "Gizmo"

        self.geometry = AxesGizmoNode.geometry
        self.scale = SCNVector3(size, size, size)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - Private

    private static let geometry = SCNGeometry.makeGizmo()

}

// MARK: - Private extensions

private extension SCNGeometry {

    static func makeGizmo() -> SCNGeometry {
        let container = SCNNode()

        let axisLength: CGFloat = 1
        let halfLength = axisLength / 2
        let axisThickness = axisLength * Constants.axisThicknessFactor

        // X
        let xBox = SCNBox(width: axisLength, height: axisThickness, length: axisThickness, chamferRadius: 0)
        xBox.materials = [ .init(solidColor: .red) ]

        let xBoxNode = SCNNode(geometry: xBox)
        xBoxNode.position.x = SCNFloat(halfLength)
        container.addChildNode(xBoxNode)

        // Y
        let yBox = SCNBox(width: axisThickness, height: axisLength, length: axisThickness, chamferRadius: 0)
        yBox.materials = [ .init(solidColor: .green) ]

        let yBoxNode = SCNNode(geometry: yBox)
        yBoxNode.position.y = SCNFloat(halfLength)
        container.addChildNode(yBoxNode)

        // Z
        let zBox = SCNBox(width: axisThickness, height: axisThickness, length: axisLength, chamferRadius: 0)
        zBox.materials = [ .init(solidColor: .blue) ]

        let zBoxNode = SCNNode(geometry: zBox)
        zBoxNode.position.z = SCNFloat(halfLength)
        container.addChildNode(zBoxNode)

        return container.flattenedClone().geometry!
    }

    private enum Constants {
        static let axisThicknessFactor: CGFloat = 0.02
    }

}
