//
//  Copyright © 2018 Itty Bitty Apps Pty Ltd. All rights reserved.
//

import UIKit
import ClientCore

final class SettingsViewController: UITableViewController {

    @IBOutlet var cameraModeLabel: UILabel!
    @IBOutlet var pointCloudModeLabel: UILabel!
    @IBOutlet var planesModeLabel: UILabel!

    weak var sceneController: SceneController!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.optionControllers = [
            OptionController(value: self.sceneController.cameraController.mode,
                             label: self.cameraModeLabel,
                             valueApplier: { [weak self] in
                                self?.sceneController?.cameraController.mode = $0
            }),
            OptionController(value: self.sceneController.pointCloudMode,
                             label: self.pointCloudModeLabel,
                             valueApplier: { [weak self] in
                                self?.sceneController?.pointCloudMode = $0
            }),
            OptionController(value: self.sceneController.planeAnchorsMode,
                             label: self.planesModeLabel,
                             valueApplier: { [weak self] in
                                self?.sceneController?.planeAnchorsMode = $0
            })
        ]
    }

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else {
            return
        }

        self.optionControllers[indexPath.row].showMenu(from: self, sourceView: cell, rect: cell.bounds) { _ in
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    // MARK: - Private

    private var optionControllers = [OptionControllable]()

}

// MARK: - Option controller

private protocol OptionControllable {
    func showMenu(from viewController: UIViewController, sourceView: UIView, rect sourceRect: CGRect, completion: @escaping (Bool) -> Void)
}

private class OptionController<T>: OptionControllable where T: CaseIterable & RawRepresentable & Equatable & CustomStringConvertible, T.RawValue == Int {

    typealias ValueApplier = (T) -> Void

    let label: UILabel
    let items: [T]
    let valueApplier: ValueApplier

    private(set) var selectedIndex: Int?

    init(value: T, label: UILabel, valueApplier: @escaping ValueApplier) {
        self.label = label
        self.items = Array(T.allCases)
        self.valueApplier = valueApplier
        self.selectedIndex = self.items.firstIndex(of: value)

        label.text = value.description
    }

    func showMenu(from viewController: UIViewController, sourceView: UIView, rect sourceRect: CGRect, completion: @escaping (Bool) -> Void) {
        let items = self.items.map { $0.description }
        let menuController = MenuController(items: items, selectedIndex: self.selectedIndex) { [weak self] index in
            if let controller = self, let index = index {
                let newValue = controller.items[index]
                controller.selectedIndex = index
                controller.label.text = newValue.description
                controller.valueApplier(newValue)
            }

            completion(index != nil)
        }

        menuController.modalPresentationStyle = .popover
        if let popover = menuController.popoverPresentationController {
            popover.sourceView = sourceView
            popover.sourceRect = sourceRect
            popover.delegate = menuController
        }

        viewController.present(menuController, animated: true)
    }

}

// MARK: - Menu controller

private class MenuController: UITableViewController, UIPopoverPresentationControllerDelegate {

    let items: [String]
    let selectedIndex: Int?
    let completion: (Int?) -> Void

    init(items: [String], selectedIndex: Int?, completion: @escaping (Int?) -> Void) {
        self.items = items
        self.selectedIndex = selectedIndex
        self.completion = completion

        super.init(style: .plain)

        self.preferredContentSize.height = CGFloat(self.items.count * 44)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "Cell"
        let cell: UITableViewCell
        if let reusedCell = tableView.dequeueReusableCell(withIdentifier: identifier) {
            cell = reusedCell
        } else {
            cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
        }

        let isPreselected = self.selectedIndex == indexPath.row

        cell.textLabel?.text = self.items[indexPath.row]
        cell.accessoryType = isPreselected ? .checkmark : .none

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.completion(indexPath.row)
        self.presentingViewController?.dismiss(animated: true)
    }

    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        self.completion(nil)
        return true
    }

}
