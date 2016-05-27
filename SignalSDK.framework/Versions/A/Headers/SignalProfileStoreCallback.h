//
//  SignalProfileStoreCallback.h
//  signal-ios-sdk
//
//  Created by Andrew on 4/12/16.
//  Copyright © 2016 Signal, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SignalProfile;
/*! Protocol that can be used to receive events when the SignalProfileStore is updated.  To use this callback, create an instance it and register it with the profile store.  For example,
    id<SignalProfileStoreCallback> yourInstance = ...;
    [[SignalInc sharedInstance].profileStore registerCallback: yourInstance];
 */
@protocol SignalProfileStoreCallback <NSObject>

/*! Invoked by the framework when new profile data is received.
 @param data the profile data received
 */
-(void)onUpdate:(SignalProfile * _Nonnull)data;

@end
