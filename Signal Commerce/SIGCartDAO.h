//
//  SIGCartDAO.h
//  Signal Commerce
//
//  Created by Andrew on 3/1/16.
//  Copyright © 2016 Signal. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SIGCart;

@interface SIGCartDAO : NSObject

-(void)save:(SIGCart * _Nonnull)cart;

-(SIGCart * _Nullable)load;

@end
