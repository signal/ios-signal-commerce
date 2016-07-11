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
#import "UIViewController+CartAssist.h"
#import "SIGUserService.h"
#import "SIGTracking.h"

@interface SIGAccountController()

@property (weak, nonatomic) IBOutlet UILabel *loggedinAs;

@end

@implementation SIGAccountController

-(void)viewDidLoad {
    _loggedinAs.text = [@"You are logged in as " stringByAppendingString:[SIGPreferences loggedInUser ]];
    UIBarButtonItem *rightDrawerButton = [[UIBarButtonItem alloc] initWithTitle: @"Logout" style:UIBarButtonItemStylePlain target:self action: @selector(logout)];
    [self.navigationItem setRightBarButtonItem:rightDrawerButton animated:YES];
    [self setupToolbar];
}

-(void)viewDidAppear:(BOOL)animated {
    [self updateToolbar];
    [SIGTracking trackView:@"AccountView"];
}

-(void)logout {
    [SIGTracking trackEvent:SIG_CLICK action:SIG_MENU label:@"logout" value:nil];

    [[self appDelegate].userService logout];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)loadProfileData:(id)sender {
    // First event for analytics, second event to retrieve the profile data
    // Too tricky on the server side to configure both with single event
    [SIGTracking trackEvent:SIG_CLICK action:SIG_MENU label:@"profileLoad" value:nil];

    [[SignalInc sharedInstance].defaultTracker publish:@"profile:load", nil];
}

- (IBAction)clearProfileData:(id)sender {
    [SIGTracking trackEvent:SIG_CLICK action:SIG_MENU label:@"profileClear" value:nil];
    [[SignalInc sharedInstance].profileStore clear];
}

- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

@end
