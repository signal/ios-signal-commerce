//
//  SIGProduct.h
//  Signal Commerce
//
//  Created by Andrew on 1/11/16.
//  Copyright © 2016 Signal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FICEntity.h"

@class SIGMoney;

@interface SIGProduct : NSObject<FICEntity>

@property (readonly, nonatomic, strong) NSString *productId;
@property (readonly, nonatomic, strong) NSString *name;
@property (readonly, nonatomic, strong) NSString *imageUrl;
@property (readonly, nonatomic, strong) NSString *fullDescription;
@property (readonly, nonatomic, strong) NSString *sku;
@property (readonly, nonatomic, strong) NSString *shortDescription;
@property (readonly, nonatomic, strong) SIGMoney *cost;
@property (readonly, nonatomic, strong) SIGMoney *costWithTax;
@property (readonly, nonatomic, strong) SIGMoney *tax;
@property (readonly, nonatomic, strong) SIGMoney *regularCost;
@property (readonly, nonatomic, strong) SIGMoney *regularCostWithTax;
@property (readonly, nonatomic, strong) SIGMoney *regularTax;
@property (readonly, nonatomic) BOOL instock;

-(instancetype)initWithDictionary:(NSDictionary *)dict;

-(SIGMoney *)actualCost:(BOOL)preferred;

-(SIGMoney *)actualTax:(BOOL)preferred;

-(SIGMoney *)actualCostWithTax:(BOOL)preferred;

@end
