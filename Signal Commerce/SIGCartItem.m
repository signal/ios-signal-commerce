//
//  SIGCartItem.m
//  Signal Commerce
//
//  Created by Andrew on 2/8/16.
//  Copyright © 2016 Signal. All rights reserved.
//

#import "SIGCartItem.h"

@implementation SIGCartItem

-(instancetype)initWithProduct:(SIGProduct *) product andQuantity:(int) quantity {
    self = [super init];
    if (self) {
        _product = product;
        _quantity = quantity;
    }
    return self;
}

-(void)increaseQuantityBy:(int)quantity {
    _quantity += quantity;
}

@end
