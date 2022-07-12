//
//  Copyright © 2018 Itty Bitty Apps Pty Ltd. All rights reserved.
//

#import <CCore/IBAServerMessage.h>
#import <CCore/IBAARAnchor.h>
#import <CCore/IBAARFrame.h>
#import <CCore/IBAARPlaneAnchor.h>
#import <CCore/IBAARPointCloud.h>
#import <CCore/NSCoder+IBACodingHelpers.h>

@implementation IBAServerMessage

static NSString * const kIBAServerMessageTypeKey = @"t";
static NSString * const kIBAServerMessagePayloadKey = @"p";

+ (BOOL)supportsSecureCoding
{
    return YES;
}

+ (NSSet<Class> *)payloadClassesForType:(IBAServerMessageType)type
{
    switch (type) {
        case IBAServerMessageTypeInvalid:
            return [NSSet setWithObject:[NSNull class]];
        case IBAServerMessageTypeFrame:
            return [NSSet setWithObject:[IBAARFrame class]];
        case IBAServerMessageTypePointCloud:
            return [NSSet setWithObject:[IBAARPointCloud class]];
        case IBAServerMessageTypeAnchorAdded:
            return [NSSet setWithArray:@[ [IBAARAnchor class], [IBAARPlaneAnchor class] ]];
        case IBAServerMessageTypeAnchorUpdated:
            return [self payloadClassesForType:IBAServerMessageTypeAnchorAdded];
        case IBAServerMessageTypeAnchorRemoved:
            return [self payloadClassesForType:IBAServerMessageTypeAnchorAdded];
    }
}

+ (BOOL)isValidPayload:(id<NSObject, NSSecureCoding>)payload forType:(IBAServerMessageType)type
{
    for (Class class in [self payloadClassesForType:type]) {
        if ([payload isKindOfClass:class]) {
            return YES;
        }
    }

    return NO;
}

- (instancetype)initWithType:(IBAServerMessageType)type payload:(id<NSObject, NSSecureCoding>)payload
{
    NSParameterAssert(payload != nil);
    NSParameterAssert([self.class isValidPayload:payload forType:type]);

    self = [super init];
    if (self) {
        _type = type;
        _payload = payload;
    }

    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    IBAServerMessageType type = [aDecoder decodeIntegerForKey:kIBAServerMessageTypeKey];
    NSSet<Class> *expectedClasses = [self.class payloadClassesForType:type];
    id<NSObject, NSSecureCoding> payload = [aDecoder decodeObjectOfClasses:expectedClasses forKey:kIBAServerMessagePayloadKey];
    if (payload == nil) {
        [aDecoder iba_failWithValueNotFoundError];
        return nil;
    }

    return [self initWithType:type payload:payload];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.type forKey:kIBAServerMessageTypeKey];
    [aCoder encodeObject:self.payload forKey:kIBAServerMessagePayloadKey];
}

@end
