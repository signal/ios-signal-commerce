//
//  SIGUserService.m
//  Signal Commerce
//
//  Created by Andrew on 4/6/16.
//  Copyright © 2016 Signal. All rights reserved.
//

#import <SignalSDK/SignalInc.h>
#import <SignalSDK/SignalHashes.h>
#import "SIGUserService.h"
#import "SIGPreferences.h"


@implementation SIGUserService

-(BOOL)login:(NSString * _Nonnull)user password:(NSString * _Nonnull)password {
    [SIGPreferences setLoggedInUser: user];
    [[SignalInc sharedInstance].signalConfig addCustomFields:@{@"uid-hashed-email-sha256" : [SignalHashes sha256:user] }];
    return YES;
}

-(BOOL)isLoggedIn {
    return [SIGPreferences loggedInUser] ? YES : NO;
}

-(BOOL)logout {
    [[SignalInc sharedInstance].signalConfig removeCustomField:@"uid-hashed-email-sha256"];
    [SIGPreferences setLoggedInUser:nil];
    return YES;
}

-(BOOL)preferred {
    id<SignalProfileStore> store = [SignalInc sharedInstance].profileStore;
    return [@"true" isEqualToString: [store dataFromKey: @"Preferred"]];
}

-(NSString * _Nullable)loggedInAs {
    return [SIGPreferences loggedInUser];
}

@end
