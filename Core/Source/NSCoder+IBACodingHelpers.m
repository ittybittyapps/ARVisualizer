//
//  Copyright © 2018 Itty Bitty Apps Pty Ltd. All rights reserved.
//

#import "NSCoder+IBACodingHelpers.h"

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif

@implementation NSCoder (IBACodingHelpers)

#pragma mark Abstract coding

- (void)iba_encodeValueOfSize:(NSUInteger)size at:(const void *)addr forKey:(NSString *)key
{
    [self encodeBytes:addr length:size forKey:key];
}

- (BOOL)iba_decodeValueOfSize:(NSUInteger)size at:(void *)data forKey:(NSString *)key
{
    NSUInteger length = 0;
    const uint8_t *buffer = [self decodeBytesForKey:key returnedLength:&length];
    if (buffer == NULL) {
        [self iba_failWithValueNotFoundError];
        return NO;
    }

    if (length != size) {
        [self iba_failWithReadCorruptError];
        return NO;
    }

    memcpy(data, buffer, length);
    return YES;
}

- (void)iba_encodeArrayWithElementSize:(NSUInteger)size count:(NSUInteger)count at:(const void *)array forKey:(NSString *)key
{
    [self iba_encodeValueOfSize:size * count at:array forKey:key];
}

- (const void *)iba_decodeArrayNoCopyWithElementSize:(NSUInteger)size count:(NSUInteger)count forKey:(NSString *)key
{
    NSUInteger length = 0;
    const void *decodedBuffer = [self decodeBytesForKey:key returnedLength:&length];
    if (decodedBuffer == NULL) {
        [self iba_failWithValueNotFoundError];
        return nil;
    }

    if (length != size * count) {
        [self iba_failWithReadCorruptError];
        return nil;
    }

    return decodedBuffer;
}

- (void)iba_encodeArrayAndCountWithElementSize:(NSUInteger)size count:(NSUInteger)count at:(const void *)array forKey:(NSString *)key countKey:(NSString *)countKey
{
    [self encodeInteger:count forKey:countKey];
    [self iba_encodeArrayWithElementSize:size count:count at:array forKey:key];
}

- (const void *)iba_decodeArrayNoCopyAndCountWithElementSize:(NSUInteger)size count:(NSUInteger *)count forKey:(NSString *)key countKey:(NSString *)countKey
{
    NSInteger decodedCount = [self decodeIntegerForKey:countKey];
    if (count < 0) {
        [self iba_failWithReadCorruptError];
        return nil;
    }

    const void *decodedBuffer = [self iba_decodeArrayNoCopyWithElementSize:size count:decodedCount forKey:key];
    if (decodedBuffer == NULL) {
        return nil;
    }

    *count = decodedCount;
    return decodedBuffer;
}

#pragma mark - Structural coding

- (void)iba_encodeFloat3:(simd_float3)vector forKey:(NSString *)key
{
    [self iba_encodeValueOfSize:sizeof(vector) at:&vector forKey:key];
}

- (simd_float3)iba_decodeFloat3ForKey:(NSString *)key
{
    simd_float3 result = simd_make_float3(0);
    [self iba_decodeValueOfSize:sizeof(result) at:&result forKey:key];
    return result;
}

- (void)iba_encodeFloat3x3:(simd_float3x3)matrix forKey:(NSString *)key
{
    [self iba_encodeValueOfSize:sizeof(matrix) at:&matrix forKey:key];
}

- (simd_float3x3)iba_decodeFloat3x3ForKey:(NSString *)key
{
    simd_float3x3 result = matrix_identity_float3x3;
    [self iba_decodeValueOfSize:sizeof(result) at:&result forKey:key];
    return result;
}

- (void)iba_encodeFloat4x4:(simd_float4x4)matrix forKey:(NSString *)key
{
    [self iba_encodeValueOfSize:sizeof(matrix) at:&matrix forKey:key];
}

- (simd_float4x4)iba_decodeFloat4x4ForKey:(NSString *)key
{
    simd_float4x4 result = matrix_identity_float4x4;
    [self iba_decodeValueOfSize:sizeof(result) at:&result forKey:key];
    return result;
}

- (void)iba_encodeCGSize:(CGSize)size forKey:(NSString *)key
{
#if TARGET_OS_IPHONE
    [self encodeCGSize:size forKey:key];
#else
    [self encodeSize:NSSizeFromCGSize(size) forKey:key];
#endif
}

- (CGSize)iba_decodeCGSizeForKey:(NSString *)key
{
#if TARGET_OS_IPHONE
    return [self decodeCGSizeForKey:key];
#else
    return NSSizeToCGSize([self decodeSizeForKey:key]);
#endif
}

#pragma mark - Common failures

- (void)iba_failWithValueNotFoundError
{
    [self failWithError:[NSError errorWithDomain:NSCocoaErrorDomain code:NSCoderValueNotFoundError userInfo:nil]];
}

- (void)iba_failWithReadCorruptError
{
    [self failWithError:[NSError errorWithDomain:NSCocoaErrorDomain code:NSCoderReadCorruptError userInfo:nil]];
}

@end
