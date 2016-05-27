//
//  SignalProfile.h
//  signal-ios-sdk
//
//  Created by Andrew on 2/24/16.
//  Copyright © 2016 Signal, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SignalProfileStoreCallback.h"

@class SignalProfile;

/*!
 Stores the active profile and maintains its persistence across app sessions.
 */
@protocol SignalProfileStore <NSObject>

/*! Returns the current profile or nil if not found.
 */
-(SignalProfile * _Nullable)profileData;

/*! Returns the UID with the specified key (or nil if it's not found)
 @param key the uid name
 */
-(NSString * _Nullable)uidFromKey:(NSString * _Nonnull)key;

/*! Returns the data with the specified key (or nil if it's not found)
 @param key the field name
 */
-(NSString * _Nullable)dataFromKey:(NSString * _Nonnull)key;

/*! Returns the UID or data with the specified key (or nil if it's not found). UID is searched first, then data.
 @param key the name
 */
-(NSString * _Nullable)valueFromKey:(NSString * _Nonnull)key;

/*! Clears out the profile store
 */
-(void)clear;

/*! Registers a callback that gets notified when the store has been updated.  Calling this method overrides any previous callbacks.
 @param callback the callback
 */
-(void)registerCallback:(id<SignalProfileStoreCallback> _Nonnull) callback;

/*! Removes any callback that has been registered
 */
-(void)deregisterCallback;


@end
