//
//  Copyright © 2018 Itty Bitty Apps Pty Ltd. All rights reserved.
//

#import <CCore/IBAARAnchor.h>
#import <CCore/IBAARPlaneGeometry.h>
#import <simd/simd.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Reflects ARPlaneAnchorAlignment.
 */
typedef NS_ENUM(NSInteger, IBAARPlaneAnchorAlignment) {
    IBAARPlaneAnchorAlignmentHorizontal = 0,
    IBAARPlaneAnchorAlignmentVertical
} NS_SWIFT_NAME(PlaneAnchor.Alignment);

/**
 Reflects ARPlaneAnchor + ARTrackable.
 */
NS_SWIFT_NAME(PlaneAnchor)
@interface IBAARPlaneAnchor : IBAARAnchor <NSSecureCoding>

@property (nonatomic, readonly) IBAARPlaneAnchorAlignment alignment;
@property (nonatomic, readonly) simd_float3 center;
@property (nonatomic, readonly) simd_float3 extent;
@property (nonatomic, nullable, strong, readonly) IBAARPlaneGeometry *geometry;

- (instancetype)initWithIdentifier:(NSUUID *)identifier
                         transform:(simd_float4x4)transform
                         alignment:(IBAARPlaneAnchorAlignment)alignment
                            center:(simd_float3)center
                            extent:(simd_float3)extent
                          geometry:(nullable IBAARPlaneGeometry *)geometry;

- (instancetype)initWithName:(nullable NSString *)name
                  identifier:(NSUUID *)identifier
                   transform:(simd_float4x4)transform
               trackingState:(IBAARAnchorTrackingState)trackingState NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
