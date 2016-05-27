//
//  SIGSettingsController.m
//  Signal Commerce
//
//  Created by Andrew on 1/20/16.
//  Copyright © 2016 Signal. All rights reserved.
//
#import <SignalSDK/SignalInc.h>

#import "SIGSettingsController.h"
#import "SIGPreferences.h"
#import "SIGTracking.h"

@interface SIGSettingsController()

@property (weak, nonatomic) IBOutlet UITextField *siteCode;
@property (weak, nonatomic) IBOutlet UITextField *serverEndpoint;
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
@property (weak, nonatomic) IBOutlet UISwitch *applicationNameSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *networkOnWifiOnlySwitch;
@property (weak, nonatomic) IBOutlet UISwitch *screenResolutionSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *screenOrientationSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *userLanguageSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *timezoneSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *applicationVersionSwitch;
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
@property (weak, nonatomic) IBOutlet UITextField *magentoField;
@property (weak, nonatomic) IBOutlet UISwitch *profileDataEnabledField;

@end

@implementation SIGSettingsController

-(void)viewDidLoad {
    SignalConfig *config = [SignalInc sharedInstance].signalConfig;
    float batteryValue = config.batteryPercentage;
    [_batteryThreshold setValue: batteryValue];
    [self updateBatteryValue:batteryValue];

    [_dispatchIntervalSlider setValue: config.dispatchInterval];
    [self updateDispatchInterval:config.dispatchInterval];

    [_messageRetrySlider setValue: config.messageRetryCount];
    [self updateMessageRetryCount: config.messageRetryCount];

    [_messageExpirationSlider setValue: config.messageExpiration];
    [self updateMessageExpiration: config.messageExpiration];

    [_maxQueuedSlider setValue: config.maxQueuedMessages];
    [self updateMaxQueuedMessages: config.maxQueuedMessages];

    [_debugSwitch setOn: config.debug];
    [_databaseDebugSwitch setOn: config.datastoreDebug];
    [_networkOnWifiOnlySwitch setOn: config.networkOnWifiOnly];

    [_siteCode setText: config.defaultSiteId];
    [_serverEndpoint setText: config.endpoint];
    [_magentoField setText: [SIGPreferences magentoServer]];

    [_profileDataEnabledField setOn: config.profileDataEnabled];

    StandardField standardField;
    NSArray *fieldArr = config.standardFields;
    for (standardField=ApplicationName; standardField < DeviceIdType; standardField++) {
        UISwitch *uiSwitch = [self mappedControl: standardField];
        [uiSwitch setOn:[fieldArr containsObject:@(standardField)]];
    }
}

-(void)viewDidAppear:(BOOL)animated {
    [[SignalInc sharedInstance].defaultTracker publish:SIG_TRACK_VIEW withDictionary:@{SIG_VIEW_NAME: @"SettingsView"}];
}

-(void)viewDidDisappear:(BOOL)animated {
    [SIGPreferences save];
}


- (IBAction)debugChanged:(id)sender {
    [SignalInc sharedInstance].signalConfig.debug = [_debugSwitch isOn];
}

- (IBAction)dispatchIntervalChanged:(id)sender {
    float value = [_dispatchIntervalSlider value];
    [SignalInc sharedInstance].signalConfig.dispatchInterval = value;
    [self updateDispatchInterval: value];
}

- (IBAction)siteCodeChanged:(id)sender {
    [SignalInc sharedInstance].signalConfig.defaultSiteId = [_siteCode text];
}
- (IBAction)serverEndpointChanged:(id)sender {
    [SignalInc sharedInstance].signalConfig.endpoint = [_serverEndpoint text];
}

-(void)updateDispatchInterval:(float)value {
    [_dispatchIntervalValue setText: [NSString stringWithFormat:@"%1.0fs", value]];
}

- (IBAction)magentoFieldChanged:(id)sender {
    [SIGPreferences setMagentoServer: [_magentoField text]];
}

- (IBAction)databaseDebugChanged:(id)sender {
    [SignalInc sharedInstance].signalConfig.datastoreDebug = [_databaseDebugSwitch isOn];
}

- (IBAction)batteryValueChanged:(id)sender {
    float batteryValue = [_batteryThreshold value];
    [SignalInc sharedInstance].signalConfig.batteryPercentage = batteryValue;
    [self updateBatteryValue:batteryValue];
}

-(void)updateBatteryValue:(float)batteryValue {
    [_batteryThresholdValue setText: [NSString stringWithFormat:@"%d%%", (int)(batteryValue * 100)]];
}

- (IBAction)messageRetryChanged:(id)sender {
    float value = [_messageRetrySlider value];
    [SignalInc sharedInstance].signalConfig.messageRetryCount = value;
    [self updateMessageRetryCount: value];
}

-(void)updateMessageRetryCount:(float)value {
    [_messageRetryValue setText: [NSString stringWithFormat: @"%1.0f", value]];
}

- (IBAction)messageExpirationChanged:(id)sender {
    float value = [_messageExpirationSlider value];
    [SignalInc sharedInstance].signalConfig.messageExpiration = value;
    [self updateMessageExpiration: value];
}

