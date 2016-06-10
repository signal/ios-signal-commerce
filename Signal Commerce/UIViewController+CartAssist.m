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
    [SIGTracking trackEvent:SIG_CLICK action:@"checkout"];
}

/*!
 * Setup the toolbar onload, and create the bar buttons
 */
-(void)setupToolbar {
    UIBarButtonItem *queue = [[UIBarButtonItem alloc] init];
    UIBarButtonItem *event = [[UIBarButtonItem alloc] init];
    [self setToolbarItems:[NSArray arrayWithObjects:queue, event, nil]];
}

/*!
 * Update the toolbar once the view is showm, or re-shown, with the current values
 */
-(void)updateToolbar {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.activeController = self;
    SIGEventStack *eventStack = appDelegate.eventStack;
    UIBarButtonItem *queue = self.navigationController.toolbar.items[0];
    queue.title = [NSString stringWithFormat:@"Queue:%d", eventStack.queueSize];
    UIBarButtonItem *event = self.navigationController.toolbar.items[1];
    event.title = [eventStack lastEventInfo];
}

/*!
 * Update the queue size as it changes
 */
-(void)updateQueueSize:(NSNumber *)queueSize {
    NSString *value = [NSString stringWithFormat:@"Queue:%d", [queueSize intValue]];
    UIBarButtonItem *barBtnQueue = self.navigationController.toolbar.items[0];
    [barBtnQueue setTitle:value];
    if (queueSize.intValue == 0) {
        UIBarButtonItem *barBtnEvent = self.navigationController.toolbar.items[1];
        [barBtnEvent setTitle:@""];
    }
}

-(void)updateEvent:(NSString *)eventInfo {
    UIBarButtonItem *barBtnEvent = self.navigationController.toolbar.items[1];
    [barBtnEvent setTitle:eventInfo];
}

@end
