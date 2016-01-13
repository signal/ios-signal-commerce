//
//  SIGMoney.m
//  Signal Commerce
//
//  Created by Andrew on 1/11/16.
//  Copyright © 2016 Signal. All rights reserved.
//

#import "SIGMoney.h"

@interface SIGMoney()

@property (nonatomic, readonly) int value;

@end

@implementation SIGMoney

-(instancetype)initWithNumber:(NSNumber *)numberValue {
    self = [super init];
    if (self) {
        _value = (int)[numberValue floatValue] * 100;
        return self;
    }
    return nil;
}

-(NSString *)description {
    int val = _value / 100;
    float floatVal = ((float)_value) / 100;
    int remainder = (floatVal - ((float) val)) * 100;
    NSString *remainderString = [NSString stringWithFormat:@"%d", remainder];
    if (remainder < 10) {
        remainderString = [@"0" stringByAppendingString: remainderString];
    }
    return [NSString stringWithFormat: @"$%d.%@", val, remainderString];
}

@end
