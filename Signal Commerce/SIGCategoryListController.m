//
//  SIGCategoryListController.m
//  Signal Commerce
//
//  Created by Andrew on 1/11/16.
//  Copyright © 2016 Signal. All rights reserved.
//

#import "MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
#import <BBBadgeBarButtonItem/BBBadgeBarButtonItem.h>

#import <UIKit/UIKit.h>
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

#import <SignalSDK/SignalInc.h>

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
        [SignalInc initInstance:nil config:^(SignalConfig *config) {
            config.messageRetryCount = 3;
            config.debug = YES;
            config.dispatchInterval = 1;
            config.messageExpiration = 3600;
            config.maxQueuedMessages = 500;
            config.defaultSiteId = @"abcd123";
            [config addStandardFields: ApplicationName, OsVersion, DeviceIdSHA256, DeviceIdType, nil];
            [config addCustomFields: @{@"uid":@"d56ead9fffff"}];
        }];
        [SIGPreferences load];
        [[SignalInc sharedInstance] trackerWithSiteId: [SignalInc sharedInstance].signalConfig.defaultSiteId];
    } else {
        [self setTitle: _parentCategory.name];
    }

    UIBarButtonItem *userButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed: @"973-user-toolbar" ] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] style:UIBarButtonItemStylePlain target:self action:@selector(openAccount)];
    UIButton *cartView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [cartView addTarget:self action:@selector(shoppingCartClick) forControlEvents:UIControlEventTouchUpInside];
    [cartView setImage: [[UIImage imageNamed: @"952-shopping-cart-toolbar"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [cartView setUserInteractionEnabled:YES];

    BBBadgeBarButtonItem *cartButton = [[BBBadgeBarButtonItem alloc] initWithCustomUIButton:cartView];
    cartButton.badgeValue = [self cartAmount];
    cartButton.badgeMinSize = 2;
    cartButton.badgePadding = 3;
    cartButton.shouldHideBadgeAtZero = YES;
    [self.navigationItem setRightBarButtonItems:@[userButton, cartButton]];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self refreshCategories];
    if (_parentCategory == nil) {
        [self setupLeftMenuButton];
        [[[SignalInc sharedInstance] defaultTracker] publish: @"view:category_list", nil];
    } else {
        [[[SignalInc sharedInstance] defaultTracker] publish: @"view:category_list" withDictionary: @{@"categoryId" : _parentCategory.categoryId}];
    }
    BBBadgeBarButtonItem *cartButton = (BBBadgeBarButtonItem *)self.navigationItem.rightBarButtonItems[1];
    cartButton.badgeValue = [self cartAmount];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(nullable id)sender {
    return [identifier isEqualToString:@"ShowProductDetail"] || [identifier isEqualToString:@"ShowShoppingCart"] || [identifier isEqualToString:@"ShowLogin"];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"ShowProductDetail"]){
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
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSString *storyBoardName = [[self appDelegate] usingSplitView] ? @"iPadMain" : @"Main";
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyBoardName bundle: nil];
        SIGCategoryListController *dest = [storyboard instantiateViewControllerWithIdentifier: @"CategoryList"];
        dest.parentCategory = _categories[indexPath.row];
        [self.navigationController pushViewController:dest animated:YES];
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
        cell.detailTextLabel.text = [product.cost description];
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

#pragma mark - private methods

- (void)refreshCategories {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // TODO: hook in error handling
        _categories = [[self appDelegate].shoppingService findAllCategories:_parentCategory.categoryId];
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
    if ([SIGPreferences loggedInUser]) {
        [self.navigationController pushViewController:accountController animated:NO];
    } else {
        SIGLoginViewController* rootController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"SIGLoginViewController"];

        rootController.handoff = accountController;
        rootController.parent = self;
        [self presentViewController:rootController animated:YES completion:^{
        }];
    }
}

-(NSString *)cartAmount {
    return [NSString stringWithFormat:@"%lu", (unsigned long)[[self appDelegate].cart cartItems].count];
}

-(void)leftDrawerButtonPress:(id)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(void)shoppingCartClick {
    SIGCartController* cartController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"SIGCartController"];

    [self.navigationController pushViewController:cartController animated:YES];

}

@end
