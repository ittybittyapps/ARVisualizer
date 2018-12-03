//
//  Copyright © 2018 Itty Bitty Apps Pty Ltd. All rights reserved.
//

#import "IBAARFrame.h"
#import "IBAARCamera.h"
#import "IBAARLightEstimate.h"
#import "IBAARPointCloud.h"
#import "NSCoder+IBACodingHelpers.h"

@implementation IBAARFrame

static NSString * const kIBAARFrameTimestampKey = @"time";
static NSString * const kIBAARFrameCameraKey = @"cam";
static NSString * const kIBAARFrameLightEstimateKey = @"LE";
static NSString * const kIBAARFrameWorldMappingStatusKey = @"WMS";
static NSString * const kIBAARFrameEstimatedHorizontalPlanePositionKey = @"EHPP";
static NSString * const kIBAARFrameViewingOrientationAngleKey = @"VOA";

+ (BOOL)supportsSecureCoding
{
    return YES;
}

- (instancetype)initWithTimestamp:(NSTimeInterval)timestamp
                           camera:(IBAARCamera *)camera
                    lightEstimate:(IBAARLightEstimate *)lightEstimate
               worldMappingStatus:(IBAARWorldMappingStatus)worldMappingStatus
 estimatedHorizontalPlanePosition:(float)estimatedHorizontalPlanePosition
          viewingOrientationAngle:(float)viewingOrientationAngle
{
    NSParameterAssert(camera != nil);

    self = [super init];
    if (self) {
        _timestamp = timestamp;
        _camera = camera;
        _lightEstimate = lightEstimate;
        _worldMappingStatus = worldMappingStatus;
        _estimatedHorizontalPlanePosition = estimatedHorizontalPlanePosition;
        _viewingOrientationAngle = viewingOrientationAngle;
    }

    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    IBAARCamera *camera = [aDecoder decodeObjectOfClass:[IBAARCamera class] forKey:kIBAARFrameCameraKey];
    if (camera == nil) {
        [aDecoder iba_failWithValueNotFoundError];
        return nil;
    }

    return [self initWithTimestamp:[aDecoder decodeDoubleForKey:kIBAARFrameTimestampKey]
                            camera:camera
                     lightEstimate:[aDecoder decodeObjectOfClass:[IBAARLightEstimate class] forKey:kIBAARFrameLightEstimateKey]
                worldMappingStatus:[aDecoder decodeIntegerForKey:kIBAARFrameWorldMappingStatusKey]
  estimatedHorizontalPlanePosition:[aDecoder decodeFloatForKey:kIBAARFrameEstimatedHorizontalPlanePositionKey]
            viewingOrientationAngle:[aDecoder decodeFloatForKey:kIBAARFrameViewingOrientationAngleKey]];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeDouble:self.timestamp forKey:kIBAARFrameTimestampKey];
    [aCoder encodeObject:self.camera forKey:kIBAARFrameCameraKey];
    [aCoder encodeObject:self.lightEstimate forKey:kIBAARFrameLightEstimateKey];
    [aCoder encodeInteger:self.worldMappingStatus forKey:kIBAARFrameWorldMappingStatusKey];
    [aCoder encodeFloat:self.estimatedHorizontalPlanePosition forKey:kIBAARFrameEstimatedHorizontalPlanePositionKey];
    [aCoder encodeFloat:self.viewingOrientationAngle forKey:kIBAARFrameViewingOrientationAngleKey];
}

@end
