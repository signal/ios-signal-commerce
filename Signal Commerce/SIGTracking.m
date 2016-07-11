//
//  SIGTracking.m
//  Signal Commerce
//
//  Created by John Sokel on 5/25/16.
//  Copyright © 2016 Signal. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Google/Analytics.h>

#import "SIGTracking.h"
#import "SIGPreferences.h"
#import <SignalSDK/SignalHashes.h>

// Main Types
NSString* SIG_TRACK_VIEW = @"trackView";
NSString* SIG_TRACK_EVENT = @"trackEvent";
NSString* SIG_CATEGORY = @"category";
NSString* SIG_ACTION = @"action";
NSString* SIG_LABEL = @"label";
NSString* SIG_VALUE = @"value";
NSString* SIG_VIEW_NAME = @"viewName";

// Categories
NSString* SIG_USER = @"user";
NSString* SIG_CLICK = @"click";
NSString* SIG_LOAD = @"load";
NSString* SIG_SHOP = @"shop";
NSString* SIG_PROFILE = @"profile";

// Click/Load types
NSString* SIG_CATEGORIES = @"categories";
NSString* SIG_PRODUCT = @"product";
NSString* SIG_PRODUCTS = @"products";
NSString* SIG_DETAILS = @"details";
NSString* SIG_IMAGES = @"images";
NSString* SIG_MENU = @"menu";
NSString* SIG_RESULTS = @"results";
NSString* SIG_LOGIN = @"login";

// Shop Types
NSString* SIG_CART_ADD = @"cartAdd";
NSString* SIG_CART_REMOVE = @"cartRemove";
NSString* SIG_PURCHASE = @"purchase";
NSString* SIG_FRAGMENT = @"fragment";
NSString* SIG_CHECKOUT_NEXT = @"checkout_next";
NSString* SIG_CHECKOUT_BACK = @"checkout_back";

BOOL ga_enabled = NO;

@implementation SIGTracking

+(void) initTrackers: (id<SignalProcessingDelegate>)delegate {

    // **********************
    // Signal SDK
    [SignalInc initInstance:delegate config:^(SignalConfig *config) {
        //config.endpoint = @"https://mobile-stage.signal.ninja";
        config.defaultSiteId = @"KzzOeke";
        config.messageRetryCount = 3;
        config.debug = YES;
        config.datastoreDebug = NO;
        config.dispatchInterval = 10;
        config.messageExpiration = 3600;
        config.maxQueuedMessages = 500;
        config.profileDataEnabled = YES;
        config.datastoreDebug = YES;
    }];

    [SIGPreferences loadPrefs];

    SignalConfig *config = [[SignalInc sharedInstance] signalConfig];
    [config addCustomFields: @{@"demo": @"true", @"sdkVersion": [SignalInc sdkVersion]}];
    if ([[config standardFields] count] == 0) {
        [config addStandardFields: ApplicationVersion, OsVersion, ScreenResolution, DeviceId, UserLanguage, Timezone, nil];
    }
    NSString *user = [SIGPreferences loggedInUser];
    if (user) {
        [[SignalInc sharedInstance].signalConfig addCustomField:[SignalHashes sha256:user] withKey:@"uid-hashed-email-sha256" ];
    }

    [[SignalInc sharedInstance] trackerWithSiteId: [SignalInc sharedInstance].signalConfig.defaultSiteId];

    if (!ga_enabled) {
        return;
    }

    // **********************
    // Google Analytics SDK
    // Configure tracker from GoogleService-Info.plist.
    NSError *configureError;
    [[GGLContext sharedInstance] configureWithError:&configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
    // Optional: configure GAI options.
    GAI *gai = [GAI sharedInstance];
    //gai.trackUncaughtExceptions = YES;  // report uncaught exceptions
    //gai.logger.logLevel = kGAILogLevelVerbose;  // remove before app release
}

+(void) trackEvent:(NSString *)category action:(NSString *)action {
    [SIGTracking trackEvent:category action:action label:nil value:nil extras:nil];
}

+(void) trackEvent:(NSString *)category action:(NSString *)action label:(NSString *)label value:(NSNumber *)value {
    [SIGTracking trackEvent:category action:action label:label value:value extras:nil];
}

+(void) trackEvent:(NSString *)category action:(NSString *)action label:(NSString *)label value:(NSNumber *)value extras:(NSDictionary *)extras {
    // Signal
    NSMutableDictionary *eventValues = [[NSMutableDictionary alloc] init];
    [eventValues setObject:category forKey:SIG_CATEGORY];
    [eventValues setObject:action forKey:SIG_ACTION];
    if (label != nil) {
        [eventValues setObject:label forKey:SIG_LABEL];
    }
    if (value != nil) {
        [eventValues setObject:[value stringValue] forKey:SIG_VALUE];
    }
    if (extras != nil) {
        [extras enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL* stop) {
            [eventValues setObject:value forKey:key];
        }];
    }

    [[[SignalInc sharedInstance] defaultTracker] publish:SIG_TRACK_EVENT withDictionary:eventValues];
    
    if (!ga_enabled) {
        return;
    }
    
    // GAI
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:category
                                                          action:action
                                                           label:label
                                                           value:value] build]];
}

+(void) trackView:(NSString *)viewName {
    // Signal
    [[SignalInc sharedInstance].defaultTracker publish:SIG_TRACK_VIEW withDictionary:@{SIG_VIEW_NAME: viewName}];

    if (!ga_enabled) {
        return;
    }

    //GAI
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:viewName];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}
@end