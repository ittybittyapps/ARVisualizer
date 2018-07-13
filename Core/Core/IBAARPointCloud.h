//
//  Copyright © 2018 Itty Bitty Apps Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <simd/simd.h>

@class IBABox;

NS_ASSUME_NONNULL_BEGIN

/**
 Reflects ARPointCloud.
 */
NS_SWIFT_NAME(PointCloud)
@interface IBAARPointCloud : NSObject <NSSecureCoding>

@property (nonatomic, readonly) NSUInteger count;
@property (nonatomic, readonly) const simd_float3 *points;
@property (nonatomic, readonly) const uint64_t *identifiers;
@property (nonatomic, readonly) const simd_float3 *colors;

@property (nonatomic, nullable, readonly) IBABox *boundingBox;

- (instancetype)initWithCount:(NSUInteger)count points:(const simd_float3 *)points identifiers:(const uint64_t *)identifiers colors:(const simd_float3 *)colors NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
