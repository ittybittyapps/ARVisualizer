//
//  Copyright © 2018 Itty Bitty Apps Pty Ltd. All rights reserved.
//

import SceneKit
import Core

final class BoundingBoxNode: SCNNode {

    init(box: Box) {
        super.init()

        self.name = "BoundingBox"
        self.geometry = BoundingBoxNode.geometry

        self.update(with: box)
    }

    override convenience init() {
        self.init(box: .empty)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func update(with box: Box) {
        self.simdPosition = box.center
        self.simdScale = box.size
    }

    // MARK: - Private

    private static let geometry: SCNGeometry = {
        let geometry = SCNGeometry.makeBoundingBox()
        geometry.materials = [ .init(solidColor: .white, fillMode: .lines, isDoubleSided: true) ]
        return geometry
    }()

}

private extension SCNGeometry {

    /// 1x1x1 box made out of line segments
    static func makeBoundingBox() -> SCNGeometry {
        let vertices: [SCNVector3] = [
            .init(-0.5, -0.5, -0.5),
            .init(0.5, -0.5, -0.5),
            .init(0.5, -0.5, 0.5),
            .init(-0.5, -0.5, 0.5),

            .init(-0.5, 0.5, -0.5),
            .init(0.5, 0.5, -0.5),
            .init(0.5, 0.5, 0.5),
            .init(-0.5, 0.5, 0.5),
        ]
        let vertexSource = SCNGeometrySource(vertices: vertices)

        let indices: [Int8] = [
            0, 1,   1, 2,   2, 3,   3, 0,
            4, 5,   5, 6,   6, 7,   7, 4,
            0, 4,   1, 5,   2, 6,   3, 7
        ]
        let element = SCNGeometryElement(indices: indices, primitiveType: .line)

        return SCNGeometry(sources: [ vertexSource ], elements: [ element ])
    }

}
