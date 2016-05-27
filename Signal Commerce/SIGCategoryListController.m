//
//  SIGCategoryListController.m
//  Signal Commerce
//
//  Created by Andrew on 1/11/16.
//  Copyright © 2016 Signal. All rights reserved.
//
#import "BBBadgeBarButtonItem.h"
#import <SignalSDK/SignalInc.h>
#import <UIKit/UIKit.h>

#import "MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"

#import "AppDelegate.h"
#import "SIGCategory.h"
#import "SIGCategoryListController.h"
#import "SIGProductDetailController.h"
#import "SIGProduct.h"
#import "SIGMoney.h"
#import "SIGImageCache.h"
#import "SIGPreferences.h"
#import "SIGLoginViewController.h"
#import "SIGCart.h"
#import "SIGCartController.h"
#import "UIViewController+CartAssist.h"
#import "SIGUserService.h"
#import "SIGTracking.h"

@interface SIGCategoryListController()

@property (strong, nonatomic) NSArray<SIGCategory *> *categories;
@property (strong, nonatomic) SIGCategory *parentCategory;
@property (nonatomic, strong) NSArray<SIGProduct *> *products;

@end

@implementation SIGCategoryListController

@synthesize categories = _categories;
@synthesize products = _products;

#pragma mark - UIViewController overrides

- (void)viewDidLoad {
    _categories = [[NSArray alloc] init];
    _products = [[NSArray alloc] init];
    if (_parentCategory == nil) {

    } else {
        [self setTitle: _parentCategory.name];
    }

    UIBarButtonItem *userButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed: @"973-user-toolbar" ] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] style:UIBarButtonItemStylePlain target:self action:@selector(openAccount)];
    [self.navigationItem setRightBarButtonItems:@[userButton, [self setupCart]]];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self refreshCategories];
    if (_parentCategory == nil) {
        [self setupLeftMenuButton];
    }
    BBBadgeBarButtonItem *cartButton = (BBBadgeBarButtonItem *)self.navigationItem.rightBarButtonItems[1];
    [self refreshCart:cartButton];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [[SignalInc sharedInstance].defaultTracker publish:SIG_TRACK_VIEW withDictionary:@{SIG_VIEW_NAME: @"CategoryListView"}];

}

-(void)publishLoadCategories {
    NSString *type = _parentCategory == nil ? @"main" : @"sub";
    NSString *categoryId = _parentCategory == nil ? @"" : _parentCategory.categoryId;
    [[[SignalInc sharedInstance] defaultTracker] publish: SIG_TRACK_EVENT
                                          withDictionary: @{SIG_CATEGORY: SIG_LOAD,
                                                            SIG_ACTION: SIG_CATEGORIES,
                                                            SIG_LABEL: SIG_RESULTS,
                                                            SIG_VALUE: [NSString stringWithFormat: @"%d", _categories.count],
                                                            @"categoryType": type,
                                                            @"categoryId": categoryId}];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(nullable id)sender {
    return [identifier isEqualToString:@"ShowProductDetail"] || [identifier isEqualToString:@"ShowLogin"];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"ShowProductDetail"]) {
        SIGProductDetailController *controller;
        if ( [[self appDelegate] usingSplitView] ) {
            controller = (SIGProductDetailController *)[[segue destinationViewController] topViewController];
            controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
            controller.navigationItem.leftItemsSupplementBackButton = YES;
        } else {
            controller = segue.destinationViewController;
        }
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        controller.product = _products[indexPath.row];
        [[[SignalInc sharedInstance] defaultTracker] publish: SIG_TRACK_EVENT
                                              withDictionary: @{SIG_CATEGORY: SIG_CLICK,
                                                                  SIG_ACTION: SIG_DETAILS,
                                                                   SIG_LABEL: @"productId",
                                                                   SIG_VALUE: controller.product.productId,
                                                                @"productId": controller.product.productId}];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSString *storyBoardName = [[self appDelegate] usingSplitView] ? @"iPadMain" : @"Main";
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyBoardName bundle: nil];
        SIGCategoryListController *dest = [storyboard instantiateViewControllerWithIdentifier: @"CategoryList"];
        dest.parentCategory = _categories[indexPath.row];
        [self.navigationController pushViewController:dest animated:NO];
        [[[SignalInc sharedInstance] defaultTracker] publish: SIG_TRACK_EVENT
                                              withDictionary: @{SIG_CATEGORY: SIG_CLICK,
                                                                SIG_ACTION: SIG_CATEGORY,
                                                                SIG_LABEL: @"categoryId",
                                                                SIG_VALUE: dest.parentCategory.categoryId,
                                                                @"categoryId": dest.parentCategory.categoryId}];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _categories.count;
    } else {
        return _products.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"CategoryName"];
        cell.textLabel.text = _categories[indexPath.row].name;
        cell.detailTextLabel.text = _categories[indexPath.row].memberCount;
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"ProductDescription"];
        SIGProduct *product = _products[indexPath.row];
        cell.textLabel.text = product.name;
        BOOL preferred = [[self appDelegate].userService preferred];
        cell.detailTextLabel.text = [[product actualCost:preferred] description];
        [[self appDelegate].imageCache findPreviewImageForProduct: product onComplete: ^(id <FICEntity> entity, NSString *formatName, UIImage *image) {
            cell.imageView.image = image;
            cell.imageView.layer.cornerRadius = 5;
            cell.imageView.layer.masksToBounds = YES;
            // without this call, the images won't draw properly
            [cell setNeedsLayout];
        }];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    static UILabel* headline;
    static UILabel* subheadline1;

    if (!headline) {
        headline = [[ UILabel alloc]
                    initWithFrame:CGRectMake(0,0, FLT_MAX, FLT_MAX)];
        subheadline1 = [[ UILabel alloc]
                        initWithFrame:CGRectMake(0,0, FLT_MAX, FLT_MAX)];
    }
    headline.text = @"Hoos Foos";
    headline.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    [headline sizeToFit];
    subheadline1.text = @"Snim Nim";
    subheadline1.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    [subheadline1 sizeToFit];

    return subheadline1.frame.size.height + headline.frame.size.height + 30.0;
}


#pragma mark - private methods

- (void)refreshCategories {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // TODO: hook in error handling
        _categories = [[self appDelegate].shoppingService findAllCategories:_parentCategory.categoryId];
        [self publishLoadCategories];
        [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        if (_parentCategory) {
            _products = [[self appDelegate].shoppingService findProductsForCategory:_parentCategory];
            [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        }
    });
}

- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

-(void)setupLeftMenuButton {
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    leftDrawerButton.image = [UIImage imageNamed: @"740-gear-toolbar"];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}

- (void)openAccount {
    UIViewController* accountController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"SIGAccountOverview"];
    if ([[self appDelegate].userService isLoggedIn]) {
        [self.navigationController pushViewController:accountController animated:NO];
    } else {
        SIGLoginViewController* rootController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"SIGLoginViewController"];

        rootController.handoff = accountController;
        rootController.parent = self;
        [self presentViewController:rootController animated:YES completion:^{
        }];
    }
}

-(void)leftDrawerButtonPress:(id)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

@end
