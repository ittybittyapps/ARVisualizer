//
//  Copyright © 2018 Itty Bitty Apps Pty Ltd. All rights reserved.
//

import Core

extension ServerMessage {

    enum Wrapped {
        case invalid
        case frame(Frame)
        case pointCloud(PointCloud)
        case anchorAdded(Anchor)
        case anchorUpdated(Anchor)
        case anchorRemoved(Anchor)
    }

    var wrapped: Wrapped {
        switch self.type {
        case .invalid:
            return .invalid
        case .frame:
            return .frame(self.payload as! Frame)
        case .pointCloud:
            return .pointCloud(self.payload as! PointCloud)
        case .anchorAdded:
            return .anchorAdded(self.payload as! Anchor)
        case .anchorUpdated:
            return .anchorUpdated(self.payload as! Anchor)
        case .anchorRemoved:
            return .anchorRemoved(self.payload as! Anchor)
        }
    }

}
