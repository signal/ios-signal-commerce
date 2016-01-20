//  Copyright (c) 2015 Signal, Inc. All rights reserved.

#import <Foundation/Foundation.h>
#import "SignalConfig.h"


// TODO: make this a const
#define NO_ID -1

/*!
 Immutable Signal server-direct request value object.
 */
@protocol SignalServerDirectRequest <NSObject>

/*!
 The site identifier (seven character alphanumeric string) with which
 this request is associated.

 This property is read-only.
 */
@property(nonatomic, copy, readonly) NSString *siteId;

/*!
 The event name sent to Signal.
 
 This property is read-only.
 */
@property(nonatomic, copy, readonly) NSString *event;

/*!
 The data associated with this event.
 
 This property is read-only.
 */
@property(nonatomic, copy, readonly) NSDictionary *data;

@property (nonatomic, copy, readonly) NSDate *dateRequested;

/*!
 If true, this request will be logged with `NSLog()`.
 */
@property(nonatomic, assign, readonly) BOOL debug;

@property(nonatomic, readonly) SignalConfig *signalConfig;

@property(nonatomic) long dbId;

@property(nonatomic) int attempt;

/*!
 Compare the receiving request to another request.

 Two requests have equal contents if they have the same event and data.

 @param otherRequest A server-direct request

 @return `YES` if the contents of *otherRequest* are equal to the contents
 of the receiving request; otherwise `NO`.
 */
- (BOOL)isEqualToRequest:(id<SignalServerDirectRequest>)otherRequest;

@end
