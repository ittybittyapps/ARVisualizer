//
//  Copyright © 2018 Itty Bitty Apps Pty Ltd. All rights reserved.
//

#if canImport(Cocoa)
import Cocoa
#else
import UIKit
#endif

#if os(macOS)
typealias BezierPath = NSBezierPath
typealias Color = NSColor
typealias Image = NSImage
typealias SCNFloat = CGFloat
#else
typealias BezierPath = UIBezierPath
typealias Color = UIColor
typealias Image = UIImage
typealias SCNFloat = Float
#endif

extension Image {

    static func render(size: CGSize, actions: @escaping (CGRect) -> Void) -> Image {
        #if os(macOS)
        return NSImage(size: size, flipped: false) { rect in
            actions(rect)
            return true
        }
        #else
        return UIGraphicsImageRenderer(bounds: CGRect(origin: .zero, size: size)).image { context in
            actions(context.format.bounds)
        }
        #endif
    }

}
