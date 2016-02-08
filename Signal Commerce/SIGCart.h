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

@interface SIGCart : NSObject

-(void)add:(SIGProduct *)product withQuantity:(int)quantity;

-(NSArray<SIGCartItem *> *)cartItems;

@end
