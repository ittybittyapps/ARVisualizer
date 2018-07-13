//
//  Copyright © 2018 Itty Bitty Apps Pty Ltd. All rights reserved.
//

import Core

struct AccumulatedPointCloud {

    var count: Int {
        return self.points.count
    }

    init() {
        let baseCapacity = 10000
        self.points.reserveCapacity(baseCapacity)
        self.colors.reserveCapacity(baseCapacity)
        self.identifiedIndices.reserveCapacity(baseCapacity)
    }

    mutating func appendPointCloud(_ pointCloud: PointCloud) {
        let identifiers = pointCloud.identifiers
        let points = pointCloud.points
        let colors = pointCloud.colors
        for index in (0 ..< Int(pointCloud.count)) {
            let identifier = identifiers[index]
            let point = points[index]
            let color = colors[index]

            if let existingIndex = self.identifiedIndices[identifier] {
                self.points[existingIndex] = point
                self.colors[existingIndex] = color
            } else {
                self.identifiedIndices[identifier] = self.points.endIndex
                self.points.append(point)
                self.colors.append(color)
            }
        }
    }

    func withPointAndColorBuffers<R>(_ body: (UnsafeBufferPointer<simd_float3>, UnsafeBufferPointer<simd_float3>) throws -> R) rethrows -> R {
        return try self.points.withUnsafeBufferPointer { points in
            return try self.colors.withUnsafeBufferPointer { colors in
                return try body(points, colors)
            }
        }
    }

    private var points = ContiguousArray<simd_float3>()
    private var colors = ContiguousArray<simd_float3>()
    private var identifiedIndices = [UInt64: Int]()

}
