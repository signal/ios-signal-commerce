//
//  SIGShoppingService.h
//  Signal Commerce
//
//  Created by Andrew on 1/11/16.
//  Copyright © 2016 Signal. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SIGCategory;

@protocol SIGShoppingService <NSObject>

-(NSArray<SIGCategory *> *)findAllCategories;

@end
