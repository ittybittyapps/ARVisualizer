//
//  Copyright © 2018 Itty Bitty Apps Pty Ltd. All rights reserved.
//

import SceneKit

final class GridNode: SCNNode {

    var size = CGSize.zero {
        didSet {
            self.plane.width = self.size.width
            self.plane.height = self.size.height
            self.material.size = self.size
        }
    }

    override init() {
        super.init()

        self.name = "Grid"

        self.plane.materials = [ self.material ]

        let planeNode = SCNNode(geometry: self.plane)
        planeNode.eulerAngles.x = .pi / 2
        self.addChildNode(planeNode)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let plane = SCNPlane(width: 0, height: 0)
    private let material = GridMaterial()

}

// MARK: - GridMaterial

@objc(IBAARGridMaterial)
private final class GridMaterial: SCNMaterial {

    var size = CGSize.zero {
        didSet {
            self.diffuse.contentsTransform = SCNMatrix4MakeScale(SCNFloat(self.size.width / Constants.subdivisionSize),
                                                                 SCNFloat(self.size.height / Constants.subdivisionSize),
                                                                 1)
        }
    }

    override init() {
        super.init()

        self.lightingModel = .constant
        self.writesToDepthBuffer = false
        self.isDoubleSided = true
        self.locksAmbientWithDiffuse = true
        self.diffuse.contents = GridMaterial.texture
        self.diffuse.wrapS = .repeat
        self.diffuse.wrapT = .repeat
        self.diffuse.mipFilter = .linear
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private enum Constants {
        static let subdivisionSize: CGFloat = 0.1
        static let imageSize: CGFloat = 128
        static let imageLineThickness: CGFloat = 4
    }

    private static let texture = Image.render(size: CGSize(width: Constants.imageSize, height: Constants.imageSize)) { rect in
        let path = BezierPath(rect: rect)
        path.lineWidth = Constants.imageLineThickness
        Color.white.setStroke()
        path.stroke()
    }

}
