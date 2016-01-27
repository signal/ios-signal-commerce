// Copyright (c) 2015 Signal, Inc. All rights reserved.
// Signal SDK 2.0.3

#import <Foundation/Foundation.h>
#import "SignalTracker.h"
#import "SignalConfig.h"
#import "SignalProcessingDelegate.h"
#import "SignalServerDirectRequest.h"
#import "SignalServerDirectResponse.h"

typedef void (^config_block_t)(SignalConfig *);


/*!
 Signal iOS top-level class. Provides facilities to create trackers.
 */
@interface SignalInc : NSObject

/*!
 For convenience, this class exposes a default tracker instance.

 This is initialized to `nil` and will be set to the first tracker that is
 instantiated in trackerWithSiteId:. It may be overridden as desired.
 */
@property(nonatomic, strong) id<SignalTracker> defaultTracker;

/*!
 The Signal configuration settings.
 */
@property(nonatomic, strong, readonly) SignalConfig *signalConfig;

/*!
 @name Creating a Signal Manager
 */

/*! Get the shared instance of the Signal for iOS class. */
+ (instancetype)sharedInstance;

/*! Provides custom initialization for the shared instance.  If it is called more than once, the parameters are ignored and the shared instance will be returned.
 @param signalConfig a signal configuration
 */
+ (instancetype)initInstance:(id<SignalProcessingDelegate>) delegate config:(config_block_t)configBlock;

/*! Return the SDK version */
+ (NSString *)sdkVersion;

/*!
 @name Creating a Tracker
 */

/*!
 Create a BTTracker implementation with the specified site ID.

 @param siteId A unique seven character alphanumeric identifier for a site.
 Must not be `nil` or empty.

 @return A BTTracker associated with the specified site ID. The tracker
 can be used to send data to third parties via Signal.

 If an error occurs or the site ID is not valid, this method will return `nil`.
 */
- (id<SignalTracker>)trackerWithSiteId:(NSString *)siteId;

@end
