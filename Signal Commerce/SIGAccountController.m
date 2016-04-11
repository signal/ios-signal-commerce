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
#import "AppDelegate.h"
#import "SIGUserService.h"

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
    [[self appDelegate].userService logout];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)loadProfileData:(id)sender {
    [[SignalInc sharedInstance].defaultTracker publish:@"load:profile", nil];
}

- (IBAction)clearProfileData:(id)sender {
    [[SignalInc sharedInstance].profileStore clear];
}

- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

@end
