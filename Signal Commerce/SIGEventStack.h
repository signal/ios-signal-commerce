//
//  SIGEventStack.h
//  Signal Commerce
//
//  Created by John Sokel on 6/10/16.
//  Copyright © 2016 Signal. All rights reserved.
//

#import <SignalSDK/SignalInc.h>

@interface SIGEventStack : NSObject

@property (atomic) int queueSize;

-(void)add:(id<SignalServerDirectRequest>)request;

-(NSArray<id<SignalServerDirectRequest>> *)eventItems;

/*!
 Returns the event name of the last event that was added
 */
-(NSString *)lastEventInfo;

-(void)empty;

@end
