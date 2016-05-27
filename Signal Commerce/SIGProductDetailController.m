//
//  SIGProductDetailController.m
//  Signal Commerce
//
//  Created by Andrew on 1/12/16.
//  Copyright © 2016 Signal. All rights reserved.
//

#import "SIGProductDetailController.h"
#import "SIGMoney.h"
#import "SIGCart.h"
#import "AppDelegate.h"
#import "UIViewController+CartAssist.h"

#import <SignalSDK/SignalInc.h>
#import "SIGUserService.h"
#import "SIGTracking.h"

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
    [_pageControl setPageIndicatorTintColor: [UIColor lightGrayColor]];
    [_pageControl setCurrentPageIndicatorTintColor: [UIColor grayColor]];
    [self setTitle:_product.name];
    BOOL preferred = [[self appDelegate].userService preferred];
    [_price setText: [[_product actualCost: preferred] description]];
    if (_product.instock) {
        [_instock setText: @"In Stock"];
        [_instock setTextColor: [UIColor greenColor]];
    } else {
        [_instock setText: @"Out of Stock"];
        [_instock setTextColor: [UIColor redColor]];
    }
    [_longDescription setText: _product.fullDescription];
    // this path will only happen on the iPad in splitview mode
    if (!_product.imageUrl) {
        [_instock setHidden: YES];
        [_pageControl setHidden: YES];
        _productImages = [[NSArray alloc] init];
        // this would be the case on the iPad
    } else {
        _productImages = @[_product.imageUrl];
        [self refreshImages];
        [self updateImageAt:0];
        [self setupGestures];
    }
    self.navigationItem.rightBarButtonItem = [self setupCart];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self refreshCart:self.navigationItem.rightBarButtonItem];
    [[SignalInc sharedInstance].defaultTracker publish:SIG_TRACK_VIEW withDictionary:@{SIG_VIEW_NAME: @"ProductDetailsView"}];
}

-(void)updateImageAt:(int)index {
    if (index < 0 || index >= _productImages.count) {
        return;
    }
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
        
        [[[SignalInc sharedInstance] defaultTracker] publish:SIG_TRACK_EVENT
                                              withDictionary:@{SIG_CATEGORY: SIG_LOAD,
                                                               SIG_ACTION: SIG_IMAGES,
                                                               SIG_LABEL: SIG_RESULTS,
                                                               SIG_VALUE: [@(_productImages.count) stringValue]}];
        [self performSelectorOnMainThread:@selector(updateImageIndices) withObject:nil waitUntilDone:NO];
    });
}

-(void)updateImageIndices {
    _pageControl.numberOfPages = _productImages.count;
}

- (IBAction)pageUpdated:(id)sender {
    [self updateImageAt: (int)_pageControl.currentPage];
}

-(void)leftSwipe {
    _pageControl.currentPage = _pageControl.currentPage+1;
    [self updateImageAt: (int)_pageControl.currentPage];
}

-(void)rightSwipe {
    _pageControl.currentPage = _pageControl.currentPage-1;
    [self updateImageAt: (int)_pageControl.currentPage];
}

- (IBAction)addToCartClicked:(id)sender {
    [[[SignalInc sharedInstance] defaultTracker] publish:SIG_TRACK_EVENT
                                          withDictionary:@{SIG_CATEGORY: SIG_SHOP,
                                                           SIG_ACTION: SIG_CART_ADD,
                                                           SIG_LABEL: @"productId",
                                                           SIG_VALUE: _product.productId,
                                                           @"productId" : _product.productId,
                                                           @"sku" : _product.sku,
                                                           @"price" : [_product.costWithTax description]}];
    [[self appDelegate].cart add: _product withQuantity: 1];
    [self refreshCart: self.navigationItem.rightBarButtonItem];
}

-(void)setupGestures {
    UISwipeGestureRecognizer *swipeRightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipe)];
    [swipeRightRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [[self view] addGestureRecognizer:swipeRightRecognizer];

    UISwipeGestureRecognizer *leftRightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipe)];
    [leftRightRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [[self view] addGestureRecognizer:leftRightRecognizer];
}

@end
