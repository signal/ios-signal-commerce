//
//  SIGProduct.m
//  Signal Commerce
//
//  Created by Andrew on 1/11/16.
//  Copyright © 2016 Signal. All rights reserved.
//

#import "SIGProduct.h"

@implementation SIGProduct

-initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (!self) {
        return nil;
    }
    _name = dict[@"name"];
    _fullDescription = dict[@"description"];
    _shortDescription = dict[@"short_description"];
    _imageUrl = dict[@"image_url"];
    _sku = dict[@"sku"];
    return self;
}

@end
