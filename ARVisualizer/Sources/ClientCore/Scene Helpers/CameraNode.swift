//
//  Copyright © 2018 Itty Bitty Apps Pty Ltd. All rights reserved.
//

import SceneKit

final class CameraNode: SCNNode {

    override init() {
        super.init()

        self.name = "Camera"

        let camera = SCNCamera()
        camera.zNear = 0.001
        camera.zFar = 100.0

        self.camera = camera
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
