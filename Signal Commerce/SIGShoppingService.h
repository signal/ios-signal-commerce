//
//  SIGShoppingService.h
//  Signal Commerce
//
//  Created by Andrew on 1/11/16.
//  Copyright © 2016 Signal. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SIGCategory;
@class SIGProduct;

@protocol SIGShoppingService <NSObject>

-(NSArray<SIGCategory *> *)findAllCategories:(NSString *)parentCategory;

-(NSArray<SIGProduct *> *)findProductsForCategory:(SIGCategory *)category;

-(NSArray<NSString *> *)findAllImagesForProduct:(NSString *)sku;

@end
