//
//  Copyright © 2018 Itty Bitty Apps Pty Ltd. All rights reserved.
//

import SceneKit

final class PointCloudMaterial: SCNMaterial {

    override init() {
        super.init()

        self.lightingModel = .constant
        self.diffuse.contents = nil
        self.locksAmbientWithDiffuse = true

        let geometryShader =
        """
        #pragma body
        const mat4 ycbcrToRGBTransform = mat4(
            vec4(+1.0000f, +1.0000f, +1.0000f, +0.0000f),
            vec4(+0.0000f, -0.3441f, +1.7720f, +0.0000f),
            vec4(+1.4020f, -0.7141f, +0.0000f, +0.0000f),
            vec4(-0.7010f, +0.5291f, -0.8860f, +1.0000f)
        );

        _geometry.color = ycbcrToRGBTransform * _geometry.color;
        """
        self.shaderModifiers = [ .geometry: geometryShader ]
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setHeightRange(min: Float, max: Float) {
        // No actions at the moment
    }

}
