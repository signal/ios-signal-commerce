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

@interface SIGLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userText;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation SIGLoginViewController

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    [_userText becomeFirstResponder];
    [[SignalInc sharedInstance].defaultTracker publish:@"view:LoginActivity" withDictionary:@{}];
}

- (IBAction)cancel:(id)sender {
    [[SignalInc sharedInstance].defaultTracker publish:@"click:cancel" withDictionary:@{}];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (IBAction)login:(id)sender {
    [[SignalInc sharedInstance].defaultTracker publish:@"click:login" withDictionary:@{}];
    [[self appDelegate].userService login:[_userText text] password: @""];
    [self dismissViewControllerAnimated:YES completion:^{
        [_parent.navigationController pushViewController:_handoff animated:NO];
    }];
}

- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

@end
