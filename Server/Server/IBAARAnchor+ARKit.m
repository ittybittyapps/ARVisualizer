//
//  Copyright © 2018 Itty Bitty Apps Pty Ltd. All rights reserved.
//

#import "IBAARAnchor+ARKit.h"
#import "IBAARPlaneGeometry+ARKit.h"

@implementation IBAARAnchor (ARKit)

+ (IBAARAnchor *)anchorWithARAnchor:(ARAnchor *)anchor
{
    if ([anchor isKindOfClass:[ARPlaneAnchor class]]) {
        ARPlaneAnchor *planeAnchor = (ARPlaneAnchor *)anchor;

        IBAARPlaneGeometry *planeGeometry;
        if (@available(iOS 11.3, *)) {
            planeGeometry = [IBAARPlaneGeometry planeGeometryWithARPlaneGeometry:planeAnchor.geometry];
        }

        return [[IBAARPlaneAnchor alloc] initWithIdentifier:planeAnchor.identifier
                                                  transform:planeAnchor.transform
                                                  alignment:(IBAARPlaneAnchorAlignment)planeAnchor.alignment
                                                     center:planeAnchor.center
                                                     extent:planeAnchor.extent
                                                   geometry:planeGeometry];
    } else {
        NSString *name;
        if (@available(iOS 12.0, *)) {
            name = anchor.name;
        }

        IBAARAnchorTrackingState trackingState;
        if ([anchor conformsToProtocol:@protocol(ARTrackable)]) {
            trackingState = ((id<ARTrackable>)anchor).isTracked ? IBAARAnchorTrackingStateTracked : IBAARAnchorTrackingStateNotTracked;
        } else {
            trackingState = IBAARAnchorTrackingStateNotSupported;
        }

        return [[IBAARAnchor alloc] initWithName:name
                                      identifier:anchor.identifier
                                       transform:anchor.transform
                                   trackingState:trackingState];
    }
}

@end
