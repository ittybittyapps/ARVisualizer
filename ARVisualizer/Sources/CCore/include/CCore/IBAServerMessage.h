//
//  Copyright © 2018 Itty Bitty Apps Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Represents the type of encoded server message.
 */
typedef NS_CLOSED_ENUM(NSInteger, IBAServerMessageType) {
    /** Expected payload type is NSNull. */
    IBAServerMessageTypeInvalid = 0,
    /** Expected payload type is IBAARFrame. */
    IBAServerMessageTypeFrame,
    /** Expected payload type is IBAARPointCloud. */
    IBAServerMessageTypePointCloud,
    /** Expected payload type is IBAARAnchor or its subclasses. */
    IBAServerMessageTypeAnchorAdded,
    /** Expected payload type is IBAARAnchor or its subclasses. */
    IBAServerMessageTypeAnchorUpdated,
    /** Expected payload type is IBAARAnchor or its subclasses. */
    IBAServerMessageTypeAnchorRemoved
} NS_SWIFT_NAME(ServerMessage.Type);

/**
 Represents an encoded stream message from the server.
 */
NS_SWIFT_NAME(ServerMessage)
@interface IBAServerMessage : NSObject <NSSecureCoding>

@property (nonatomic, readonly) IBAServerMessageType type;
@property (nonatomic, strong) id<NSObject, NSSecureCoding> payload;

- (instancetype)initWithType:(IBAServerMessageType)type payload:(id<NSObject, NSSecureCoding>)payload NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
