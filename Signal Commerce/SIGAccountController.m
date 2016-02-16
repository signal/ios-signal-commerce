//
//  SIGAccountController.m
//  Signal Commerce
//
//  Created by Andrew on 2/8/16.
//  Copyright © 2016 Signal. All rights reserved.
//

#import "SIGAccountController.h"
#import "SIGPreferences.h"
#import <SignalSDK/SignalInc.h>

@interface SIGAccountController()

@property (weak, nonatomic) IBOutlet UILabel *loggedinAs;

@end

@implementation SIGAccountController

-(void)viewDidLoad {
    _loggedinAs.text = [@"You are logged in as " stringByAppendingString:[SIGPreferences loggedInUser ]];
    UIBarButtonItem *rightDrawerButton = [[UIBarButtonItem alloc] initWithTitle: @"Logout" style:UIBarButtonItemStylePlain target:self action: @selector(logout)];
    [self.navigationItem setRightBarButtonItem:rightDrawerButton animated:YES];

}

-(void)logout {
    [[SignalInc sharedInstance].signalConfig removeCustomField:@"uid-hashed-email-sha256"];
    [SIGPreferences setLoggedInUser:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
