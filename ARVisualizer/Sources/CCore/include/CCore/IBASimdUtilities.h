//
//  Copyright © 2018 Itty Bitty Apps Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <simd/simd.h>

NS_ASSUME_NONNULL_BEGIN

static inline
simd_float3 IBATranslationFromTransform(simd_float4x4 transform)
{
    return simd_make_float3(transform.columns[3]);
}

NS_ASSUME_NONNULL_END
