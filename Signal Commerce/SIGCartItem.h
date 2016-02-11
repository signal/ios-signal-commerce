//
//  SIGCartItem.h
//  Signal Commerce
//
//  Created by Andrew on 2/8/16.
//  Copyright © 2016 Signal. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SIGProduct;

@interface SIGCartItem : NSObject

@property (strong, readonly, nonatomic) SIGProduct *product;
@property (readonly, nonatomic) int quantity;

-(instancetype)initWithProduct:(SIGProduct *) product andQuantity:(int) quantity;

-(void)increaseQuantityBy:(int)quantity;

@end
