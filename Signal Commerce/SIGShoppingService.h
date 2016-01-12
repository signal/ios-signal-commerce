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
@class SIGCategoryListResponse;

@protocol SIGShoppingService <NSObject>

-(SIGCategoryListResponse *)findAllCategories;

-(NSArray<SIGProduct *> *)findProductsForCategory:(SIGCategory *)category;

@end
