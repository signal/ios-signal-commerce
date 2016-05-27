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
#import "SIGTracking.h"

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
    [[SignalInc sharedInstance].defaultTracker publish:SIG_TRACK_EVENT
                                        withDictionary:@{SIG_CATEGORY: SIG_CLICK,
                                                         SIG_ACTION: SIG_MENU,
                                                         SIG_LABEL: @"logout"}];

    [[self appDelegate].userService logout];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)loadProfileData:(id)sender {
    // First event to retrieve the profile data, second event for analytics
    // Too tricky on the server side to configure both with single event
    [[SignalInc sharedInstance].defaultTracker publish:@"profile:load", nil];
    [[SignalInc sharedInstance].defaultTracker publish:SIG_TRACK_EVENT
                                        withDictionary:@{SIG_CATEGORY: SIG_CLICK,
                                                         SIG_ACTION: SIG_MENU,
                                                         SIG_LABEL: @"profileLoad"}];
}

- (IBAction)clearProfileData:(id)sender {
    [[SignalInc sharedInstance].defaultTracker publish:SIG_TRACK_EVENT
                                        withDictionary:@{SIG_CATEGORY: SIG_CLICK,
                                                         SIG_ACTION: SIG_MENU,
                                                         SIG_LABEL: @"profileClear"}];
    [[SignalInc sharedInstance].profileStore clear];
}

- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

@end
