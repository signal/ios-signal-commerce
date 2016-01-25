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
static NSString * const kInitialized = @"SignalInitialized";
static NSString * const kMagentoServer = @"SignalMagentoServer";


@implementation SIGPreferences

+(void)save {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    SignalConfig *config = [[SignalInc sharedInstance] signalConfig];
    [userDefaults setFloat:config.batteryPercentage forKey:kBatteryPercentage];
    [userDefaults setDouble:config.dispatchInterval forKey:kDispatchInterval];
    [userDefaults setObject: config.endpoint forKey: kEndpoint];
    [userDefaults setObject: config.defaultSiteId forKey: kDefaultSiteId];
    [userDefaults setBool: config.debug forKey: kDebug ];
    [userDefaults setBool: config.datastoreDebug forKey: kDatastoreDebug];
    [userDefaults setBool:YES forKey:kInitialized];
    [userDefaults synchronize];
}

+(void)load {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![userDefaults boolForKey:kInitialized]) {
        return;
    }
    SignalConfig *config = [[SignalInc sharedInstance] signalConfig];
    config.batteryPercentage = [userDefaults boolForKey:kBatteryPercentage];
    config.defaultSiteId = [userDefaults stringForKey:kDefaultSiteId];
    config.endpoint = [userDefaults stringForKey: kEndpoint];
    config.debug = [userDefaults boolForKey: kDebug];
    config.datastoreDebug = [userDefaults boolForKey: kDatastoreDebug];
}

+(void)setMagentoServer:(NSString *)magentoServer {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject: magentoServer forKey:kMagentoServer];
    [userDefaults synchronize];
}

+(NSString *)magentoServer {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *url = [userDefaults stringForKey:kMagentoServer];
    if (url) {
        return url;
    }
    return @"https://commerce.signal.ninja/api/rest";
}

@end
