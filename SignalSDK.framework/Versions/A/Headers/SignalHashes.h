//
//  SignalHashes.h
//  signal-ios-sdk
//
//  Created by Andrew on 12/4/15.
//  Copyright © 2015 Signal, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignalHashes : NSObject

/*!
 Returns the MD5 hash of the specified target string
 */
+ (NSString *)md5:(NSString *)target;

/*!
 Returns the SHA1 hash of the specified string
 */
+ (NSString *)sha1:(NSString *)target;

/*!
 Returns the SHA256 has of the specified string
 */
+ (NSString *)sha256:(NSString *)target;

@end
