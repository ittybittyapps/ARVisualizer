//
//  Copyright © 2018 Itty Bitty Apps Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <simd/simd.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Reflects ARPlaneGeometry.
 */
NS_SWIFT_NAME(PlaneGeometry)
@interface IBAARPlaneGeometry : NSObject <NSSecureCoding>

@property (nonatomic, readonly) NSUInteger vertexCount;
@property (nonatomic, readonly) const simd_float3 *vertices;
@property (nonatomic, readonly) NSUInteger textureCoordinateCount;
@property (nonatomic, readonly) const simd_float2 *textureCoordinates;
@property (nonatomic, readonly) NSUInteger triangleIndexCount;
@property (nonatomic, readonly) const int16_t *triangleIndices;
@property (nonatomic, readonly) NSUInteger boundaryVertexCount;
@property (nonatomic, readonly) const simd_float3 *boundaryVertices;

@property (nonatomic, readonly) NSUInteger triangleCount;

- (instancetype)initWithVertexCount:(NSUInteger)vertexCount
                           vertices:(const simd_float3 *)vertices
             textureCoordinateCount:(NSUInteger)textureCoordinateCount
                 textureCoordinates:(const simd_float2 *)textureCoordinates
                 triangleIndexCount:(NSUInteger)triangleIndexCount
                    triangleIndices:(const int16_t *)triangleIndices
                boundaryVertexCount:(NSUInteger)boundaryVertexCount
                   boundaryVertices:(const simd_float3 *)boundaryVertices NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
