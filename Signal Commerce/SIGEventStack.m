//
//  SIGEventStack.m
//  Signal Commerce
//
//  Created by John Sokel on 6/10/16.
//  Copyright © 2016 Signal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SIGEventStack.h"

@interface SIGEventStack()

@property (strong, nonatomic, readonly) NSMutableArray<id<SignalServerDirectRequest>> *events;

@end

@implementation SIGEventStack

-(instancetype)init {
    self = [super init];
    if (self) {
        _events = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)add:(id<SignalServerDirectRequest>)request {
    NSLog(@"add: %@", request.event);
    @synchronized (self) {
        [_events addObject: request];
        if ([_events count] > 10) {
            [_events removeObjectAtIndex:0];
        }
    }
}

-(NSArray<id<SignalServerDirectRequest>> *)eventItems {
    @synchronized (self) {
        return [_events copy];
    }
}

-(NSString *)lastEventInfo {
    @synchronized (self) {
        if (_events.count == 0) {
            return @"";
        }
        id<SignalServerDirectRequest> last = [_events lastObject];
        return [NSString stringWithFormat:@"%@ (%d)", last.event, [last.data count]];
    }
}

-(void)empty {
    @synchronized (self) {
        [_events removeAllObjects];
        _queueSize = 0;
    }
}

@end
