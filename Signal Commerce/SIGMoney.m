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

-(instancetype)init {
    return [self initWithInternalNumber: 0];
}

-(instancetype)initWithNumber:(NSNumber *)numberValue {
    return [self initWithInternalNumber:(int)[numberValue floatValue] * 100];
}

// default initializer
-(instancetype)initWithInternalNumber:(int)value {
    self = [super init];
    if (self) {
        _value = value;
    }
    return self;
}

-(SIGMoney *)add:(SIGMoney *)money {
    return [[SIGMoney alloc] initWithInternalNumber: money.value + _value];
}

-(SIGMoney *)minus:(SIGMoney *)money {
    return [[SIGMoney alloc] initWithInternalNumber: _value - money.value];
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
