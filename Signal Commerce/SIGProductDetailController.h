//
//  SIGProductDetailController.h
//  Signal Commerce
//
//  Created by Andrew on 1/12/16.
//  Copyright © 2016 Signal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SIGProduct.h"

@interface SIGProductDetailController : UIViewController<UIScrollViewDelegate>

@property (nonatomic, strong) SIGProduct *product;

@end
