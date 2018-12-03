//
//  Copyright © 2018 Itty Bitty Apps Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IBAARCamera;
@class IBAARLightEstimate;
@class IBAARPointCloud;

NS_ASSUME_NONNULL_BEGIN

/**
 Reflects ARWorldMappingStatus.
 */
typedef NS_ENUM(NSInteger, IBAARWorldMappingStatus) {
    IBAARWorldMappingStatusNotAvailable = 0,
    IBAARWorldMappingStatusLimited,
    IBAARWorldMappingStatusExtending,
    IBAARWorldMappingStatusMapped
} NS_SWIFT_NAME(Frame.WorldMappingStatus);

/**
 (Partially) reflects ARFrame.
 */
NS_SWIFT_NAME(Frame)
@interface IBAARFrame : NSObject <NSSecureCoding>

@property (nonatomic, readonly) NSTimeInterval timestamp;
@property (nonatomic, strong, readonly) IBAARCamera *camera;
@property (nonatomic, nullable, strong, readonly) IBAARLightEstimate *lightEstimate;
@property (nonatomic, readonly) IBAARWorldMappingStatus worldMappingStatus;

@property (nonatomic, readonly) float estimatedHorizontalPlanePosition;
@property (nonatomic, readonly) float viewingOrientationAngle;

- (instancetype)initWithTimestamp:(NSTimeInterval)timestamp
                           camera:(IBAARCamera *)camera
                    lightEstimate:(nullable IBAARLightEstimate *)lightEstimate
               worldMappingStatus:(IBAARWorldMappingStatus)worldMappingStatus
 estimatedHorizontalPlanePosition:(float)estimatedHorizontalPlanePosition
          viewingOrientationAngle:(float)viewingOrientationAngle NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
