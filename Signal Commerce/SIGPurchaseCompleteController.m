//
//  SIGConfirmationPageController.m
//  Signal Commerce
//
//  Created by Andrew on 2/10/16.
//  Copyright © 2016 Signal. All rights reserved.
//

#import "SIGPurchaseCompleteController.h"
#import "AppDelegate.h"
#import "SIGCart.h"

@implementation SIGPurchaseCompleteController

-(void)viewDidAppear:(BOOL)animated {
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
