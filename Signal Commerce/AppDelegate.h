//
//  AppDelegate.h
//  Signal Commerce
//
//  Created by Andrew on 1/11/16.
//  Copyright © 2016 Signal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SIGShoppingService.h"

@class SIGImageCache;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) id<SIGShoppingService> shoppingService;
@property (strong, nonatomic) SIGImageCache *imageCache;

@end

