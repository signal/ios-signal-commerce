//
//  SIGSettingsController.m
//  Signal Commerce
//
//  Created by Andrew on 1/20/16.
//  Copyright © 2016 Signal. All rights reserved.
//

#import "SIGSettingsController.h"

@interface SIGSettingsController()
@property (weak, nonatomic) IBOutlet UISlider *batteryThreshold;
@property (weak, nonatomic) IBOutlet UILabel *batteryThresholdValue;
@property (weak, nonatomic) IBOutlet UISlider *dispatchIntervalSlider;
@property (weak, nonatomic) IBOutlet UILabel *dispatchIntervalValue;
@property (weak, nonatomic) IBOutlet UISlider *messageRetrySlider;
@property (weak, nonatomic) IBOutlet UILabel *messageRetryValue;
@property (weak, nonatomic) IBOutlet UISlider *messageExpirationSlider;
@property (weak, nonatomic) IBOutlet UILabel *messageExpirationValue;
@property (weak, nonatomic) IBOutlet UISlider *maxQueuedSlider;
@property (weak, nonatomic) IBOutlet UILabel *maxQueuedValue;
@property (weak, nonatomic) IBOutlet UISwitch *databaseDebugSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *debugSwitch;
@property (weak, nonatomic) IBOutlet UIView *networkOnWifiOnlySwitch;
@property (weak, nonatomic) IBOutlet UISwitch *applicationNameSwitch;
@property (weak, nonatomic) IBOutlet UILabel *applicationVersionSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *screenResolutionSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *screenOrientationSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *userLanguageSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *timezoneSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *osVersionSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *carrierSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *odinSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *deviceIdSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *deviceIDMD5;
@property (weak, nonatomic) IBOutlet UISwitch *deviceIDSHA1;
@property (weak, nonatomic) IBOutlet UISwitch *deviceIDSHA256;
@property (weak, nonatomic) IBOutlet UISwitch *activeNetwork;
@property (weak, nonatomic) IBOutlet UISwitch *deviceInfoSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *deviceIdTypeSwitch;

@end

@implementation SIGSettingsController

- (IBAction)wifiOnlyChanged:(id)sender {
    
}

@end
