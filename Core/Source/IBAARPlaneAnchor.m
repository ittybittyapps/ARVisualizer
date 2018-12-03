//
//  Copyright © 2018 Itty Bitty Apps Pty Ltd. All rights reserved.
//

#import "IBAARPlaneAnchor.h"
#import "NSCoder+IBACodingHelpers.h"

@implementation IBAARPlaneAnchor

static NSString * const kIBAARPlaneAnchorAlignmentKey = @"aln";
static NSString * const kIBAARPlaneAnchorCenterKey = @"cnt";
static NSString * const kIBAARPlaneAnchorExtentKey = @"ext";
static NSString * const kIBAARPlaneAnchorGeometryKey = @"geo";

+ (BOOL)supportsSecureCoding
{
    return YES;
}

- (instancetype)initWithIdentifier:(NSUUID *)identifier
                         transform:(simd_float4x4)transform
                         alignment:(IBAARPlaneAnchorAlignment)alignment
                            center:(simd_float3)center
                            extent:(simd_float3)extent
                          geometry:(IBAARPlaneGeometry *)geometry
{
    self = [super initWithName:nil identifier:identifier transform:transform trackingState:IBAARAnchorTrackingStateNotSupported];
    if (self) {
        _alignment = alignment;
        _center = center;
        _extent = extent;
        _geometry = geometry;
    }

    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _alignment = [aDecoder decodeIntegerForKey:kIBAARPlaneAnchorAlignmentKey];
        _center = [aDecoder iba_decodeFloat3ForKey:kIBAARPlaneAnchorCenterKey];
        _extent = [aDecoder iba_decodeFloat3ForKey:kIBAARPlaneAnchorExtentKey];
        _geometry = [aDecoder decodeObjectOfClass:[IBAARPlaneGeometry class] forKey:kIBAARPlaneAnchorGeometryKey];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];

    [aCoder encodeInteger:self.alignment forKey:kIBAARPlaneAnchorAlignmentKey];
    [aCoder iba_encodeFloat3:self.center forKey:kIBAARPlaneAnchorCenterKey];
    [aCoder iba_encodeFloat3:self.extent forKey:kIBAARPlaneAnchorExtentKey];
    [aCoder encodeObject:self.geometry forKey:kIBAARPlaneAnchorGeometryKey];
}

@end
