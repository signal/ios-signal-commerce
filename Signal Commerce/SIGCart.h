//
//  SIGCart.h
//  Signal Commerce
//
//  Created by Andrew on 2/8/16.
//  Copyright © 2016 Signal. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SIGProduct;
@class SIGCartItem;
@class SIGMoney;

@interface SIGCart : NSObject

@property (nonatomic, readonly) int itemCount;

-(void)add:(SIGProduct *)product withQuantity:(int)quantity;

-(NSArray<SIGCartItem *> *)cartItems;

-(SIGMoney *)subtotal;

-(void)removeItemAtIndex:(unsigned long)index;

-(void)empty;

@end
