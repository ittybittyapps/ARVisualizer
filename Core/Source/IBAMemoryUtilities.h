//
//  Copyright © 2018 Itty Bitty Apps Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static inline
void *IBAArrayCopy(const void *source, NSUInteger elementSize, NSUInteger elementCount)
{
    const NSUInteger size = elementSize * elementCount;
    return memcpy(malloc(size), source, size);
}

NS_ASSUME_NONNULL_END
