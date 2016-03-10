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
@property(nonatomic, copy, readonly, nonnull) NSString *siteId;

/*!
 The event name sent to Signal.
 
 This property is read-only.
 */
@property(nonatomic, copy, readonly, nonnull) NSString *event;

/*!
 The data associated with this event.
 
 This property is read-only.
 */
@property(nonatomic, copy, readonly, nonnull) NSDictionary *data;

/*! The time/date that the request was made */
@property (nonatomic, copy, readonly, nonnull) NSDate *dateRequested;

/*!
 If true, this request will be logged with `NSLog()`.
 */
@property(nonatomic, assign, readonly) BOOL debug;

/*! The signal config */
@property(nonatomic, readonly, nonnull) SignalConfig *signalConfig;

/*!
 The ID of this request in the database (-1 means that it has not been persisted)
 */
@property(nonatomic) long dbId;

/*!
 Number of attempts that have been made to send this request to the server.
 */
@property(nonatomic) int attempt;

/*!
 Compare the receiving request to another request.

 Two requests have equal contents if they have the same event and data.

 @param otherRequest A server-direct request

 @return `YES` if the contents of *otherRequest* are equal to the contents
 of the receiving request; otherwise `NO`.
 */
- (BOOL)isEqualToRequest:(id<SignalServerDirectRequest> _Nullable)otherRequest;

@end
