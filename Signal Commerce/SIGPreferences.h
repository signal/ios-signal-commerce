//
//  SIGPreferences.h
//  Signal Commerce
//
//  Created by Andrew on 1/22/16.
//  Copyright © 2016 Signal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SIGPreferences : NSObject

+(void)savePrefs;

+(void)loadPrefs;

+(void)setMagentoServer:(NSString *)magentoServer;

+(NSString *)magentoServer;

+(void)setLoggedInUser:(NSString *)loggedInUser;

+(NSString *)loggedInUser;

@end
