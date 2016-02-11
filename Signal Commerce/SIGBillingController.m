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

@implementation SIGBillingController

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SIGPurchaseCompleteController *controller = segue.destinationViewController;
    controller.handoff = self.navigationController;
}

@end
