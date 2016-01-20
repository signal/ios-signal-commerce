//  Copyright (c) 2015 Signal, Inc. All rights reserved.

#import <Foundation/Foundation.h>

/*!
 Immutable Signal server-direct response value object.
 */
@protocol SignalServerDirectResponse <NSObject>

/*!
 The number of tags fired for the request.
 
 This property is read-only.
 */
@property(nonatomic, assign, readonly) NSInteger tagsFired;

/*!
 The number of pages matched for the request.
 
 This property is read-only.
 */
@property(nonatomic, assign, readonly) NSInteger pagesMatched;

/*!
 The details of the response body from Signal.
 
 This property is read-only.
 */
@property(nonatomic, copy, readonly) NSString *details;

@end
