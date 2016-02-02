//
//  SIGProductDetailController.m
//  Signal Commerce
//
//  Created by Andrew on 1/12/16.
//  Copyright © 2016 Signal. All rights reserved.
//

#import "SIGProductDetailController.h"
#import "SIGMoney.h"
#import "AppDelegate.h"
#import <SignalSDK/SignalInc.h>

@interface SIGProductDetailController()

@property (weak, nonatomic) IBOutlet UIImageView *detailImage;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *instock;
@property (weak, nonatomic) IBOutlet UILabel *longDescription;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) NSArray *productImages;

@end

@implementation SIGProductDetailController

-(void)viewDidLoad {
    _pageControl.numberOfPages = 1;
    _productImages = @[_product.imageUrl];
    [_pageControl setPageIndicatorTintColor: [UIColor lightGrayColor]];
    [_pageControl setCurrentPageIndicatorTintColor: [UIColor grayColor]];

    [self refreshImages];
    [self setTitle:_product.name];

    [self updateImageAt:0];
    [_price setText: [_product.cost description]];

    if (_product.instock) {
        [_instock setText: @"In Stock"];
        [_instock setTextColor: [UIColor greenColor]];
    } else {
        [_instock setText: @"Out of Stock"];
        [_instock setTextColor: [UIColor redColor]];
    }
    [_longDescription setText: _product.fullDescription];
    [[[SignalInc sharedInstance] defaultTracker] publish:@"view_product" withDictionary:@{@"productId" : _product.sku}];

    UISwipeGestureRecognizer *swipeRightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipe)];
    [swipeRightRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [[self view] addGestureRecognizer:swipeRightRecognizer];

    UISwipeGestureRecognizer *leftRightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipe)];
    [leftRightRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [[self view] addGestureRecognizer:leftRightRecognizer];

}

-(void)updateImageAt:(int)index {
    NSURL *url = [NSURL URLWithString:_productImages[index]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img = [[UIImage alloc] initWithData: data];
    _detailImage.image = img;
}

- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

-(void)refreshImages {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _productImages = [[self appDelegate].shoppingService findAllImagesForProduct:_product.sku];
        [self performSelectorOnMainThread:@selector(updateImageIndices) withObject:nil waitUntilDone:NO];
    });
}

-(void)updateImageIndices {
    _pageControl.numberOfPages = _productImages.count;
}

- (IBAction)pageUpdated:(id)sender {
}

-(void)leftSwipe {
    NSLog(@"left");
    _pageControl.currentPage = _pageControl.currentPage+1;
    [self updateImageAt: _pageControl.currentPage];
}

-(void)rightSwipe {
    NSLog(@"right");
    _pageControl.currentPage = _pageControl.currentPage-1;
    [self updateImageAt: _pageControl.currentPage];
}

@end
