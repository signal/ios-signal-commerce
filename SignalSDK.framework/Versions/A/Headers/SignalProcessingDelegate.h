//  Copyright (c) 2015 Signal, Inc. All rights reserved.

#import <Foundation/Foundation.h>
#import "SignalServerDirectRequest.h"
#import "SignalServerDirectResponse.h"

@protocol SignalProcessingDelegate <NSObject>
@optional

/*!
 Invoked when the published request completes.  If an error occurred, the response will be
 nil and the error object will be non-nil.  Conversely, in the case where there was no error,
 the response object will be non-nil and the error message will be nil.
 */
-(void)didPublish:(id<SignalServerDirectRequest> _Nonnull)request withResponse:(id<SignalServerDirectResponse> _Nullable)response orError:(NSError * _Nullable)error;

/*!
 Invoked when the an item has been processed from the publishing queue
 */
-(void)didProcessQueue:(int)queueSize;

@end
