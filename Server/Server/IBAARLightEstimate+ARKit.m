//
//  Copyright © 2018 Itty Bitty Apps Pty Ltd. All rights reserved.
//

#import "IBAARLightEstimate+ARKit.h"

@implementation IBAARLightEstimate (ARKit)

+ (instancetype)lightEstimateWithARLightEstimate:(ARLightEstimate *)lightEstimate
{
    return [[self alloc] initWithAmbientIntensity:lightEstimate.ambientIntensity
                          ambientColorTemperature:lightEstimate.ambientColorTemperature];
}

@end
