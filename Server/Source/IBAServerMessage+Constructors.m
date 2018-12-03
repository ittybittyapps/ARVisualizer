//
//  Copyright © 2018 Itty Bitty Apps Pty Ltd. All rights reserved.
//

#import "IBAServerMessage+Constructors.h"

@implementation IBAServerMessage (Constructors)

+ (instancetype)messageWithFrame:(IBAARFrame *)frame
{
    return [[self alloc] initWithType:IBAServerMessageTypeFrame payload:frame];
}

+ (instancetype)messageWithPointCloud:(IBAARPointCloud *)pointCloud
{
    return [[self alloc] initWithType:IBAServerMessageTypePointCloud payload:pointCloud];
}

+ (instancetype)messageWithAddedAnchor:(IBAARAnchor *)anchor
{
    return [[self alloc] initWithType:IBAServerMessageTypeAnchorAdded payload:anchor];
}

+ (instancetype)messageWithUpdatedAnchor:(IBAARAnchor *)anchor
{
    return [[self alloc] initWithType:IBAServerMessageTypeAnchorUpdated payload:anchor];
}

+ (instancetype)messageWithRemovedAnchor:(IBAARAnchor *)anchor
{
    return [[self alloc] initWithType:IBAServerMessageTypeAnchorRemoved payload:anchor];
}

@end
