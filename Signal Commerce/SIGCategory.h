//
//  SIGCategory.h
//  Signal Commerce
//
//  Created by Andrew on 1/11/16.
//  Copyright © 2016 Signal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SIGCategory : NSObject

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *categoryId;
@property (copy, nonatomic) NSString *memberCount;

-(instancetype)initWithDictionary:(NSDictionary *)dict;

@end
