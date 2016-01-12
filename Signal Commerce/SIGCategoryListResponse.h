//
//  SIGCategoryListResponse.h
//  Signal Commerce
//
//  Created by Andrew on 1/12/16.
//  Copyright © 2016 Signal. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SIGCategory;

@interface SIGCategoryListResponse : NSObject

@property (strong, nonatomic) NSError *err;
@property (strong, nonatomic) NSArray<SIGCategory *> *categories;

-(instancetype)initFromJson:(NSDictionary *)json;

-(instancetype)initFromError:(NSError *)err;

-(instancetype)initWithJson:(NSDictionary *)json andError:(NSError *)error;

@end
