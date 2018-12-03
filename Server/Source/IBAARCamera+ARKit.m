//
//  Copyright © 2018 Itty Bitty Apps Pty Ltd. All rights reserved.
//

#import "IBAARCamera+ARKit.h"

@implementation IBAARCamera (ARKit)

+ (instancetype)cameraWithARCamera:(ARCamera *)camera
{
    return [[self alloc] initWithTrackingState:(IBAARTrackingState)camera.trackingState
                           trackingStateReason:(IBAARTrackingStateReason)camera.trackingStateReason
                                     transform:camera.transform
                                   eulerAngles:camera.eulerAngles
                                    intrinsics:camera.intrinsics
                               imageResolution:camera.imageResolution
                              projectionMatrix:camera.projectionMatrix];
}

@end
