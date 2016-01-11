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

-(instancetype)initWithName:(NSString *)name id:(NSString *)catId;

@end
