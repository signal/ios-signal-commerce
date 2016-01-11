//
//  SIGCategoryListController.m
//  Signal Commerce
//
//  Created by Andrew on 1/11/16.
//  Copyright © 2016 Signal. All rights reserved.
//

#import "SIGCategoryListController.h"
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "SIGCategory.h"

@interface SIGCategoryListController()

@property (strong, nonatomic) NSArray<SIGCategory *> *categories;

@end

@implementation SIGCategoryListController

@synthesize categories = _categories;

- (void)viewDidLoad {
    _categories = [[self appDelegate].shoppingService findAllCategories];
}

- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"CategoryName"];
    cell.textLabel.text = _categories[indexPath.row].name;
    return cell;
}

@end
