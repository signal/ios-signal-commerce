//
//  SIGProductDetailController.m
//  Signal Commerce
//
//  Created by Andrew on 1/12/16.
//  Copyright © 2016 Signal. All rights reserved.
//

#import "SIGProductDetailController.h"
#import "SIGMoney.h"

@interface SIGProductDetailController()

@property (weak, nonatomic) IBOutlet UIImageView *detailImage;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *instock;
@property (weak, nonatomic) IBOutlet UILabel *longDescription;

@end

@implementation SIGProductDetailController

-(void)viewDidAppear:(BOOL)animated {
    [self setTitle:_product.name];

    NSURL *url = [NSURL URLWithString:_product.imageUrl];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img = [[UIImage alloc] initWithData: data];
    _detailImage.image = img;

    [_price setText: [_product.cost description]];

    if (_product.instock) {
        [_instock setText: @"In Stock"];
        [_instock setTextColor: [UIColor greenColor]];
    } else {
        [_instock setText: @"Out of Stock"];
        [_instock setTextColor: [UIColor redColor]];
    }
    [_longDescription setText: _product.fullDescription];
}

@end
