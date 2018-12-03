//
//  Copyright © 2018 Itty Bitty Apps Pty Ltd. All rights reserved.
//

#import "IBAARCamera.h"
#import "NSCoder+IBACodingHelpers.h"

@implementation IBAARCamera

static NSString * const kIBAARCameraTrackingStateKey = @"trS";
static NSString * const kIBAARCameraTrackingStateReasonKey = @"trSR";
static NSString * const kIBAARCameraTransformKey = @"tran";
static NSString * const kIBAARCameraEulerAnglesKey = @"euA";
static NSString * const kIBAARCameraIntrinsicsKey = @"int";
static NSString * const kIBAARCameraImageResolutionKey = @"imR";
static NSString * const kIBAARCameraProjectionMatrixKey = @"projM";

+ (BOOL)supportsSecureCoding
{
    return YES;
}

- (instancetype)initWithTrackingState:(IBAARTrackingState)trackingState
                  trackingStateReason:(IBAARTrackingStateReason)trackingStateReason
                            transform:(simd_float4x4)transform
                          eulerAngles:(simd_float3)eulerAngles
                           intrinsics:(simd_float3x3)intrinsics
                      imageResolution:(CGSize)imageResolution
                     projectionMatrix:(simd_float4x4)projectionMatrix
{
    self = [super init];
    if (self) {
        _trackingState = trackingState;
        _trackingStateReason = trackingStateReason;
        _transform = transform;
        _eulerAngles = eulerAngles;
        _intrinsics = intrinsics;
        _imageResolution = imageResolution;
        _projectionMatrix = projectionMatrix;
    }

    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    return [self initWithTrackingState:[aDecoder decodeIntegerForKey:kIBAARCameraTrackingStateKey]
                   trackingStateReason:[aDecoder decodeIntegerForKey:kIBAARCameraTrackingStateReasonKey]
                             transform:[aDecoder iba_decodeFloat4x4ForKey:kIBAARCameraTransformKey]
                           eulerAngles:[aDecoder iba_decodeFloat3ForKey:kIBAARCameraEulerAnglesKey]
                            intrinsics:[aDecoder iba_decodeFloat3x3ForKey:kIBAARCameraIntrinsicsKey]
                       imageResolution:[aDecoder iba_decodeCGSizeForKey:kIBAARCameraImageResolutionKey]
                      projectionMatrix:[aDecoder iba_decodeFloat4x4ForKey:kIBAARCameraProjectionMatrixKey]];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.trackingState forKey:kIBAARCameraTrackingStateKey];
    [aCoder encodeInteger:self.trackingStateReason forKey:kIBAARCameraTrackingStateReasonKey];
    [aCoder iba_encodeFloat4x4:self.transform forKey:kIBAARCameraTransformKey];
    [aCoder iba_encodeFloat3:self.eulerAngles forKey:kIBAARCameraEulerAnglesKey];
    [aCoder iba_encodeFloat3x3:self.intrinsics forKey:kIBAARCameraIntrinsicsKey];
    [aCoder iba_encodeCGSize:self.imageResolution forKey:kIBAARCameraImageResolutionKey];
    [aCoder iba_encodeFloat4x4:self.projectionMatrix forKey:kIBAARCameraProjectionMatrixKey];
}

@end
