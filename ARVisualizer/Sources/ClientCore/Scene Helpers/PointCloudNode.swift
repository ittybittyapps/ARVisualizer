//
//  Copyright © 2018 Itty Bitty Apps Pty Ltd. All rights reserved.
//

import CCore
import SceneKit

final class PointCloudNode: SCNNode {

    let material = PointCloudMaterial()

    override var geometry: SCNGeometry? {
        didSet {
            self.geometry?.materials = [ self.material ]
        }
    }

    override init() {
        super.init()

        self.name = "PointCloud"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateWithPointCloud(_ pointCloud: PointCloud?) {
        self.geometry = pointCloud.map(SCNGeometry.makeWithPointCloud)
    }

    func updateWithAccumulatedPointCloud(_ pointCloud: AccumulatedPointCloud) {
        self.geometry = pointCloud.withPointAndColorBuffers {
            SCNGeometry.makeWithPoints($0, colors: $1)
        }
    }

}

// MARK: - Private extensions

private extension SCNGeometry {

    static func makeWithPointCloud(_ pointCloud: PointCloud) -> Self {
        let pointsCount = Int(pointCloud.count)
        let points = UnsafeBufferPointer(start: pointCloud.points, count: pointsCount)
        let colors = UnsafeBufferPointer(start: pointCloud.colors, count: pointsCount)
        return self.makeWithPoints(points, colors: colors)
    }

    static func makeWithPoints(_ points: UnsafeBufferPointer<simd_float3>, colors: UnsafeBufferPointer<simd_float3>) -> Self {
        let vertexSource = SCNGeometrySource(vertices: points)
        let colorsSource = SCNGeometrySource(colors: colors)
        let element = SCNGeometryElement(data: nil, primitiveType: .point, primitiveCount: points.count, bytesPerIndex: 0)
        element.pointSize = Constants.pointSize
        element.minimumPointScreenSpaceRadius = Constants.minimumPointScreenSpaceRadius
        element.maximumPointScreenSpaceRadius = Constants.maximumPointScreenSpaceRadius

        return self.init(sources: [ vertexSource, colorsSource ], elements: [ element ])
    }

    private enum Constants {
        static let pointSize: CGFloat = 0.001
        static let minimumPointScreenSpaceRadius: CGFloat = 6
        static let maximumPointScreenSpaceRadius: CGFloat = 36
    }

}
