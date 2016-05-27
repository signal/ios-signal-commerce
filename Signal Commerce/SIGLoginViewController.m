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
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation SIGLoginViewController

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    [_userText becomeFirstResponder];
    [[SignalInc sharedInstance].defaultTracker publish:SIG_TRACK_VIEW withDictionary:@{SIG_VIEW_NAME: @"LoginView"}];
}

- (IBAction)cancel:(id)sender {
    [[SignalInc sharedInstance].defaultTracker publish:SIG_TRACK_EVENT
                                        withDictionary:@{SIG_CATEGORY: SIG_CLICK,
                                                         SIG_ACTION: @"cancel_login"}];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (IBAction)login:(id)sender {
    [[self appDelegate].userService login:[_userText text] password: @""];
    [[SignalInc sharedInstance].defaultTracker publish:SIG_TRACK_EVENT
                                        withDictionary:@{SIG_CATEGORY: SIG_USER,
                                                         SIG_ACTION: SIG_LOGIN}];
    [self dismissViewControllerAnimated:YES completion:^{
        [_parent.navigationController pushViewController:_handoff animated:NO];
    }];
}

- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

@end
