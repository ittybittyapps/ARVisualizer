//
//  Copyright © 2018 Itty Bitty Apps Pty Ltd. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>
#import <simd/simd.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSCoder (IBACodingHelpers)

#pragma mark Abstract coding

- (void)iba_encodeValueOfSize:(NSUInteger)size at:(const void *)addr forKey:(NSString *)key;
- (BOOL)iba_decodeValueOfSize:(NSUInteger)size at:(void *)data forKey:(NSString *)key;

- (void)iba_encodeArrayWithElementSize:(NSUInteger)size count:(NSUInteger)count at:(const void *)array forKey:(NSString *)key;
- (nullable const void *)iba_decodeArrayNoCopyWithElementSize:(NSUInteger)size count:(NSUInteger)count forKey:(NSString *)key;

- (void)iba_encodeArrayAndCountWithElementSize:(NSUInteger)size count:(NSUInteger)count at:(const void *)array forKey:(NSString *)key countKey:(NSString *)countKey;
- (nullable const void *)iba_decodeArrayNoCopyAndCountWithElementSize:(NSUInteger)size count:(NSUInteger *)count forKey:(NSString *)key countKey:(NSString *)countKey;

#pragma mark Structural coding

- (void)iba_encodeFloat3:(simd_float3)vector forKey:(NSString *)key;
- (simd_float3)iba_decodeFloat3ForKey:(NSString *)key;

- (void)iba_encodeFloat3x3:(simd_float3x3)matrix forKey:(NSString *)key;
- (simd_float3x3)iba_decodeFloat3x3ForKey:(NSString *)key;

- (void)iba_encodeFloat4x4:(simd_float4x4)matrix forKey:(NSString *)key;
- (simd_float4x4)iba_decodeFloat4x4ForKey:(NSString *)key;

- (void)iba_encodeCGSize:(CGSize)size forKey:(NSString *)key;
- (CGSize)iba_decodeCGSizeForKey:(NSString *)key;

#pragma mark Common failures

- (void)iba_failWithValueNotFoundError;
- (void)iba_failWithReadCorruptError;

@end

NS_ASSUME_NONNULL_END
