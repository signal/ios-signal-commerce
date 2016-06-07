//
//  SIGPreferences.m
//  Signal Commerce
//
//  Created by Andrew on 1/22/16.
//  Copyright © 2016 Signal. All rights reserved.
//

#import "SIGPreferences.h"
#import <SignalSDK/SignalInc.h>

static NSString * const kBatteryPercentage = @"SignalBatteryPercentage";
static NSString * const kDispatchInterval = @"SignalDispatchInterval";
static NSString * const kMessageRetryCount = @"SignalMessageRetryCount";
static NSString * const kMessageExpiration = @"SignalMessageExpiration";
static NSString * const kMaxQueuedMessages = @"SignalMaxQueuedMessages";
static NSString * const kDebug = @"SignalDebug";
static NSString * const kDatastoreDebug = @"SignalDatastoreDebug";
static NSString * const kEndpoint = @"SignalEndpoint";
static NSString * const kDefaultSiteId = @"SignalDefaultSiteId";
static NSString * const kSocketReadTimeout = @"SignalSocketReadTimeout";
static NSString * const kNetworkOnWifiOnly = @"SignalnetworkOnWifiOnly";
static NSString * const kMagentoServer = @"SignalMagentoServer";
static NSString * const kLoggedInUser = @"SignalLoggedInUser";
static NSString * const kStandardFields = @"SignalStandardFields";
static NSString * const kBackgroundDrainEnabled = @"SignalBackgroundDrainEnabled";
static NSString * const kInitialized = @"SignalInitialized";

@implementation SIGPreferences

+(void)savePrefs {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    SignalConfig *config = [[SignalInc sharedInstance] signalConfig];
    [userDefaults setFloat: config.batteryPercentage forKey:kBatteryPercentage];
    [userDefaults setDouble: config.dispatchInterval forKey:kDispatchInterval];
    [userDefaults setDouble: config.messageExpiration forKey:kMessageExpiration];
    [userDefaults setDouble: config.messageRetryCount forKey:kMessageRetryCount];
    [userDefaults setDouble: config.maxQueuedMessages forKey:kMaxQueuedMessages];
    [userDefaults setObject: config.endpoint forKey: kEndpoint];
    [userDefaults setObject: config.defaultSiteId forKey: kDefaultSiteId];
    [userDefaults setObject: config.standardFields forKey: kStandardFields];
    [userDefaults setBool: config.networkOnWifiOnly forKey: kNetworkOnWifiOnly ];
    [userDefaults setBool: config.debug forKey: kDebug ];
    [userDefaults setBool: config.datastoreDebug forKey: kDatastoreDebug];

    [userDefaults setBool:YES forKey:kInitialized];
    [userDefaults synchronize];
}

+(void)loadPrefs {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![userDefaults boolForKey:kInitialized]) {
        return;
    }
    SignalConfig *config = [[SignalInc sharedInstance] signalConfig];
    config.batteryPercentage = [userDefaults floatForKey:kBatteryPercentage];
    config.dispatchInterval = [userDefaults doubleForKey:kDispatchInterval];
    config.maxQueuedMessages = [userDefaults doubleForKey:kMaxQueuedMessages];
    config.messageRetryCount = [userDefaults doubleForKey:kMessageRetryCount];
    config.messageExpiration = [userDefaults doubleForKey:kMessageExpiration];
    config.endpoint = [userDefaults stringForKey: kEndpoint];
    config.defaultSiteId = [userDefaults stringForKey:kDefaultSiteId];
    config.networkOnWifiOnly = [userDefaults boolForKey: kNetworkOnWifiOnly];
    config.debug = [userDefaults boolForKey: kDebug];
    config.datastoreDebug = [userDefaults boolForKey: kDatastoreDebug];
    
    NSArray *standardFields = [userDefaults arrayForKey: kStandardFields];
    if (standardFields != nil) {
        [config addArrayOfStandardFields: standardFields];
    }
}

+(void)setMagentoServer:(NSString *)magentoServer {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject: magentoServer forKey:kMagentoServer];
    [userDefaults synchronize];
}

+(void)setLoggedInUser:(NSString *)loggedInUser {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:loggedInUser forKey:kLoggedInUser];
    [userDefaults synchronize];
}

+(NSString *)loggedInUser {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults stringForKey: kLoggedInUser];
}


@end
