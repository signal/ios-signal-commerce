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

@interface SIGPurchaseCompleteController()
@property (weak, nonatomic) IBOutlet UILabel *purchaseComplete;

@end

@implementation SIGPurchaseCompleteController



-(void)viewDidAppear:(BOOL)animated {
    SIGCart *cart = [self appDelegate].cart;
    NSString *orderNumber = [[NSString stringWithFormat:@"%lu", (unsigned long)[[NSDate date] timeIntervalSince1970]] substringFromIndex:5];
    [_purchaseComplete setText: [NSString stringWithFormat:@"Purchase is complete. Your order number is %@", orderNumber]];
    NSDictionary *args = @{@"total" : [[cart total] description],
                           @"tax" : [[cart taxes] description],
                           @"shipping": @"0.00",
                           @"numItems": [NSString stringWithFormat:@"%d", [cart itemCount]],
                           @"orderNum" : orderNumber
                           };
    [[[SignalInc sharedInstance] defaultTracker] publish: @"click:purchase" withDictionary: args];
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
