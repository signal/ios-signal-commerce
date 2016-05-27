//
//  SIGConfirmationPageController.m
//  Signal Commerce
//
//  Created by Andrew on 2/10/16.
//  Copyright © 2016 Signal. All rights reserved.
//

#import <SignalSDK/SignalInc.h>

#import "SIGPurchaseCompleteController.h"
#import "AppDelegate.h"
#import "SIGCart.h"
#import "SIGMoney.h"
#import "SIGUserService.h"
#import "SIGTracking.h"

@interface SIGPurchaseCompleteController()
@property (weak, nonatomic) IBOutlet UILabel *purchaseComplete;

@end

@implementation SIGPurchaseCompleteController



-(void)viewDidAppear:(BOOL)animated {
    SIGCart *cart = [self appDelegate].cart;
    NSString *orderNumber = [[NSString stringWithFormat:@"%lu", (unsigned long)[[NSDate date] timeIntervalSince1970]] substringFromIndex:5];
    [_purchaseComplete setText: [NSString stringWithFormat:@"Purchase is complete. Your order number is %@", orderNumber]];
    BOOL preferred = [[self appDelegate].userService preferred];

    // Event for analytics
    [[SignalInc sharedInstance].defaultTracker publish:SIG_TRACK_VIEW withDictionary:@{SIG_VIEW_NAME: @"PurchaseCompleteView"}];

    // Event for data feed
    [[[SignalInc sharedInstance] defaultTracker] publish: @"action:purchase"
                                          withDictionary: @{@"total": [[cart total: preferred] description],
                                                              @"tax": [[cart taxes: preferred] description],
                                                         @"shipping": @"0.00",
                                                         @"numItems": [NSString stringWithFormat:@"%d", [cart itemCount]],
                                                         @"orderNum": orderNumber}];
    [[self appDelegate].cart empty];
}

- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (IBAction)ContinueShopping:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [_handoff popToRootViewControllerAnimated:NO];
    }];
}

@end
