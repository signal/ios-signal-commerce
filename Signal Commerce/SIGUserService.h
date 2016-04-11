//
//  SIGUserService.h
//  Signal Commerce
//
//  Created by Andrew on 4/6/16.
//  Copyright © 2016 Signal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SIGUserService : NSObject

-(BOOL)login:(NSString * _Nonnull)user password:(NSString * _Nonnull)password;

-(BOOL)isLoggedIn;

-(BOOL)logout;

-(BOOL)preferred;

-(NSString * _Nullable)loggedInAs;

@end