-(void)updateMessageExpiration:(float)value {
    [_messageExpirationValue setText: [NSString stringWithFormat: @"%1.0fs", value]];
}
- (IBAction)maxQueuedChanged:(id)sender {
    float value = [_maxQueuedSlider value];
    [SignalInc sharedInstance].signalConfig.maxQueuedMessages = value;
    [self updateMaxQueuedMessages: value];
}

-(void)updateMaxQueuedMessages:(float)value {
    [_maxQueuedValue setText: [NSString stringWithFormat: @"%1.0f", value]];
}

- (IBAction)toggleAppName:(id)sender {
    [self toggleStandardField:ApplicationName on: [_applicationNameSwitch isOn]];
}
- (IBAction)toggleAppVersion:(id)sender {
    [self toggleStandardField:ApplicationVersion on: [_applicationVersionSwitch isOn]];
}

- (IBAction)toggleScreenResolution:(id)sender {
    [self toggleStandardField:ScreenResolution on: [_screenResolutionSwitch isOn]];
}

- (IBAction)toggleScreenOrientation:(id)sender {
    [self toggleStandardField:ScreenOrientation on: [_screenOrientationSwitch isOn]];
}

- (IBAction)toggleUserLanguage:(id)sender {
    [self toggleStandardField:UserLanguage on: [_userLanguageSwitch isOn]];
}

- (IBAction)toggleTimeZone:(id)sender {
    [self toggleStandardField:Timezone on: [_timezoneSwitch isOn]];
}

- (IBAction)toggleOsVersion:(id)sender {
    [self toggleStandardField:OsVersion on: [_osVersionSwitch isOn]];
}

- (IBAction)toggleCarrierSwitch:(id)sender {
    [self toggleStandardField:Carrier on: [_carrierSwitch isOn]];
}

- (IBAction)toggleODINSwitch:(id)sender {
    [self toggleStandardField:ODIN on: [_odinSwitch isOn]];
}

- (IBAction)toggleDeviceID:(id)sender {
    [self toggleStandardField:DeviceId on: [_odinSwitch isOn]];
}

- (IBAction)toggleActiveNetwork:(id)sender {
    [self toggleStandardField:ActiveNetwork on:[_activeNetwork isOn]];
}

- (IBAction)toggleDeviceIdType:(id)sender {
    [self toggleStandardField:DeviceIdType on:[_deviceIdTypeSwitch isOn]];
}

- (IBAction)toggleDeviceInfo:(id)sender {
    [self toggleStandardField:DeviceInfo on: [_deviceInfoSwitch isOn]];
}

- (IBAction)wifiOnlyChanged:(id)sender {
    [SignalInc sharedInstance].signalConfig.networkOnWifiOnly = [_networkOnWifiOnlySwitch isOn];
}

-(void)addStandardField:(StandardField)field {
    SignalConfig *config = [SignalInc sharedInstance].signalConfig;
    NSArray *fields = config.standardFields;
    if ([fields containsObject:@(field)]) {
        return;
    }
    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:fields];
    [arr addObject:@(field)];
    [config addArrayOfStandardFields:arr];
}

-(void)removeStandardField:(StandardField)field {
    SignalConfig *config = [SignalInc sharedInstance].signalConfig;
    NSArray *fields = config.standardFields;
    if (![fields containsObject:@(field)]) {
        return;
    }
    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:fields];
    [arr removeObject:@(field)];
    [config addArrayOfStandardFields:arr];
}

-(void)toggleStandardField:(StandardField)field on:(BOOL)on {
    if (on) {
        [self addStandardField:field];
    } else {
        [self removeStandardField:field];
    }
}

- (IBAction)toggleProfileDataEnabled:(id)sender {
    [SignalInc sharedInstance].signalConfig.profileDataEnabled = [self.profileDataEnabledField isOn];
}

-(UISwitch *)mappedControl:(StandardField)field {
    switch (field) {
        case ApplicationName:
            return _applicationNameSwitch;
        case ApplicationVersion:
            return _applicationVersionSwitch;
        case ScreenOrientation:
            return _screenOrientationSwitch;
        case UserLanguage:
            return _userLanguageSwitch;
        case ScreenResolution:
            return _screenResolutionSwitch;
        case Timezone:
            return _timezoneSwitch;
        case OsVersion:
            return _osVersionSwitch;
        case Carrier:
            return _carrierSwitch;
        case DeviceInfo:
            return _deviceInfoSwitch;
        case ODIN:
            return _odinSwitch;
        case DeviceIdType:
            return _deviceIdTypeSwitch;
        case DeviceId:
            return _deviceIdSwitch;
        case DeviceIdMD5:
            return _deviceIDMD5;
        case DeviceIdSHA1:
            return _deviceIDSHA1;
        case DeviceIdSHA256:
            return _deviceIDSHA256;
        default:
            return nil;
    }
}

- (IBAction)openSiteCode:(id)sender {
    NSString *stringURL = [@"http://commerce.signal.ninja/?siteid=" stringByAppendingString: [_siteCode text]];
    NSURL *url = [NSURL URLWithString:stringURL];
    [[UIApplication sharedApplication] openURL:url];
}

@end
