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

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}
- (IBAction)editClick:(id)sender {
    [self setEditing:![self isEditing] animated:YES];
}

- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

#pragma mark - UITableViewDataSource methods

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 1;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[self appDelegate].cart removeItemAtIndex: indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath: [NSIndexPath indexPathForRow:0 inSection:0] ];
        [self updateSubtotal: cell];
    }
}

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
        [self updateSubtotal:cell];
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

-(void)updateSubtotal:(UITableViewCell *)cell {
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [[self appDelegate].cart subtotal]];
}

@end
