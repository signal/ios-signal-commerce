//
//  SIGProductListController.m
//  Signal Commerce
//
//  Created by Andrew on 1/12/16.
//  Copyright © 2016 Signal. All rights reserved.
//

#import "SIGProductListController.h"
#import "SIGProductDetailController.h"
#import "AppDelegate.h"
#import "SIGProduct.h"
#import "SIGCategory.h"
#import "SIGMoney.h"
#import "SIGImageCache.h"

@interface SIGProductListController()

@property (nonatomic, strong) NSArray<SIGProduct *> *products;

@end

@implementation SIGProductListController

#pragma mark - UIViewController overrides

- (void)viewDidLoad {
    _products = [[NSArray alloc] init];
}

- (void)viewDidAppear:(BOOL)animated {
    if (_category) {
        [self setTitle: _category.name];
    }
    [self loadProducts];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"ShowProductDetail"]){
        SIGProductDetailController *controller = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        controller.product = _products[indexPath.row];
    }
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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


#pragma mark - private methods

- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)loadProducts {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _products = [[self appDelegate].shoppingService findProductsForCategory:_category];
        [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    });
}

@end
