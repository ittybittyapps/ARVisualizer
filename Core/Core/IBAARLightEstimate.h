//
//  Copyright © 2018 Itty Bitty Apps Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Reflects ARLightEstimate.
 */
NS_SWIFT_NAME(LightEstimate)
@interface IBAARLightEstimate : NSObject <NSSecureCoding>

@property (nonatomic, readonly) float ambientIntensity;
@property (nonatomic, readonly) float ambientColorTemperature;

- (instancetype)initWithAmbientIntensity:(float)ambientIntensity ambientColorTemperature:(float)ambientColorTemperature NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
