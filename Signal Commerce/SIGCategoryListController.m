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
#import "SIGCategoryListResponse.h"

@interface SIGCategoryListController()

@property (strong, nonatomic) NSArray<SIGCategory *> *categories;

@end

@implementation SIGCategoryListController

@synthesize categories = _categories;

- (void)viewDidLoad {
    _categories = [[NSArray alloc] init];
    [self refreshCategories];
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

- (void)refreshCategories {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // TODO: hook in error handling
        _categories = [[self appDelegate].shoppingService findAllCategories].categories;
        [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    });
}

@end
