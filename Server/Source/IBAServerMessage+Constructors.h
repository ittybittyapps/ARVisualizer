//
//  Copyright © 2018 Itty Bitty Apps Pty Ltd. All rights reserved.
//

#import <Core/Core.h>

NS_ASSUME_NONNULL_BEGIN

@interface IBAServerMessage (Constructors)

+ (instancetype)messageWithFrame:(IBAARFrame *)frame NS_SWIFT_NAME(frame(_:));
+ (instancetype)messageWithPointCloud:(IBAARPointCloud *)pointCloud NS_SWIFT_NAME(pointCloud(_:));
+ (instancetype)messageWithAddedAnchor:(IBAARAnchor *)anchor NS_SWIFT_NAME(anchorAdded(_:));
+ (instancetype)messageWithUpdatedAnchor:(IBAARAnchor *)anchor NS_SWIFT_NAME(anchorUpdated(_:));
+ (instancetype)messageWithRemovedAnchor:(IBAARAnchor *)anchor NS_SWIFT_NAME(anchorRemoved(_:));

@end

NS_ASSUME_NONNULL_END
