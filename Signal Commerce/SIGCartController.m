//
//  SIGCartController.m
//  Signal Commerce
//
//  Created by Andrew on 2/8/16.
//  Copyright © 2016 Signal. All rights reserved.
//

#import "SIGCartController.h"
#import "AppDelegate.h"
#import "SIGProduct.h"
#import "SIGCart.h"
#import "SIGCartItem.h"
#import "SIGMoney.h"
#import "SIGImageCache.h"

@implementation SIGCartController

- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self appDelegate].cart cartItems].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"ProductDescription"];
    SIGCartItem *item = [[self appDelegate].cart cartItems][indexPath.row];
    cell.textLabel.text = item.product.name;
    cell.detailTextLabel.text = [item.product.cost description];
    [[self appDelegate].imageCache findPreviewImageForProduct: item.product onComplete: ^(id <FICEntity> entity, NSString *formatName, UIImage *image) {
        cell.imageView.image = image;
        cell.imageView.layer.cornerRadius = 5;
        cell.imageView.layer.masksToBounds = YES;
        // without this call, the images won't draw properly
        [cell setNeedsLayout];
    }];
    return cell;
}

@end
