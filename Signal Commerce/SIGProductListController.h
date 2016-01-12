//
//  SIGProductListController.h
//  Signal Commerce
//
//  Created by Andrew on 1/12/16.
//  Copyright © 2016 Signal. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SIGCategory;

@interface SIGProductListController : UITableViewController

@property (nonatomic, strong) SIGCategory *category;

@end
