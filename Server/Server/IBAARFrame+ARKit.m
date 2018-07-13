//
//  Copyright © 2018 Itty Bitty Apps Pty Ltd. All rights reserved.
//

#import "IBAARFrame+ARKit.h"
#import "IBAARCamera+ARKit.h"
#import "IBAARLightEstimate+ARKit.h"
#import "IBAARPointCloud+ARKit.h"
#import "ARKit+IBAHelpers.h"

@implementation IBAARFrame (ARKit)

static float IBAInterfaceOrientationGetViewingAngle(UIInterfaceOrientation viewingOrientation)
{
    switch (viewingOrientation) {
        case UIInterfaceOrientationUnknown:
        case UIInterfaceOrientationLandscapeRight:
            return 0;
        case UIInterfaceOrientationPortrait:
            return M_PI_2;
        case UIInterfaceOrientationLandscapeLeft:
            return M_PI;
        case UIInterfaceOrientationPortraitUpsideDown:
            return M_PI_2 * 3;
    }
}

+ (instancetype)frameWithARFrame:(ARFrame *)frame viewingOrientation:(UIInterfaceOrientation)viewingOrientation
{
    IBAARLightEstimate *lightEstimate;
    if (frame.lightEstimate != nil) {
        lightEstimate = [IBAARLightEstimate lightEstimateWithARLightEstimate:frame.lightEstimate];
    }

    IBAARWorldMappingStatus worldMappingStatus = IBAARWorldMappingStatusNotAvailable;
    if (@available(iOS 12.0, *)) {
        worldMappingStatus = (IBAARWorldMappingStatus)frame.worldMappingStatus;
    }

    float viewingOrientationAngle = IBAInterfaceOrientationGetViewingAngle(viewingOrientation);

    return [[self alloc] initWithTimestamp:frame.timestamp
                                    camera:[IBAARCamera cameraWithARCamera:frame.camera]
                             lightEstimate:lightEstimate
                        worldMappingStatus:worldMappingStatus
          estimatedHorizontalPlanePosition:frame.iba_estimatedHorizontalPlanePosition
                   viewingOrientationAngle:viewingOrientationAngle];
}

@end
