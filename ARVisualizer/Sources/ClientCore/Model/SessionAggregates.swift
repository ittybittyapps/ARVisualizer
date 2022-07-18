//
//  Copyright © 2018 Itty Bitty Apps Pty Ltd. All rights reserved.
//

import CCore

struct SessionModel {

    private(set) var lastFrame: Frame?
    private(set) var anchors = [UUID: Anchor]()

    private(set) var floorPosition: Float = 0
    private(set) var featurePointsBoundingBox = Box(size: simd_float3(repeating: 1))
    private(set) var accumulatedPointCloud = AccumulatedPointCloud()

    mutating func update(with frame: Frame) {
        self.floorPosition = min(self.floorPosition, frame.estimatedHorizontalPlanePosition)
    }

    mutating func update(with featurePoints: PointCloud) {
        self.accumulatedPointCloud.appendPointCloud(featurePoints)

        if let boundingBox = featurePoints.boundingBox {
            self.featurePointsBoundingBox = self.featurePointsBoundingBox.union(with: boundingBox)
        }
    }

    mutating func updateAnchor(_ anchor: Anchor) {
        self.anchors[anchor.identifier] = anchor
    }

    mutating func removeAnchor(_ anchor: Anchor) {
        self.anchors[anchor.identifier] = nil
    }

}
