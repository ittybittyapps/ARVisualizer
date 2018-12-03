//
//  Copyright © 2018 Itty Bitty Apps Pty Ltd. All rights reserved.
//

import SceneKit

extension SCNGeometryElement {

    convenience init(triangleIndices: UnsafeBufferPointer<Int16>) {
        assert(triangleIndices.count % 3 == 0, "Number of triangle indices must be divisible by 3.")
        self.init(data: Data(buffer: triangleIndices),
                  primitiveType: .triangles,
                  primitiveCount: triangleIndices.count / 3,
                  bytesPerIndex: MemoryLayout<Int16>.size)
    }

}
