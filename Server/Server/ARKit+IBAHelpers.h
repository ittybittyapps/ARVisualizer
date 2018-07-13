//
//  Copyright © 2018 Itty Bitty Apps Pty Ltd. All rights reserved.
//

#import <ARKit/ARKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ARFrame (IBAHelpers)

@property (nonatomic, readonly) float iba_estimatedHorizontalPlanePosition;

- (NSData *)iba_sampledColorsForPointCloud:(ARPointCloud *)pointCloud;

@end

NS_ASSUME_NONNULL_END
