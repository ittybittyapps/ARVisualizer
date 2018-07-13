//
//  Copyright © 2018 Itty Bitty Apps Pty Ltd. All rights reserved.
//

import SceneKit

extension SCNMaterial {

    convenience init(solidColor: Color, fillMode: SCNFillMode = .fill, isDoubleSided: Bool = false) {
        self.init()

        self.lightingModel = .constant
        self.locksAmbientWithDiffuse = true
        self.diffuse.contents = solidColor
        self.fillMode = fillMode
        self.isDoubleSided = isDoubleSided
    }

}
