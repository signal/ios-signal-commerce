//
//  SIGCategoryListController.m
//  Signal Commerce
//
//  Created by Andrew on 1/11/16.
//  Copyright © 2016 Signal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "SIGCategory.h"
#import "SIGCategoryListController.h"
#import "SIGProductListController.h"

@interface SIGCategoryListController()

@property (strong, nonatomic) NSArray<SIGCategory *> *categories;

@end

@implementation SIGCategoryListController

@synthesize categories = _categories;

#pragma mark - UIViewController overrides

- (void)viewDidLoad {
    _categories = [[NSArray alloc] init];
    [self refreshCategories];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"ShowProductsForCategory"]){
        SIGProductListController *controller = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        controller.category = _categories[indexPath.row];
    }
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"CategoryName"];
    cell.textLabel.text = _categories[indexPath.row].name;
    cell.detailTextLabel.text = _categories[indexPath.row].memberCount;
    return cell;
}

#pragma mark - private methods

- (void)refreshCategories {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // TODO: hook in error handling
        _categories = [[self appDelegate].shoppingService findAllCategories];
        [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    });
}

- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

@end
