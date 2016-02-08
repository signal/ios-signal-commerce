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
}

- (IBAction)loginPressed:(id)sender {
    NSString *loggedinUser = [SIGPreferences loggedInUser];

    // TODO: this is a crappy way to do this.
    if ([loggedinUser length] != 0) {
        [SIGPreferences setLoggedInUser:nil];
        [[SignalInc sharedInstance].signalConfig removeCustomField:@"uid-hashed-email-sha256"];

    } else {

    }
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
