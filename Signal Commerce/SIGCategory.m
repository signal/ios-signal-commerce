//
//  SIGCategory.m
//  Signal Commerce
//
//  Created by Andrew on 1/11/16.
//  Copyright © 2016 Signal. All rights reserved.
//

#import "SIGCategory.h"

@implementation SIGCategory

-(instancetype)initWithName:(NSString *)name id:(NSString *)catId {
    self = [super init];
    if (!self) {
        return nil;
    }
    _name = name;
    _categoryId = catId;
    return self;
}

@end
