//
//  SIGMoney.h
//  Signal Commerce
//
//  Created by Andrew on 1/11/16.
//  Copyright © 2016 Signal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SIGMoney : NSObject

-(instancetype)init;

-(instancetype)initWithNumber:(NSNumber *)numberValue;

-(SIGMoney *)add:(SIGMoney *)money;

@end
