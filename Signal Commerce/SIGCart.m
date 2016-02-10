//
//  SIGCart.m
//  Signal Commerce
//
//  Created by Andrew on 2/8/16.
//  Copyright © 2016 Signal. All rights reserved.
//

#import "SIGCart.h"
#import "SIGCartItem.h"
#import "SIGProduct.h"
#import "SIGMoney.h"

@interface SIGCart()

@property (strong, readonly) NSMutableArray<SIGCartItem *> *items;

@end

@implementation SIGCart

-(instancetype)init {
    self = [super init];
    if (self) {
        _items = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)add:(SIGProduct *)product withQuantity:(int)quantity {
    [_items addObject: [[SIGCartItem alloc] initWithProduct: product andQuantity: quantity]];
}

-(NSArray<SIGCartItem *> *)cartItems {
    return [_items copy];
}

-(SIGMoney *)subtotal {
    SIGMoney *money = [[SIGMoney alloc] init];
    for (SIGCartItem *item in _items) {
        // TODO: handle quantity
        money = [item.product.cost add: money];
    }
    return money;
}

-(void)removeItemAtIndex:(unsigned long)index {
    [_items removeObjectAtIndex:index];
}

@end
