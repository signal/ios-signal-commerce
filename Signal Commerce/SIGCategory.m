//
//  SIGCategory.m
//  Signal Commerce
//
//  Created by Andrew on 1/11/16.
//  Copyright © 2016 Signal. All rights reserved.
//

#import "SIGCategory.h"

@implementation SIGCategory

-(instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (!self) {
        return nil;
    }
    _name = [dict[@"name"] copy];
    _categoryId = [dict[@"category_id"] copy];
    _memberCount = [dict[@"children_count"] copy];
    return self;
}

@end
