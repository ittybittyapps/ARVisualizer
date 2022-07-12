//
//  Copyright © 2018 Itty Bitty Apps Pty Ltd. All rights reserved.
//

#import <CCore/IBAARLightEstimate.h>

@implementation IBAARLightEstimate

static NSString * const kIBAARLightEstimateAmbientIntensityKey = @"AI";
static NSString * const kIBAARLightEstimateAmbientColorTemperatureKey = @"ACT";

+ (BOOL)supportsSecureCoding
{
    return YES;
}

- (instancetype)initWithAmbientIntensity:(float)ambientIntensity ambientColorTemperature:(float)ambientColorTemperature
{
    self = [super init];
    if (self) {
        _ambientIntensity = ambientIntensity;
        _ambientColorTemperature = ambientColorTemperature;
    }

    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    return [self initWithAmbientIntensity:[aDecoder decodeFloatForKey:kIBAARLightEstimateAmbientIntensityKey]
                  ambientColorTemperature:[aDecoder decodeFloatForKey:kIBAARLightEstimateAmbientColorTemperatureKey]];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeFloat:self.ambientIntensity forKey:kIBAARLightEstimateAmbientIntensityKey];
    [aCoder encodeFloat:self.ambientColorTemperature forKey:kIBAARLightEstimateAmbientColorTemperatureKey];
}

@end
