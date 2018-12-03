//
//  Copyright © 2018 Itty Bitty Apps Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <simd/simd.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(Box)
@interface IBABox : NSObject

@property (class, nonatomic, readonly) IBABox *emptyBox NS_SWIFT_NAME(empty);

@property (nonatomic, readonly) simd_float3 minCorner;
@property (nonatomic, readonly) simd_float3 maxCorner;

@property (nonatomic, readonly) simd_float3 center;
@property (nonatomic, readonly) simd_float3 size;

+ (instancetype)boxAtPoint:(simd_float3)point;
+ (instancetype)boxWithSize:(simd_float3)size;
+ (instancetype)boxWithCenter:(simd_float3)center size:(simd_float3)size;

- (instancetype)initWithMinCorner:(simd_float3)minCorner maxCorner:(simd_float3)maxCorner NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (BOOL)intersectsBox:(IBABox *)other;
- (IBABox *)unionWithBox:(IBABox *)other;

@end

NS_ASSUME_NONNULL_END
