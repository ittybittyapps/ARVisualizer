//
//  Copyright © 2018 Itty Bitty Apps Pty Ltd. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>
#import <simd/simd.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Reflects ARTrackingState.
 */
typedef NS_ENUM(NSInteger, IBAARTrackingState) {
    IBAARTrackingStateNotAvailable = 0,
    IBAARTrackingStateLimited,
    IBAARTrackingStateNormal,
} NS_SWIFT_NAME(Camera.TrackingState);

/**
 Reflects ARTrackingStateReason.
 */
typedef NS_ENUM(NSInteger, IBAARTrackingStateReason) {
    IBAARTrackingStateReasonNone = 0,
    IBAARTrackingStateReasonInitializing,
    IBAARTrackingStateReasonExcessiveMotion,
    IBAARTrackingStateReasonInsufficientFeatures,
    IBAARTrackingStateReasonRelocalizing
} NS_SWIFT_NAME(Camera.TrackingStateReason);

/**
 Reflects ARCamera.
 */
NS_SWIFT_NAME(Camera)
@interface IBAARCamera : NSObject <NSSecureCoding>

@property (nonatomic, readonly) IBAARTrackingState trackingState;
@property (nonatomic, readonly) IBAARTrackingStateReason trackingStateReason;

@property (nonatomic, readonly) simd_float4x4 transform;
@property (nonatomic, readonly) simd_float3 eulerAngles;

@property (nonatomic, readonly) simd_float3x3 intrinsics;
@property (nonatomic, readonly) CGSize imageResolution;
@property (nonatomic, readonly) simd_float4x4 projectionMatrix;

- (instancetype)initWithTrackingState:(IBAARTrackingState)trackingState
                  trackingStateReason:(IBAARTrackingStateReason)trackingStateReason
                            transform:(simd_float4x4)transform
                          eulerAngles:(simd_float3)eulerAngles
                           intrinsics:(simd_float3x3)intrinsics
                      imageResolution:(CGSize)imageResolution
                     projectionMatrix:(simd_float4x4)projectionMatrix NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
