//
//  Copyright © 2018 Itty Bitty Apps Pty Ltd. All rights reserved.
//

import SceneKit

extension SCNGeometrySource {

    convenience init(vertices: UnsafeBufferPointer<simd_float3>) {
        self.init(data: Data(buffer: vertices),
                  semantic: .vertex,
                  vectorCount: vertices.count,
                  usesFloatComponents: true,
                  componentsPerVector: 3,
                  bytesPerComponent: MemoryLayout<Float>.size,
                  dataOffset: 0,
                  dataStride: MemoryLayout<simd_float3>.stride)
    }

    convenience init(textureCoordinates: UnsafeBufferPointer<simd_float2>) {
        self.init(data: Data(buffer: textureCoordinates),
                  semantic: .texcoord,
                  vectorCount: textureCoordinates.count,
                  usesFloatComponents: true,
                  componentsPerVector: 2,
                  bytesPerComponent: MemoryLayout<Float>.size,
                  dataOffset: 0,
                  dataStride: MemoryLayout<simd_float2>.stride)
    }

    convenience init(colors: UnsafeBufferPointer<simd_float3>) {
        self.init(data: Data(buffer: colors),
                  semantic: .color,
                  vectorCount: colors.count,
                  usesFloatComponents: true,
                  componentsPerVector: 3,
                  bytesPerComponent: MemoryLayout<Float>.size,
                  dataOffset: 0,
                  dataStride: MemoryLayout<simd_float3>.stride)
    }

}
