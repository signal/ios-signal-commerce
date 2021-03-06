//
//  SIGTracking.h
//  Signal Commerce
//
//  Created by John Sokel on 5/25/16.
//  Copyright © 2016 Signal. All rights reserved.
//
#import <SignalSDK/SignalInc.h>

// Main Types
OBJC_EXPORT NSString* SIG_TRACK_VIEW;
OBJC_EXPORT NSString* SIG_TRACK_EVENT;
OBJC_EXPORT NSString* SIG_CATEGORY;
OBJC_EXPORT NSString* SIG_ACTION;
OBJC_EXPORT NSString* SIG_LABEL;
OBJC_EXPORT NSString* SIG_VALUE;
OBJC_EXPORT NSString* SIG_VIEW_NAME;

// Categories
OBJC_EXPORT NSString* SIG_USER;
OBJC_EXPORT NSString* SIG_CLICK;
OBJC_EXPORT NSString* SIG_LOAD;
OBJC_EXPORT NSString* SIG_SHOP;
OBJC_EXPORT NSString* SIG_PROFILE;

// Click/Load types
OBJC_EXPORT NSString* SIG_CATEGORIES;
OBJC_EXPORT NSString* SIG_PRODUCT;
OBJC_EXPORT NSString* SIG_PRODUCTS;
OBJC_EXPORT NSString* SIG_DETAILS;
OBJC_EXPORT NSString* SIG_IMAGES;
OBJC_EXPORT NSString* SIG_MENU;
OBJC_EXPORT NSString* SIG_RESULTS;
OBJC_EXPORT NSString* SIG_LOGIN;

// Shop Types
OBJC_EXPORT NSString* SIG_CART_ADD;
OBJC_EXPORT NSString* SIG_CART_REMOVE;
OBJC_EXPORT NSString* SIG_PURCHASE;
OBJC_EXPORT NSString* SIG_FRAGMENT;
OBJC_EXPORT NSString* SIG_CHECKOUT_NEXT;
OBJC_EXPORT NSString* SIG_CHECKOUT_BACK;

@interface SIGTracking : NSObject

+(void) initTrackers: (id<SignalProcessingDelegate>)delegate ;
+(void) trackEvent:(NSString *)category action:(NSString *)action;
+(void) trackEvent:(NSString *)category action:(NSString *)action label:(NSString *)label value:(NSNumber *)value;
+(void) trackEvent:(NSString *)category action:(NSString *)action label:(NSString *)label value:(NSNumber *)value extras:(NSDictionary *)extras;
+(void) trackView:(NSString *)viewName;

@end
