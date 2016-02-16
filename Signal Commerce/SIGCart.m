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

@property (strong, nonatomic, readonly) NSMutableArray<SIGCartItem *> *items;

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
    _itemCount = _itemCount + quantity;
    // TODO: not efficient
    for (SIGCartItem *cartItem in _items) {
        if ([cartItem.product isEqual: product]) {
            [cartItem increaseQuantityBy: quantity];
            return;
        }
    }
    [_items addObject: [[SIGCartItem alloc] initWithProduct: product andQuantity: quantity]];
}

-(NSArray<SIGCartItem *> *)cartItems {
    return [_items copy];
}


-(SIGMoney *)taxes {
    SIGMoney *money = [[SIGMoney alloc] init];
    for (SIGCartItem *item in _items) {
        for (int i=0; i < item.quantity; i++) {
            money = [item.product.tax add: money];
        }
    }
    return money;
}

-(SIGMoney *)total {
    SIGMoney *money = [[SIGMoney alloc] init];
    for (SIGCartItem *item in _items) {
        for (int i=0; i < item.quantity; i++) {
            money = [item.product.costWithTax add: money];
        }
    }
    return money;
}

-(SIGMoney *)subtotal {
    SIGMoney *money = [[SIGMoney alloc] init];
    for (SIGCartItem *item in _items) {
        for (int i=0; i < item.quantity; i++) {
            money = [item.product.cost add: money];
        }
    }
    return money;
}

-(void)removeItemAtIndex:(unsigned long)index {
    [_items removeObjectAtIndex:index];
    [self recalcItemCount];
}

-(void)empty {
    [_items removeAllObjects];
    _itemCount = 0;
}

-(void)recalcItemCount {
    _itemCount = 0;
    for (SIGCartItem *item in _items) {
        _itemCount += item.quantity;
    }
}

-(BOOL)isEmpty {
    return _itemCount == 0;
}

@end
