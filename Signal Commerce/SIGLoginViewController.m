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
#import <SignalSDK/SignalHashes.h>

@interface SIGLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userText;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation SIGLoginViewController

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    [_userText becomeFirstResponder];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (IBAction)login:(id)sender {
    [SIGPreferences setLoggedInUser: [_userText text]];
    [[SignalInc sharedInstance].signalConfig addCustomFields:@{@"uid-hashed-email-sha256" : [SignalHashes sha256:[_userText text]] }];
    [self dismissViewControllerAnimated:YES completion:^{
        [_parent.navigationController pushViewController:_handoff animated:NO];
    }];
}


@end
