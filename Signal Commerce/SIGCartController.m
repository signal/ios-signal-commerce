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
#import "SIGPreferences.h"
#import "SIGLoginViewController.h"
#import "SIGUserService.h"
#import "SIGTracking.h"
#import <SignalSDK/SignalInc.h>

@implementation SIGCartController

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [[SignalInc sharedInstance].defaultTracker publish:SIG_TRACK_VIEW withDictionary:@{SIG_VIEW_NAME: @"CartView"}];
}

- (IBAction)editClick:(id)sender {
    [self setEditing:![self isEditing] animated:YES];
}

- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (IBAction)checkoutClick:(id)sender {
    if ([[self appDelegate].cart isEmpty]) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Cart is Empty"
                                                                       message:@"You can't check out when there are no items in the cart."
                                                                preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }

    [[[SignalInc sharedInstance] defaultTracker] publish: SIG_TRACK_EVENT
                                          withDictionary: @{SIG_CATEGORY: SIG_CLICK,
                                                              SIG_ACTION: SIG_PURCHASE}];

    UIViewController* checkoutController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"Checkout"];
    if ([[self appDelegate].userService isLoggedIn]) {
        [self.navigationController pushViewController:checkoutController animated:NO];
    } else {
        SIGLoginViewController* rootController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"SIGLoginViewController"];

        rootController.handoff = checkoutController;
        rootController.parent = self;
        [self presentViewController:rootController animated:YES completion:^{
        }];
    }
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
        if ([[self appDelegate].cart isEmpty]) {
            [tableView reloadData];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 1 : [[[self appDelegate].cart cartItems] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        if ([[self appDelegate].cart isEmpty]) {
            cell = [tableView dequeueReusableCellWithIdentifier: @"CartEmpty"];
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier: @"Subtotal"];
            [self updateSubtotal:cell];
        }
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier: @"ProductDescription"];
        SIGCartItem *item = [[self appDelegate].cart cartItems][indexPath.row];
        UILabel *label = (UILabel *)[cell.contentView viewWithTag:2];
        label.text = item.product.name;
        label = (UILabel *)[cell.contentView viewWithTag:4];
        label.text = [NSString stringWithFormat:@"Quantity: %d", item.quantity];
        label = (UILabel *)[cell.contentView viewWithTag:3];
        BOOL preferred = [[self appDelegate].userService preferred];
        label.text = [[item.product actualCost:preferred] description];
        [[self appDelegate].imageCache findPreviewImageForProduct: item.product onComplete: ^(id <FICEntity> entity, NSString *formatName, UIImage *image) {
            UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:1];
            imageView.image = image;
            imageView.layer.cornerRadius = 5;
            imageView.layer.masksToBounds = YES;
            // without this call, the images won't draw properly
            [cell setNeedsLayout];
        }];
    }

    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

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

    if (indexPath.section == 0) {
        return (headline.frame.size.height * 3) + 45.0;
    } else {
        return subheadline1.frame.size.height + headline.frame.size.height + 30.0;
    }
}

-(void)updateSubtotal:(UITableViewCell *)cell {
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:5];
    BOOL preferred = [[self appDelegate].userService preferred];
    label.text = [NSString stringWithFormat:@"%@", [[self appDelegate].cart subtotal: preferred]];
    label = (UILabel *)[cell.contentView viewWithTag:6];
    label.text = [NSString stringWithFormat:@"%@", [[self appDelegate].cart taxes: preferred]];
    label = (UILabel *)[cell.contentView viewWithTag:7];
    label.text = [NSString stringWithFormat:@"%@", [[self appDelegate].cart total: preferred]];
}

@end
