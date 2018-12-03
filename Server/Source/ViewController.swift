//
//  Copyright © 2018 Itty Bitty Apps Pty Ltd. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

final class ViewController: UIViewController, ARSCNViewDelegate, SessionServerDelegate {

    @IBOutlet var sceneView: ARSCNView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.server.delegate = self
        self.sceneView.delegate = self

        self.sceneView.session.delegate = self.processor

        // Show statistics such as fps and timing information
        self.sceneView.showsStatistics = true
        self.sceneView.debugOptions = [ ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints ]
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.sceneView.session.run(.makeBaseConfiguration())
    }

    // MARK: - Custom anchor placement

    private var exampleAnchor: ARAnchor?

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        // Remove the example anchor if it's already added
        if let anchor = self.exampleAnchor {
            self.sceneView.session.remove(anchor: anchor)
            self.exampleAnchor = nil
            return
        }

        // Hit-test a plane location under touch and place an example achor on it
        guard let point = touches.first?.location(in: self.view) else {
            return
        }
        guard let hitResult = self.sceneView.hitTest(point, types: [ .estimatedHorizontalPlane, .existingPlaneUsingExtent ]).first else {
            return
        }

        let anchor = ARAnchor(transform: hitResult.worldTransform)
        self.exampleAnchor = anchor
        self.sceneView.session.add(anchor: anchor)
    }

    // MARK: - ARSCNViewDelegate

    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
    }

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // Render a red box to represent the example anchor
        if anchor === self.exampleAnchor {
            let box = SCNBox(width: 0.05, height: 0.05, length: 0.05, chamferRadius: 0)
            box.firstMaterial?.diffuse.contents = UIColor.red
            node.addChildNode(SCNNode(geometry: box))
        }
    }

    // MARK: - SessionServerDelegate

    func sessionServerDidUpdateConnectedPeers(_ sessionServer: SessionServer) { }

    // MARK: - Private

    private let server = SessionServer()
    private lazy var processor = SessionProcessor(server: self.server)

}

// MARK: - Private extensions

private extension ARConfiguration {

    static func makeBaseConfiguration() -> ARConfiguration {
        let configuration = ARWorldTrackingConfiguration()
        if #available(iOS 11.3, *) {
            configuration.planeDetection = [ .horizontal, .vertical ]
        } else {
            configuration.planeDetection = [ .horizontal ]
        }

        return configuration
    }

}
