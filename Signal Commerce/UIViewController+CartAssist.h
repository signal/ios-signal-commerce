//
//  UIViewController+CartAssist.h
//  Signal Commerce
//
//  Created by Andrew on 2/9/16.
//  Copyright © 2016 Signal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (CartAssist)

-(UIBarButtonItem *)setupCart;
-(void)setupToolbar;
-(void)updateToolbar;

-(void)refreshCart:(UIBarButtonItem *)item;
-(void)updateQueueSize:(NSNumber *)queueSize;
-(void)updateEvent:(NSString *)eventInfo;

@end
