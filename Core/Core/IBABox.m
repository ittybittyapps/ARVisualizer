//
//  Copyright © 2018 Itty Bitty Apps Pty Ltd. All rights reserved.
//

#import "IBABox.h"

@implementation IBABox

+ (IBABox *)emptyBox
{
    return [self boxAtPoint:simd_make_float3(0.0f)];
}

+ (instancetype)boxAtPoint:(simd_float3)point
{
    return [[self alloc] initWithMinCorner:point maxCorner:point];
}

+ (instancetype)boxWithSize:(simd_float3)size
{
    return [self boxWithCenter:simd_make_float3(0.0f) size:size];
}

+ (instancetype)boxWithCenter:(simd_float3)center size:(simd_float3)size
{
    simd_float3 halfSize = size / 2;
    return [[self alloc] initWithMinCorner:center - halfSize maxCorner:center + halfSize];
}

- (instancetype)initWithMinCorner:(simd_float3)minCorner maxCorner:(simd_float3)maxCorner
{
    self = [super init];
    if (self) {
        _minCorner = minCorner;
        _maxCorner = maxCorner;

        NSAssert([self isValid], @"Box corners must be valid!");
    }

    return self;
}

- (BOOL)isValid
{
    return simd_all(self.size >= 0.0f);
}

- (simd_float3)center
{
    return (self.minCorner + self.maxCorner) / 2;
}

- (simd_float3)size
{
    return self.maxCorner - self.minCorner;
}

- (BOOL)intersectsBox:(IBABox *)other
{
    return simd_all(self.maxCorner >= other.minCorner) && simd_all(other.maxCorner >= self.minCorner);
}

- (IBABox *)unionWithBox:(IBABox *)other
{
    simd_float3 minCorner = simd_min(self.minCorner, other.minCorner);
    simd_float3 maxCorner = simd_max(self.maxCorner, other.maxCorner);

    return [[IBABox alloc] initWithMinCorner:minCorner maxCorner:maxCorner];
}

@end
