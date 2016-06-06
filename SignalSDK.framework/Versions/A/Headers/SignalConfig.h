//  Copyright (c) 2015 Signal, Inc. All rights reserved.

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, StandardField) {
    ApplicationName,
    ApplicationVersion,
    ScreenResolution,
    UserLanguage,
    ScreenOrientation,
    Timezone,
    OsVersion,
    Carrier,
    DeviceInfo,
    ODIN,
    DeviceId,
    DeviceIdMD5,
    DeviceIdSHA256,
    DeviceIdSHA1,
    ActiveNetwork,
    DeviceIdType
};

/*!
 Configuration object for the Signal run-time.  Values in this object will, for the most part, take effect immediately after being changed.
 
 This is a singleton class that should be obtained by calling
    
    [SignalInc sharedInstance].signalConfig

 */
@interface SignalConfig : NSObject

/*! 
 A number in [0.0,1.0] representing the battery percentage which the app should stop monitoring
 */
@property (atomic) float batteryPercentage;
/*! The number in seconds with which the dispatcher should wait */
@property (nonatomic) NSTimeInterval dispatchInterval;
/*! The maximum number of retries of a message after receiving an error code from the server. */
@property (nonatomic) long messageRetryCount;
/*! The length of time in seconds from when a message is crafted and when it becomes stale */
@property (nonatomic) double messageExpiration;
/*! The maximum number of messages that can be in the queue before new ones are dropped */
@property (nonatomic) long maxQueuedMessages;
/*! The SDK version number */
@property (nonatomic, nonnull) NSString *version;
/*! YES to enable NSLog'ing for the SignalSDK */
@property (nonatomic) BOOL debug;
/*! YES to enable extra NSLog'ing for the datastore queries */
@property (nonatomic) BOOL datastoreDebug;
/*! The user agent string that will be sent when URL requests are made */
@property (nonatomic, readonly, nonnull) NSString *userAgent;
/*! The endpoint to invoke - by default this is the production Signal endpoint */
@property (nonatomic, nonnull)  NSString *endpoint;
/*! The site id that is sent if the default tracker is invoked without first using a site ID */
@property (nonatomic, nonnull) NSString *defaultSiteId;
/*! The standard fields that are included in the tracker with each request */
@property (nonatomic, readonly, nonnull) NSArray *standardFields;
/*! The custom fields that are included in the tracker with each request */
@property (nonatomic, readonly, nonnull) NSDictionary *customFields;
/*! YES to enable network activity only when on a Wifi network */
@property (nonatomic) BOOL networkOnWifiOnly;
/*!
 Number of seconds of idle time in between data loads
 */
@property (nonatomic) NSTimeInterval socketReadTimeout;

/*! The main initializer for this class
 @param version the version
 */
-(instancetype _Nonnull)initWithVersion:(NSString * _Nonnull)version;

/*!
 Appends a standard field to the current set of standard fields being sent.
 @param field the field
 */
-(void)addStandardField:(StandardField)field;

/*!
 Add standard fields that will be sent along with every publish request.  The
 system will automatically compute their values before being sent.

 Calling this multiple times will result in the previous default fields being
 removed.

 Note that due to the varargs parameter, this method cannot be used from Swift code.

 For example:

 [tracker addDefaultstandardFields: ApplicationVersion, ApplicationName, nil];
 @param field the nil-terminated list of fields
 @param ... the nil-terminated list of fields
 */
- (void)addStandardFields:(StandardField)field, ... NS_REQUIRES_NIL_TERMINATION;

/*!
 Add standard fields that will be sent along with every publish request.  The
 system will automatically compute their values before being sent.

 Calling this multiple times will result in the previous default fields being
 removed.

 This method should be used to set the default standard fields from Swift code.

 In Obj-C, you should wrap your Standard Fields in number literals:
 NSArray *standardFields = @[@(ApplicationVersion), @(ApplicationName)]
 [tracker addDefaultStandardFields:standardFields];

 In Swift, make sure to call .toRaw() on the standard fields or they will not be inserted in the array properly:
 let standardFields = [StandardField.ApplicationName.toRaw(),
 StandardField.ApplicationVersion.toRaw()];
 tracker.addArrayOfDefaultStandardFields(standardFields)

 @param array - An array of NSNumbers or Swift Numbers wrapping Standard Fields. If the value of one of the NSNumbers does
 not equate to one of the standard fields, an exception will be thrown.
 */
- (void)addArrayOfStandardFields:(NSArray * _Nonnull)array;

/*!
 Adds a custom field that gets added to the request every time.  Setting the
 field in the publish method will override any value set here.
 @param dictionary a set of key/values that will be posted on every request to signal
 */

- (void)addCustomFields:(NSDictionary * _Nonnull)dictionary;

/*!
 Appends a custom field to the list of custom fields being sent.
 @param value the value to be sent
 @param key the field name
 */
-(void)addCustomField:(NSString * _Nullable)value withKey:(NSString *_Nonnull)key;

/*!
 Removes a standard field from the list of fields that are sent to the server.
 @param field a field to remove from the set of standard fields
 */
- (void)removeStandardField:(StandardField)field;

/*!
 Removes a custom field from the list of fields that are sent to the server.
 @param fieldName the name of the field to remove
 */
- (void)removeCustomField:(NSString * _Nonnull)fieldName;

@end
