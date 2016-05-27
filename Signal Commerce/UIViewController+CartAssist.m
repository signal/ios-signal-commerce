//
//  UIViewController+CartAssist.m
//  Signal Commerce
//
//  Created by Andrew on 2/9/16.
//  Copyright © 2016 Signal. All rights reserved.
//

#import "UIViewController+CartAssist.h"
#import "AppDelegate.h"
#import "SIGCart.h"
#import "SIGCartController.h"
#import "BBBadgeBarButtonItem.h"
#import "SIGTracking.h"
#import <SignalSDK/SignalInc.h>

@implementation UIViewController (CartAssist)

-(UIBarButtonItem *)setupCart {
    UIButton *cartView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [cartView addTarget:self action:@selector(loadCart) forControlEvents:UIControlEventTouchUpInside];
    [cartView setImage: [[UIImage imageNamed: @"952-shopping-cart-toolbar"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [cartView setUserInteractionEnabled:YES];

    BBBadgeBarButtonItem *cartButton = [[BBBadgeBarButtonItem alloc] initWithCustomUIButton:cartView];
    cartButton.badgeValue = [self cartAmount];
    cartButton.badgeMinSize = 2;
    cartButton.badgePadding = 3;
    cartButton.shouldHideBadgeAtZero = YES;
    return cartButton;
}

-(void)refreshCart:(UIBarButtonItem *)item {
    ((BBBadgeBarButtonItem *)item).badgeValue = [self cartAmount];
}

-(NSString *)cartAmount {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return [NSString stringWithFormat:@"%lu", (unsigned long)appDelegate.cart.itemCount];
}

-(void)loadCart {
    SIGCartController* cartController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"SIGCartController"];

    [self.navigationController pushViewController:cartController animated:YES];
    [[SignalInc sharedInstance].defaultTracker publish:SIG_TRACK_EVENT
                                        withDictionary:@{SIG_CATEGORY: SIG_CLICK,
                                                         SIG_ACTION: @"checkout"}];

}

@end
