//
//  SIGProduct.h
//  Signal Commerce
//
//  Created by Andrew on 1/11/16.
//  Copyright © 2016 Signal. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SIGMoney;

@interface SIGProduct : NSObject

@property (readonly, nonatomic, strong) NSString *imageUrl;
@property (readonly, nonatomic, strong) NSString *description;
@property (readonly, nonatomic, strong) NSString *sku;
@property (readonly, nonatomic, strong) NSString *shortDescription;
@property (readonly, nonatomic, strong) SIGMoney *cost;

@end