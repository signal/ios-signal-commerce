//  Copyright (c) 2015 Signal, Inc. All rights reserved.

#import <Foundation/Foundation.h>

/*!
 Signal tracking interface. Obtain instances of this interface from
 [Signal trackerWithSiteId:] to track events. The implementation of this
 interface is thread-safe, and no calls are expected to block or take a long
 time. All network and disk activity will take place in the background.
 */
@protocol SignalTracker<NSObject>

/*!
 @name Getting the Current State
 */

/*!
 The site identifier (seven character alphanumeric string) with which
 this tracker is associated.

 This property is read-only.
 */
@property(nonatomic, copy, readonly) NSString *siteId;

/*
 @name Debugging the SDK
 */

/*!
 @name Crash handling
 */

/*!
 Adds an optional crash handler, which will send a high-level description of the crash to
 Signal's server.
 */
- (void)addUncaughtExceptionHandler;

/*!
 @name Publishing Events
 */

/*!
 Publish an event.
 
 This method sends the event and associated data to Signal's Server-Direct API.
 For example:

     [tracker publish:@"event:click", @"key1", @"value1", @"key2", @"value2", nil];
 
 Note that due to the varargs parameter, this method cannot be used from Swift code.
 
 @param event The event name
 @param ... A null-terminated list of alternating keys and values. If any value is `nil`, an NSInvalidArgumentException is raised.
 */
- (void)publish:(NSString *)event, ... NS_REQUIRES_NIL_TERMINATION;

/*!
 Publish an event.
 
 This method is similar to publish:, differing only in the way key-value pairs are specified.
 For example:
 
     NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"value1", @"key1", @"value2", @"key2", nil];
     [tracker publish:@"event:click" withDictionary:data];
 
 This method should be used to publish events from Swift code.
 
 @param event The event name
 @param data The associated data elements
 */
- (void)publish:(NSString *)event withDictionary:(NSDictionary *)data;

@end
