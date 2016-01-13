//
//  SIGProductDetailController.m
//  Signal Commerce
//
//  Created by Andrew on 1/12/16.
//  Copyright © 2016 Signal. All rights reserved.
//

#import "SIGProductDetailController.h"

@interface SIGProductDetailController()

@property (weak, nonatomic) IBOutlet UIImageView *detailImage;

@end

@implementation SIGProductDetailController

-(void)viewDidAppear:(BOOL)animated {
    [self setTitle:_product.name];


    NSURL *url = [NSURL URLWithString:_product.imageUrl];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img = [[UIImage alloc] initWithData: data];
    _detailImage.image = img;

}

@end
