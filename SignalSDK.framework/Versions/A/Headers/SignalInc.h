// Copyright (c) 2015 Signal, Inc. All rights reserved.
// Signal SDK 2.1.0

#import <Foundation/Foundation.h>
#import "SignalTracker.h"
#import "SignalConfig.h"
#import "SignalProcessingDelegate.h"
#import "SignalServerDirectRequest.h"
#import "SignalServerDirectResponse.h"
#import "SignalProfileStore.h"
#import "SignalProfile.h"

typedef void (^config_block_t)(SignalConfig * _Nonnull);


/*!
 Signal iOS top-level class. Provides facilities to create trackers.
 */
@interface SignalInc : NSObject

/*!
 For convenience, this class exposes a default tracker instance.

 This is initialized to `nil` and will be set to the first tracker that is
 instantiated in trackerWithSiteId:. It may be overridden as desired.
 */
@property(nonatomic, strong, nullable) id<SignalTracker> defaultTracker;

/*!
 The Signal configuration settings.
 */
@property(nonatomic, strong, readonly, nonnull) SignalConfig *signalConfig;

/*!
 The profile store, that stores profile data for each site
 */
@property(nonatomic, strong, readonly, nonnull) id<SignalProfileStore> profileStore;

/*!
 @name Creating a Signal Manager
 */

/*! Get the shared instance of the Signal for iOS class. */
+ (instancetype _Nonnull)sharedInstance;

/*! Provides custom initialization for the shared instance.  If it is called more than once, the parameters are ignored and the shared instance will be returned.
 @param delegate if specified, the delegate will be called back for events that occur on each tracker
 @param configBlock an optional configuration block
 */
+ (instancetype _Nonnull)initInstance:(id<SignalProcessingDelegate> _Nullable) delegate config:(config_block_t _Nonnull)configBlock;

/*! Provides custom initialization.  Should be called before the sharedInstance method is invoked.
 @param configBlock a configuration block
 */
+ (instancetype _Nonnull)initInstanceWithConfig:(config_block_t _Nonnull)configBlock;

/*! Return the SDK version */
+ (NSString * _Nonnull)sdkVersion;

/*!
 @name Creating a Tracker
 */

/*!
 Create a BTTracker implementation with the specified site ID.

 @param siteId A unique seven character alphanumeric identifier for a site.
 Must not be `nil` or empty.

 @return A SignalTracker associated with the specified site ID. The tracker
 can be used to send data to third parties via Signal.

 If an error occurs or the site ID is not valid, this method will return `nil`.
 */
- (id<SignalTracker> _Nullable)trackerWithSiteId:(NSString * _Nonnull)siteId;

@end
