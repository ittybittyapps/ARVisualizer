//
//  Copyright © 2018 Itty Bitty Apps Pty Ltd. All rights reserved.
//

#import <Core/Core.h>
#import <ARKit/ARKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IBAARPlaneGeometry (ARKit)

+ (instancetype)planeGeometryWithARPlaneGeometry:(ARPlaneGeometry *)planeGeometry API_AVAILABLE(ios(11.3));

@end

NS_ASSUME_NONNULL_END
