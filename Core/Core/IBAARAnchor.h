//
//  Copyright © 2018 Itty Bitty Apps Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <simd/simd.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Reflects anchor's tracking state as per ARTrackable, and whether it's supported.
 */
typedef NS_ENUM(NSInteger, IBAARAnchorTrackingState) {
    IBAARAnchorTrackingStateNotSupported = 0,
    IBAARAnchorTrackingStateNotTracked,
    IBAARAnchorTrackingStateTracked,
} NS_SWIFT_NAME(Anchor.TrackingState);

/**
 Reflects ARAnchor + ARTrackable.
 */
NS_SWIFT_NAME(Anchor)
@interface IBAARAnchor : NSObject <NSSecureCoding>

@property (nonatomic, nullable, copy, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSUUID *identifier;
@property (nonatomic, readonly) simd_float4x4 transform;
@property (nonatomic, readonly) IBAARAnchorTrackingState trackingState;

- (instancetype)initWithName:(nullable NSString *)name
                  identifier:(NSUUID *)identifier
                   transform:(simd_float4x4)transform
               trackingState:(IBAARAnchorTrackingState)trackingState NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
