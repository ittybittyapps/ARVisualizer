//
//  Copyright © 2018 Itty Bitty Apps Pty Ltd. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

final class ViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate, SessionServerDelegate {

    @IBOutlet var sceneView: ARSCNView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.server.delegate = self

        // Set the view's delegate
        self.sceneView.delegate = self
        self.sceneView.session.delegate = self

        // Show statistics such as fps and timing information
        self.sceneView.showsStatistics = true
        self.sceneView.debugOptions = [ ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints ]

        NotificationCenter.default.addObserver(self, selector: #selector(statusBarOrientationDidChange(_:)), name: UIApplication.didChangeStatusBarOrientationNotification, object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.sceneView.session.run(.makeBaseConfiguration())
    }

    // MARK: - Custom anchor placement

    private var exampleAnchor: ARAnchor?

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        if let anchor = self.exampleAnchor {
            self.sceneView.session.remove(anchor: anchor)
            self.exampleAnchor = nil
            return
        }

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
        if anchor is ARPlaneAnchor {
            return
        }

        let box = SCNBox(width: 0.05, height: 0.05, length: 0.05, chamferRadius: 0)
        box.firstMaterial?.diffuse.contents = UIColor.red
        node.addChildNode(SCNNode(geometry: box))
    }

    // MARK: - ARSessionDelegate

    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        self.generalProcessingQueue.async {
            self.processFrame(frame)
        }
    }

    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        self.generalProcessingQueue.async {
            for anchor in anchors {
                self.server.sendMessage(.anchorAdded(Anchor(arAnchor: anchor)))
            }
        }
    }

    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        self.generalProcessingQueue.async {
            for anchor in anchors {
                self.server.sendMessage(.anchorUpdated(Anchor(arAnchor: anchor)))
            }
        }
    }

    func session(_ session: ARSession, didRemove anchors: [ARAnchor]) {
        self.generalProcessingQueue.async {
            for anchor in anchors {
                self.server.sendMessage(.anchorRemoved(Anchor(arAnchor: anchor)))
            }
        }
    }

    // MARK: - SessionServerDelegate

    func sessionServerDidUpdateConnectedPeers(_ sessionServer: SessionServer) {
    }

    // MARK: - Private

    private let server = SessionServer()
    
    private let generalProcessingQueue = DispatchQueue(label: "com.ittybittyapps.ARVisualizer.Server.GeneralProcessing", qos: .userInitiated)
    private let pointCloudProcessingQueue = DispatchQueue(label: "com.ittybittyapps.ARVisualizer.Server.PointCloudProcessing", qos: .userInitiated)

    private var atomicInterfaceOrientation = AtomicValue(UIApplication.shared.statusBarOrientation)
    private var lastScheduledFeaturePoints: ARPointCloud?

    private func processFrame(_ frame: ARFrame) {
        let encodedFrame = Frame(arFrame: frame, viewingOrientation: self.atomicInterfaceOrientation.value)
        self.server.sendMessage(.frame(encodedFrame))

        if let featurePoints = frame.rawFeaturePoints, featurePoints != self.lastScheduledFeaturePoints {
            self.lastScheduledFeaturePoints = frame.rawFeaturePoints

            self.pointCloudProcessingQueue.async {
                self.processPointCloud(featurePoints, from: frame)
            }
        }
    }

    private func processPointCloud(_ pointCloud: ARPointCloud, from frame: ARFrame) {
        self.server.sendMessage(.pointCloud(PointCloud(arPointCloud: pointCloud, samplingColorsUsing: frame)))
    }

    @objc
    private func statusBarOrientationDidChange(_ notification: Notification) {
        self.atomicInterfaceOrientation.value = UIApplication.shared.statusBarOrientation
    }

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
