//
//  Copyright © 2018 Itty Bitty Apps Pty Ltd. All rights reserved.
//

#import <Core/Core.h>
#import <ARKit/ARKit.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IBAARFrame (ARKit)

+ (instancetype)frameWithARFrame:(ARFrame *)frame viewingOrientation:(UIInterfaceOrientation)viewingOrientation;

@end

NS_ASSUME_NONNULL_END
