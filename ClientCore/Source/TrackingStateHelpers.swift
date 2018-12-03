//
//  Copyright © 2018 Itty Bitty Apps Pty Ltd. All rights reserved.
//

import Core

extension Camera {

    enum CompleteTrackingState {
        case notAvailable
        case limited(Reason)
        case normal

        enum Reason {
            case initializing
            case excessiveMotion
            case insufficientFeatures
            case relocalizing
        }
    }

    var completeTrackingState: CompleteTrackingState {
        switch self.trackingState {
        case .notAvailable:
            return .notAvailable

        case .limited:
            switch self.trackingStateReason {
            case .none:
                return .notAvailable
            case .initializing:
                return .limited(.initializing)
            case .excessiveMotion:
                return .limited(.excessiveMotion)
            case .insufficientFeatures:
                return .limited(.insufficientFeatures)
            case .relocalizing:
                return .limited(.relocalizing)
            }

        case .normal:
            return .normal
        }
    }

}

extension Camera.CompleteTrackingState {

    var localizedDescription: String {
        switch self {
        case .notAvailable:
            return NSLocalizedString("Not available", comment: "Camera tracking state")
        case .limited(let reason):
            switch reason {
            case .initializing:
                return NSLocalizedString("Initializing", comment: "Camera tracking state")
            case .excessiveMotion:
                return NSLocalizedString("Excessive motion", comment: "Camera tracking state")
            case .insufficientFeatures:
                return NSLocalizedString("Insufficient features", comment: "Camera tracking state")
            case .relocalizing:
                return NSLocalizedString("Relocalizing", comment: "Camera tracking state")
            }
        case .normal:
            return NSLocalizedString("Normal", comment: "Camera tracking state")
        }
    }

}

extension Frame.WorldMappingStatus {

    var localizedDescription: String {
        switch self {
        case .notAvailable:
            return NSLocalizedString("Not available", comment: "Frame world mapping status")
        case .limited:
            return NSLocalizedString("Limited", comment: "Frame world mapping status")
        case .extending:
            return NSLocalizedString("Extending", comment: "Frame world mapping status")
        case .mapped:
            return NSLocalizedString("Mapped", comment: "Frame world mapping status")
        }
    }

}
