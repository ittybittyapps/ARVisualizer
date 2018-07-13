//
//  Copyright © 2018 Itty Bitty Apps Pty Ltd. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Disable screen dimming
        application.isIdleTimerDisabled = true

        return false
    }

}
