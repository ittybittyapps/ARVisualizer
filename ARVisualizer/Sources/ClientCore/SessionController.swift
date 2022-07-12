//
//  Copyright © 2018 Itty Bitty Apps Pty Ltd. All rights reserved.
//

import CCore
import Foundation

public protocol SessionControllerDelegate: class {
    func sessionControllerDidUpdateConnectivity(_ sessionController: SessionController)
    func sessionController(_ sessionController: SessionController, didUpdate stats: SessionController.Stats)
}

public final class SessionController: NSObject, SessionClientDelegate {

    public struct Stats {
        public var lastFrameTimestampText = ""
        public var averageLatencyText = ""
        public var trackingStateText = ""
        public var worldMappingStateText = ""
        public var ambientIntensityText = ""
        public var ambientColorTemperatureText = ""
        public var pointsCountText = ""
        public var anchorsCountText = ""

        private var lastFrameReceived: Date?
        private var currentAverageLatency: TimeInterval?
    }

    public let sceneController: SceneController

    public private(set) var isConnected = false
    public private(set) var stats = Stats()

    public weak var delegate: SessionControllerDelegate?

    public init(sceneController: SceneController) {
        self.sceneController = sceneController

        super.init()

        self.sessionClient.delegate = self
    }

    // MARK: - SessionClientDelegate

    func sessionClientDidConnectToServer(_ client: SessionClient) {
        DispatchQueue.main.async {
            self.isConnected = true
            self.delegate?.sessionControllerDidUpdateConnectivity(self)
        }
    }

    func sessionClientDidDisconnectFromServer(_ client: SessionClient) {
        DispatchQueue.main.async {
            self.isConnected = false
            self.delegate?.sessionControllerDidUpdateConnectivity(self)
        }
    }

    func sessionClient(_ client: SessionClient, didReceive message: ServerMessage) {
        DispatchQueue.main.async {
            self.processMessage(message.wrapped)
        }
    }

    // MARK: - Private

    private let sessionClient = SessionClient()

    private func processMessage(_ message: ServerMessage.Wrapped) {
        switch message {
        case let .frame(frame):
            self.sceneController.updateFrame(frame)
            self.stats.update(with: frame)

        case let .pointCloud(pointCloud):
            self.sceneController.updatePointCloud(pointCloud)

        case let .anchorAdded(anchor):
            self.sceneController.addAnchor(anchor)

        case let .anchorUpdated(anchor):
            self.sceneController.updateAnchor(anchor)

        case let .anchorRemoved(anchor):
            self.sceneController.removeAnchor(anchor)

        case .invalid:
            break
        }

        self.stats.update(with: self.sceneController.model)
        self.delegate?.sessionController(self, didUpdate: self.stats)
    }

}

// MARK: - Private extensions

private extension SessionController.Stats {

    mutating func update(with frame: Frame) {
        if let lastReceive = self.lastFrameReceived {
            let delay = Date().timeIntervalSince(lastReceive)
            self.currentAverageLatency = ((self.currentAverageLatency ?? delay) * 59 + delay) / 60
        }
        self.lastFrameReceived = Date()

        self.lastFrameTimestampText = String(format: "%.3f", frame.timestamp)
        self.averageLatencyText = String(format: "%.2f ms", (self.currentAverageLatency ?? 0) * 1000)

        self.trackingStateText = "Tracking: \(frame.camera.completeTrackingState.localizedDescription)"
        self.worldMappingStateText = "World mapping: \(frame.worldMappingStatus.localizedDescription)"

        let ambientIntensityDescription: String
        let ambientColorTemperatureDescription: String
        if let lightEstimate = frame.lightEstimate {
            ambientIntensityDescription = "\(Int(lightEstimate.ambientIntensity.rounded()))"
            ambientColorTemperatureDescription = "\(Int(lightEstimate.ambientColorTemperature.rounded())) K"
        } else {
            ambientIntensityDescription = "unavailable"
            ambientColorTemperatureDescription = "unavailable"
        }

        self.ambientIntensityText = "Ambient intensity: \(ambientIntensityDescription)"
        self.ambientColorTemperatureText = "Ambient color temperature: \(ambientColorTemperatureDescription)"
    }

    mutating func update(with model: SessionModel) {
        self.pointsCountText = "\(model.accumulatedPointCloud.count) points"
        self.anchorsCountText = "\(model.anchors.count) total anchors"
    }

}
