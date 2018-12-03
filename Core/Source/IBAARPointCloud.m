//
//  Copyright © 2018 Itty Bitty Apps Pty Ltd. All rights reserved.
//

#import "IBAARPointCloud.h"
#import "IBABox.h"
#import "IBAMemoryUtilities.h"
#import "NSCoder+IBACodingHelpers.h"

@interface IBAARPointCloud ()
{
    // Pointer property-backing ivars declared as non-const pointers
    simd_float3 *_points;
    uint64_t *_identifiers;
    simd_float3 *_colors;
}

@end

@implementation IBAARPointCloud

static NSString * const kIBAARPointCloudCountKey = @"c";
static NSString * const kIBAARPointCloudPointsKey = @"p";
static NSString * const kIBAARPointCloudIdentifiersKey = @"i";
static NSString * const kIBAARPointCloudColorsKey = @"col";

+ (BOOL)supportsSecureCoding
{
    return YES;
}

- (instancetype)initWithCount:(NSUInteger)count points:(const simd_float3 *)points identifiers:(const uint64_t *)identifiers colors:(const simd_float3 *)colors
{
    NSParameterAssert(points != NULL);
    NSParameterAssert(identifiers != NULL);
    NSParameterAssert(colors != NULL);

    self = [super init];
    if (self) {
        _count = count;
        _points = IBAArrayCopy(points, sizeof(simd_float3), count);
        _identifiers = IBAArrayCopy(identifiers, sizeof(uint64_t), count);
        _colors = IBAArrayCopy(colors, sizeof(simd_float3), count);
    }

    return self;
}

- (void)dealloc
{
    free(_points);
    free(_identifiers);
    free(_colors);
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    NSInteger count = [aDecoder decodeIntegerForKey:kIBAARPointCloudCountKey];
    if (count < 0) {
        [aDecoder iba_failWithReadCorruptError];
        return nil;
    }

    const simd_float3 *points = [aDecoder iba_decodeArrayNoCopyWithElementSize:sizeof(simd_float3) count:count forKey:kIBAARPointCloudPointsKey];
    const uint64_t *identifiers = [aDecoder iba_decodeArrayNoCopyWithElementSize:sizeof(uint64_t) count:count forKey:kIBAARPointCloudIdentifiersKey];
    const simd_float3 *colors = [aDecoder iba_decodeArrayNoCopyWithElementSize:sizeof(simd_float3) count:count forKey:kIBAARPointCloudColorsKey];

    if (points != NULL && identifiers != NULL && colors != NULL) {
        return [self initWithCount:count points:points identifiers:identifiers colors:colors];
    } else {
        return nil;
    }
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.count forKey:kIBAARPointCloudCountKey];
    [aCoder iba_encodeArrayWithElementSize:sizeof(simd_float3) count:self.count at:self.points forKey:kIBAARPointCloudPointsKey];
    [aCoder iba_encodeArrayWithElementSize:sizeof(uint64_t) count:self.count at:self.identifiers forKey:kIBAARPointCloudIdentifiersKey];
    [aCoder iba_encodeArrayWithElementSize:sizeof(simd_float3) count:self.count at:self.colors forKey:kIBAARPointCloudColorsKey];
}

- (IBABox *)boundingBox
{
    NSUInteger count = self.count;
    if (count == 0) {
        return nil;
    }

    simd_float3 min = simd_make_float3(FLT_MAX, FLT_MAX, FLT_MAX);
    simd_float3 max = simd_make_float3(-FLT_MAX, -FLT_MAX, -FLT_MAX);
    for (NSUInteger i = 0; i < count; i++) {
        simd_float3 point = self.points[i];
        min = simd_min(point, min);
        max = simd_max(point, max);
    }

    return [[IBABox alloc] initWithMinCorner:min maxCorner:max];
}

@end
