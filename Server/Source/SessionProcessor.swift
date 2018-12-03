//
//  Copyright © 2018 Itty Bitty Apps Pty Ltd. All rights reserved.
//

import ARKit
import UIKit

final class SessionProcessor: NSObject {

    let server: SessionServer

    init(server: SessionServer) {
        self.server = server
        super.init()

        NotificationCenter.default.addObserver(self, selector: #selector(statusBarOrientationDidChange(_:)), name: UIApplication.didChangeStatusBarOrientationNotification, object: nil)
    }

    // MARK: - Private

    private let generalProcessingQueue = DispatchQueue(label: "com.ittybittyapps.ARVisualizer.Server.GeneralProcessing", qos: .userInitiated)
    private let pointCloudProcessingQueue = DispatchQueue(label: "com.ittybittyapps.ARVisualizer.Server.PointCloudProcessing", qos: .userInitiated)

    private let interfaceOrientation = AtomicValue(UIApplication.shared.statusBarOrientation)
    private var lastScheduledFeaturePoints: ARPointCloud?

    private func processFrame(_ frame: ARFrame) {
        let encodedFrame = Frame(arFrame: frame, viewingOrientation: self.interfaceOrientation.value)
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
        self.interfaceOrientation.value = UIApplication.shared.statusBarOrientation
    }

}

// MARK: - ARSessionDelegate

extension SessionProcessor: ARSessionDelegate {

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

}
