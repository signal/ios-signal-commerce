//
//  MagentoShoppingService.m
//  Signal Commerce
//
//  Created by Andrew on 1/11/16.
//  Copyright © 2016 Signal. All rights reserved.
//

#import "MagentoShoppingService.h"
#import "SIGCategory.h"

@implementation MagentoShoppingService

-(NSArray<SIGCategory *> *)findAllCategories {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [arr addObject: [[SIGCategory alloc] initWithName: @"Accessories" id: @"6"]];
    [arr addObject: [[SIGCategory alloc] initWithName: @"Home Decor" id: @"7"]];
    [arr addObject: [[SIGCategory alloc] initWithName: @"Men" id: @"5"]];
    [arr addObject: [[SIGCategory alloc] initWithName: @"Sale" id: @"8"]];
    [arr addObject: [[SIGCategory alloc] initWithName: @"VIP" id: @"9"]];
    [arr addObject: [[SIGCategory alloc] initWithName: @"Women" id: @"4"]];
    return arr;
}

@end
