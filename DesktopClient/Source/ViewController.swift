//
//  Copyright © 2018 Itty Bitty Apps Pty Ltd. All rights reserved.
//

import Cocoa
import ClientCore
import SceneKit

final class ViewController: NSViewController, SessionControllerDelegate {

    @IBOutlet var sceneView: SCNView!

    @IBOutlet var timestampLabel: NSTextField!
    @IBOutlet var latencyLabel: NSTextField!
    @IBOutlet var pointsCountLabel: NSTextField!
    @IBOutlet var anchorsCountLabel: NSTextField!
    @IBOutlet var trackingStateLabel: NSTextField!
    @IBOutlet var worldMappingStateLabel: NSTextField!
    @IBOutlet var ambientIntensityLabel: NSTextField!
    @IBOutlet var ambientColorTemperatureLabel: NSTextField!

    @IBOutlet var cameraModePopUpButton: NSPopUpButton!
    @IBOutlet var pointCloudPopUpButton: NSPopUpButton!
    @IBOutlet var pointColoringPopUpButton: NSPopUpButton!
    @IBOutlet var planeAnchorsPopUpButton: NSPopUpButton!

    @IBOutlet var connectivityLabel: NSTextField!

    private let sceneController = SceneController()
    private var sessionController: SessionController!

    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(OSX 10.14, *) {
            self.view.appearance = NSAppearance(named: .darkAqua)
        } else {
            self.view.appearance = NSAppearance(named: .vibrantDark)
        }

        self.sessionController = SessionController(sceneController: self.sceneController)
        self.sessionController.delegate = self

        self.cameraModePopUpButton.configure(with: self.sceneController.cameraController.mode)
        self.pointCloudPopUpButton.configure(with: self.sceneController.pointCloudMode)
        self.pointColoringPopUpButton.configure(with: self.sceneController.pointColoringMode)
        self.planeAnchorsPopUpButton.configure(with: self.sceneController.planeAnchorsMode)

        self.sceneView.scene = self.sceneController.scene
        self.sceneView.delegate = self.sceneController
        self.sceneController.cameraController.sceneCameraController = self.sceneView
    }

    // MARK: - Actions

    @IBAction func changeCameraMode(_ sender: NSPopUpButton) {
        self.sceneController.cameraController.mode = sender.selectedEnumValue(defaultValue: .firstPerson)
    }

    @IBAction func changePointCloudMode(_ sender: NSPopUpButton) {
        self.sceneController.pointCloudMode = sender.selectedEnumValue(defaultValue: .none)
    }

    @IBAction func changePointColoringMode(_ sender: NSPopUpButton) {
        self.sceneController.pointColoringMode = sender.selectedEnumValue(defaultValue: .sampled)
    }

    @IBAction func changePlaneAnchorsMode(_ sender: NSPopUpButton) {
        self.sceneController.planeAnchorsMode = sender.selectedEnumValue(defaultValue: .none)
    }

    // MARK: - SessionControllerDelegate

    func sessionControllerDidUpdateConnectivity(_ sessionController: SessionController) {
        self.connectivityLabel.isHidden = sessionController.isConnected
    }

    func sessionController(_ sessionController: SessionController, didUpdate stats: SessionController.Stats) {
        self.timestampLabel.stringValue = stats.lastFrameTimestampText
        self.latencyLabel.stringValue = stats.averageLatencyText

        self.trackingStateLabel.stringValue = stats.trackingStateText
        self.worldMappingStateLabel.stringValue = stats.worldMappingStateText

        self.ambientIntensityLabel.stringValue = stats.ambientIntensityText
        self.ambientColorTemperatureLabel.stringValue = stats.ambientColorTemperatureText

        self.pointsCountLabel.stringValue = stats.pointsCountText
        self.anchorsCountLabel.stringValue = stats.anchorsCountText
    }

}

// MARK: - Private extensions

private extension NSPopUpButton {

    func configure<T>(with enumValue: T) where T: CaseIterable & CustomStringConvertible & RawRepresentable, T.RawValue == Int {
        self.removeAllItems()
        self.addItems(withTitles: type(of: enumValue).allCases.map { $0.description })
        self.selectItem(at: enumValue.rawValue)
    }

    func selectedEnumValue<T>(defaultValue: T) -> T where T: RawRepresentable, T.RawValue == Int {
        let selectedIndex = self.indexOfSelectedItem
        let optionalSelectedIndex = selectedIndex != -1 ? selectedIndex : nil
        return optionalSelectedIndex.flatMap(T.init(rawValue:)) ?? defaultValue
    }

}
