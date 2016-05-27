//
//  SIGBillingConfirmationController.m
//  Signal Commerce
//
//  Created by Andrew on 2/10/16.
//  Copyright © 2016 Signal. All rights reserved.
//

#import "SIGBillingController.h"
#import "SIGPurchaseCompleteController.h"
#import "AppDelegate.h"
#import "SIGCart.h"
#import "SIGMoney.h"
#import "SIGUserService.h"
#import "SIGTracking.h"
#import <SignalSDK/SignalInc.h>

@interface SIGBillingController()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *purchaseButton;
@property (weak, nonatomic) IBOutlet UILabel *subtotal;
@property (weak, nonatomic) IBOutlet UILabel *taxes;
@property (weak, nonatomic) IBOutlet UILabel *total;

@end

@implementation SIGBillingController

-(void)viewDidLoad {
    [_activityIndicator setHidden: YES];
    SIGCart *cart = [self appDelegate].cart;
    BOOL preferred = [[self appDelegate].userService preferred];
    [_subtotal setText: [[cart subtotal: preferred] description]];
    [_taxes setText: [[cart taxes: preferred] description]];
    [_total setText: [[cart total: preferred] description]];
}

-(void)viewDidAppear:(BOOL)animated {
    [[SignalInc sharedInstance].defaultTracker publish:SIG_TRACK_VIEW withDictionary:@{SIG_VIEW_NAME: @"BillingView"}];
}

- (IBAction)purchaseClick:(id)sender {
    [_purchaseButton setEnabled:NO];
    [_activityIndicator setHidden: NO];
    [_activityIndicator startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSThread sleepForTimeInterval:2];
        [self performSelectorOnMainThread:@selector(launchPurchaseComplete) withObject:nil waitUntilDone:NO];
    });
    
    SIGCart *cart = [self appDelegate].cart;
    [[[SignalInc sharedInstance] defaultTracker] publish: SIG_TRACK_EVENT
                                          withDictionary: @{SIG_CATEGORY: SIG_CLICK,
                                                            SIG_ACTION: SIG_PURCHASE,
                                                            SIG_LABEL: @"items",
                                                            SIG_VALUE: [NSString stringWithFormat:@"%d", [cart itemCount]]}];
}

-(void)launchPurchaseComplete {
    [_activityIndicator stopAnimating];
    [_activityIndicator setHidden: YES];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    SIGPurchaseCompleteController *controller = [storyboard instantiateViewControllerWithIdentifier: @"PurchaseComplete"];
    controller.handoff = self.navigationController;
    [self.navigationController presentViewController:controller animated:YES completion:^{
        [_purchaseButton setHidden: YES];
    }];
}

- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

@end
