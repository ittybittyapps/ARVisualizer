//
//  Copyright © 2018 Itty Bitty Apps Pty Ltd. All rights reserved.
//

#import <Core/Core.h>
#import <ARKit/ARKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IBAARCamera (ARKit)

+ (instancetype)cameraWithARCamera:(ARCamera *)camera;

@end

NS_ASSUME_NONNULL_END
