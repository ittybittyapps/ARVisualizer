//
//  Copyright © 2018 Itty Bitty Apps Pty Ltd. All rights reserved.
//

import UIKit
import ClientCore
import SceneKit

final class ViewController: UIViewController, SessionControllerDelegate {

    @IBOutlet var sceneView: SCNView!

    @IBOutlet var timestampLabel: UILabel!
    @IBOutlet var latencyLabel: UILabel!
    @IBOutlet var pointsCountLabel: UILabel!
    @IBOutlet var anchorsCountLabel: UILabel!
    @IBOutlet var trackingStateLabel: UILabel!
    @IBOutlet var worldMappingStateLabel: UILabel!
    @IBOutlet var ambientIntensityLabel: UILabel!
    @IBOutlet var ambientColorTemperatureLabel: UILabel!

    @IBOutlet var settingsVisualEffectView: UIVisualEffectView!

    private let sceneController = SceneController()
    private var sessionController: SessionController!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.sessionController = SessionController(sceneController: self.sceneController)
        self.sessionController.delegate = self

        self.sceneView.scene = self.sceneController.scene
        self.sceneView.delegate = self.sceneController
        self.sceneController.cameraController.sceneCameraController = self.sceneView

        self.sceneView.showsStatistics = true

        self.settingsVisualEffectView.layer.cornerRadius = 13
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        if segue.identifier == "EmbedSettings" {
            let viewController = segue.destination as! SettingsViewController
            viewController.sceneController = self.sceneController
        }
    }

    // MARK: - SessionControllerDelegate

    func sessionController(_ sessionController: SessionController, didUpdate stats: SessionController.Stats) {
        self.timestampLabel.text = stats.lastFrameTimestampText
        self.latencyLabel.text = stats.averageLatencyText

        self.trackingStateLabel.text = stats.trackingStateText
        self.worldMappingStateLabel.text = stats.worldMappingStateText

        self.ambientIntensityLabel.text = stats.ambientIntensityText
        self.ambientColorTemperatureLabel.text = stats.ambientColorTemperatureText

        self.pointsCountLabel.text = stats.pointsCountText
        self.anchorsCountLabel.text = stats.anchorsCountText
    }
    
}
