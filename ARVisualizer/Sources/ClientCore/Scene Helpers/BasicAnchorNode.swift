//
//  Copyright © 2018 Itty Bitty Apps Pty Ltd. All rights reserved.
//

import CCore
import SceneKit

final class BasicAnchorNode: SCNNode {

    init(anchor: Anchor) {
        super.init()

        self.name = anchor.name ?? "BasicAnchor"

        let geometry = SCNSphere(radius: Constants.placeholderGeometryRadius)
        geometry.isGeodesic = true
        geometry.segmentCount = Constants.placeholderGeometrySegments
        geometry.materials = [ BasicAnchorNode.material ]

        let placeholderNode = SCNNode(geometry: geometry)
        self.addChildNode(placeholderNode)

        let gizmoNode = AxesGizmoNode(size: Constants.gizmoSize)
        self.addChildNode(gizmoNode)

        self.update(with: anchor)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func update(with anchor: Anchor) {
        self.simdTransform = anchor.transform
    }

    // MARK: - Private

    private enum Constants {
        static let placeholderGeometryRadius: CGFloat = 0.05
        static let placeholderGeometrySegments = 8
        static let gizmoSize: CGFloat = 0.05
    }

    private static let material = SCNMaterial(solidColor: .purple, fillMode: .lines, isDoubleSided: true)

}
