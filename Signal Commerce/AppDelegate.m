//
//  AppDelegate.m
//  Signal Commerce
//
//  Created by Andrew on 1/11/16.
//  Copyright © 2016 Signal. All rights reserved.
//
#import "MMDrawerController.h"
#import "MMDrawerVisualState.h"

#import "AppDelegate.h"
#import "MagentoShoppingService.h"
#import "SIGImageCache.h"
#import "SIGProductDetailController.h"
#import "SIGCart.h"
#import "SIGCartDAO.h"

@interface AppDelegate () <UISplitViewControllerDelegate>

@property (strong, nonatomic, readonly) SIGCartDAO *cartDAO;

@end

@implementation AppDelegate

@synthesize shoppingService = _shoppingService;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _shoppingService = [[MagentoShoppingService alloc] init];
    _imageCache = [[SIGImageCache alloc] init];
    _cart = [[SIGCart alloc] init];
    _cartDAO = [[SIGCartDAO alloc] init];
    SIGCart *cart = [_cartDAO load];
    if (cart) {
        _cart = cart;
    }

    if ([self usingSplitView]) {
        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
        UINavigationController *navigationController = [splitViewController.viewControllers firstObject];
        navigationController.topViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem;
        splitViewController.delegate = self;
    } else {
        MMDrawerController * drawerController = (MMDrawerController *)self.window.rootViewController;
        [drawerController setMaximumRightDrawerWidth:200.0];
        [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
        [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
        [drawerController setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
        }];
    }
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [_cartDAO save: _cart];
}


- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {

    if ([secondaryViewController isKindOfClass:[UINavigationController class]] &&
        [[(UINavigationController *)secondaryViewController topViewController] isKindOfClass:[SIGProductDetailController class]]) {
        SIGProductDetailController *controller = (SIGProductDetailController *)[(UINavigationController *)secondaryViewController topViewController];
        return [controller product] == nil;
        return YES;
    } else {
        return NO;
    }
}

-(BOOL)usingSplitView {
    return NO;
//return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
}

@end
