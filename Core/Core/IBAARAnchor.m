//
//  Copyright © 2018 Itty Bitty Apps Pty Ltd. All rights reserved.
//

#import "IBAARAnchor.h"
#import "NSCoder+IBACodingHelpers.h"

@implementation IBAARAnchor

static NSString * const kIBAARAnchorNameKey = @"nm";
static NSString * const kIBAARAnchorIdentifierKey = @"id";
static NSString * const kIBAARAnchorTransformKey = @"tran";
static NSString * const kIBAARAnchorTrackingStateKey = @"trS";

+ (BOOL)supportsSecureCoding
{
    return YES;
}

- (instancetype)initWithName:(NSString *)name
                  identifier:(NSUUID *)identifier
                   transform:(simd_float4x4)transform
               trackingState:(IBAARAnchorTrackingState)trackingState
{
    self = [super init];
    if (self) {
        _name = [name copy];
        _identifier = identifier;
        _transform = transform;
        _trackingState = trackingState;
    }

    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    NSUUID *identifier = [aDecoder decodeObjectOfClass:[NSUUID class] forKey:kIBAARAnchorIdentifierKey];
    if (identifier == nil) {
        [aDecoder iba_failWithValueNotFoundError];
        return nil;
    }

    return [self initWithName:[aDecoder decodeObjectOfClass:[NSString class] forKey:kIBAARAnchorNameKey]
                   identifier:identifier
                    transform:[aDecoder iba_decodeFloat4x4ForKey:kIBAARAnchorTransformKey]
                trackingState:[aDecoder decodeIntegerForKey:kIBAARAnchorTrackingStateKey]];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:kIBAARAnchorNameKey];
    [aCoder encodeObject:self.identifier forKey:kIBAARAnchorIdentifierKey];
    [aCoder iba_encodeFloat4x4:self.transform forKey:kIBAARAnchorTransformKey];
    [aCoder encodeInteger:self.trackingState forKey:kIBAARAnchorTrackingStateKey];
}

@end
