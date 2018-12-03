//
//  Copyright © 2018 Itty Bitty Apps Pty Ltd. All rights reserved.
//

import Foundation

final class AtomicValue<T> {

    var value: T {
        get {
            return self.accessQueue.sync {
                return self.storage
            }
        }
        set {
            self.accessQueue.sync {
                self.storage = newValue
            }
        }
    }

    init(_ value: T) {
        self.storage = value
    }

    // MARK: - Private

    private var storage: T
    private let accessQueue = DispatchQueue(label: "com.ittybittyapps.ARVisualizer.Server.AtomicValue")

}
