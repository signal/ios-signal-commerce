//
//  SIGLoginViewController.m
//  Signal Commerce
//
//  Created by Andrew on 1/26/16.
//  Copyright © 2016 Signal. All rights reserved.
//

#import "SIGLoginViewController.h"
#import "MMDrawerController.h"
#import "SIGPreferences.h"
#import <SignalSDK/SignalInc.h>
#import "AppDelegate.h"
#import "SIGUserService.h"
#import "SIGTracking.h"

@interface SIGLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userText;
@property (weak, nonatomic) IBOutlet UITextField *pwdText;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation SIGLoginViewController

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    [_userText becomeFirstResponder];
    [SIGTracking trackView:@"LoginView"];
}

- (IBAction)cancel:(id)sender {
    [SIGTracking trackEvent:SIG_CLICK action:@"cancel_login"];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (IBAction)login:(id)sender {
    NSString *password = [_pwdText text];
    [[self appDelegate].userService login:[_userText text] password: password];
    [SIGTracking trackEvent:SIG_USER action:SIG_LOGIN];
    [[[SignalInc sharedInstance] defaultTracker] publish: @"action:login", @"extra", password, nil];

    [self dismissViewControllerAnimated:YES completion:^{
        [_parent.navigationController pushViewController:_handoff animated:NO];
    }];
}

- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

@end
