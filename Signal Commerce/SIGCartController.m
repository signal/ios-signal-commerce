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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 1 : [[self appDelegate].cart cartItems].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier: @"Subtotal"];
        cell.textLabel.text = @"Subtotal";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [[self appDelegate].cart subtotal]];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier: @"ProductDescription"];
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
    }

    return cell;
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



@end
