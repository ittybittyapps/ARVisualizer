//
//  Copyright © 2018 Itty Bitty Apps Pty Ltd. All rights reserved.
//

import SceneKit

final class PointCloudMaterial: SCNMaterial {

    enum ColorMode {
        case sampled
        case heightBased
    }

    var colorMode = ColorMode.sampled {
        didSet {
            self.shaderModifiers = self.colorMode.shaderModifiers
        }
    }

    override init() {
        super.init()

        self.lightingModel = .constant
        self.diffuse.contents = nil
        self.locksAmbientWithDiffuse = true

        self.shaderModifiers = self.colorMode.shaderModifiers
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setHeightRange(min: Float, max: Float) {
        if case .heightBased = self.colorMode {
            self.setValue(CGPoint(x: CGFloat(min), y: CGFloat(max)), forKey: ColorMode.Constants.heightRangeShaderUniformName)
        }
    }

}

// MARK: - Private extensions

private extension PointCloudMaterial.ColorMode {

    enum Constants {
        static let heightRangeShaderUniformName = "heightRange"
    }

    var shaderModifiers: [SCNShaderModifierEntryPoint : String] {
        switch self {
        case .sampled:
            // YCbCr to RGB conversion matrix credit https://developer.apple.com/documentation/arkit/arframe/2867984-capturedimage
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
            return [ .geometry: geometryShader ]

        case .heightBased:
            // HSV to RGB conversion function credit http://lolengine.net/blog/2013/07/27/rgb-to-hsv-in-glsl
            let surfaceShader =
            """
            uniform vec2 heightRange = vec2(0.0, 1.0);

            vec3 hsv2rgb(vec3 c)
            {
                const vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
                vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
                return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
            }

            #pragma body

            vec4 pointPosition = u_inverseModelViewTransform * vec4(_surface.position, 1.0);
            float fraction = (pointPosition.y - heightRange.x) / (heightRange.y - heightRange.x);
            float hue = mix(2.0 / 3.0, 0.0, fraction);
            _surface.diffuse.rgb = hsv2rgb(vec3(hue, 1.0, 1.0));
            """
            return [ .surface: surfaceShader ]
        }
    }

}
