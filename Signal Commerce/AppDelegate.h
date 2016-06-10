//
//  AppDelegate.h
//  Signal Commerce
//
//  Created by Andrew on 1/11/16.
//  Copyright © 2016 Signal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SIGShoppingService.h"
#import "SIGEventStack.h"

@class SIGImageCache;
@class SIGCart;
@class SIGUserService;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) id<SIGShoppingService> shoppingService;
@property (strong, nonatomic) SIGImageCache *imageCache;
@property (strong, nonatomic) SIGCart *cart;
@property (strong, nonatomic) SIGEventStack *eventStack;
@property (strong, nonatomic) UIViewController *activeController;
@property (strong, nonatomic, readonly) SIGUserService *userService;

-(BOOL)usingSplitView;

@end

