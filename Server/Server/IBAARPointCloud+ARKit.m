//
//  Copyright © 2018 Itty Bitty Apps Pty Ltd. All rights reserved.
//

#import "IBAARPointCloud+ARKit.h"
#import "ARKit+IBAHelpers.h"

@implementation IBAARPointCloud (ARKit)

+ (instancetype)pointCloudWithARPointCloud:(ARPointCloud *)pointCloud samplingColorsUsingARFrame:(ARFrame *)frame
{
    NSData *sampledColors = [frame iba_sampledColorsForPointCloud:pointCloud];
    return [[self alloc] initWithCount:pointCloud.count points:pointCloud.points identifiers:pointCloud.identifiers colors:sampledColors.bytes];
}

@end
