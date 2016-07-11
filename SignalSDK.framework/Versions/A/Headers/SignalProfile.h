//
//  SignalProfile.h
//  signal-ios-sdk
//
//  Created by Andrew on 3/31/16.
//  Copyright © 2016 Signal, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const _Nonnull kProfileSiteId;
FOUNDATION_EXPORT NSString *const _Nonnull kProfileDataSection;
FOUNDATION_EXPORT NSString *const _Nonnull kProfileData;
FOUNDATION_EXPORT NSString *const _Nonnull kProfileUids;
FOUNDATION_EXPORT NSString *const _Nonnull kProfileExpireDate;
FOUNDATION_EXPORT NSString *const _Nonnull kProfileCreateDate;
FOUNDATION_EXPORT NSString *const _Nonnull kProfileModifiedDate;

/*! Key/value data related to the current user's profile. '*/
@interface SignalProfile : NSObject
/*! The site ID that this profile is associated with */
@property (strong, readonly, nonatomic) NSString * _Nonnull siteId;
/*! The list of UIDs keyed by their UID name */
@property (strong, readonly, nonatomic, nonnull) NSDictionary<NSString *, NSString *> *uids;
/*! The data keyed by the field name */
@property (strong, readonly, nonatomic, nonnull) NSDictionary<NSString *, NSString *> *data;
/*! The date this profile data was created */
@property (strong, readonly, nonatomic, nonnull) NSDate *createdDate;
/*! The date this profile data exires */
@property (strong, readonly, nonatomic, nonnull) NSDate *expiresDate;
/*! The date this profile data was modified */
@property (strong, readonly, nonatomic, nonnull) NSDate *modifiedDate;
/*! Initializes the profile data from JSON
 @param json the data sent down from the server
 */
-(instancetype _Nonnull)initFromJson:(NSDictionary * _Nonnull)json;

/*! Retrieves an individual piece of data by name
 @param key the field name
 */
-(NSString * _Nullable)get:(NSString * _Nonnull )key;

@end

