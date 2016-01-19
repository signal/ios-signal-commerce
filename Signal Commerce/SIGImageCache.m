//
//  SIGImageCache.m
//  Signal Commerce
//
//  Created by Andrew on 1/13/16.
//  Copyright © 2016 Signal. All rights reserved.
//

#import "SIGImageCache.h"
#import "SIGProduct.h"

@implementation SIGImageCache

static NSString *XXImageFormatNameProductThumbnailSmall = @"co.signal.signalcommerce.XXImageFormatNameProductThumbnailSmall";
static NSString *XXImageFormatNameProductThumbnailMedium = @"co.signal.signalcommerce.XXImageFormatNameProductThumbnailMedium";
static NSString *XXImageFormatFamilyProductThumbnails = @"co.signal.signalcommerce.XXImageFormatFamilyProductThumbnails";

-(instancetype)init {
    self = [super init];
    if (self) {

        FICImageFormat *smallProductThumbnailImageFormat = [[FICImageFormat alloc] init];
        smallProductThumbnailImageFormat.name = XXImageFormatNameProductThumbnailSmall;
        smallProductThumbnailImageFormat.family = XXImageFormatFamilyProductThumbnails;
        smallProductThumbnailImageFormat.style = FICImageFormatStyle16BitBGR;
        smallProductThumbnailImageFormat.imageSize = CGSizeMake(50, 50);
        smallProductThumbnailImageFormat.maximumCount = 250;
        smallProductThumbnailImageFormat.devices = FICImageFormatDevicePhone;
        smallProductThumbnailImageFormat.protectionMode = FICImageFormatProtectionModeNone;

        FICImageFormat *mediumProductThumbnailImageFormat = [[FICImageFormat alloc] init];
        mediumProductThumbnailImageFormat.name = XXImageFormatNameProductThumbnailMedium;
        mediumProductThumbnailImageFormat.family = XXImageFormatFamilyProductThumbnails;
        mediumProductThumbnailImageFormat.style = FICImageFormatStyle32BitBGRA;
        mediumProductThumbnailImageFormat.imageSize = CGSizeMake(100, 100);
        mediumProductThumbnailImageFormat.maximumCount = 250;
        mediumProductThumbnailImageFormat.devices = FICImageFormatDevicePhone;
        mediumProductThumbnailImageFormat.protectionMode = FICImageFormatProtectionModeNone;
        
        NSArray *imageFormats = @[smallProductThumbnailImageFormat, mediumProductThumbnailImageFormat];

        FICImageCache *sharedImageCache = [FICImageCache sharedImageCache];
        sharedImageCache.delegate = self;
        sharedImageCache.formats = imageFormats;
        return self;
    }
    return nil;
}

-(void)findPreviewImageForProduct:(SIGProduct *)product onComplete:(FICImageCacheCompletionBlock)completionBlock {
    [[FICImageCache sharedImageCache] asynchronouslyRetrieveImageForEntity: product withFormatName: XXImageFormatNameProductThumbnailSmall completionBlock: completionBlock ];

}


- (void)imageCache:(FICImageCache *)imageCache wantsSourceImageForEntity:(id <FICEntity>)entity withFormatName:(NSString *)formatName completionBlock:(FICImageRequestCompletionBlock)completionBlock {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Fetch the desired source image by making a network request
        NSURL *requestURL = [entity sourceImageURLWithFormatName:formatName];
        UIImage *sourceImage = [UIImage imageWithData:[NSData dataWithContentsOfURL: requestURL]];

        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(sourceImage);
        });
    });

}


@end
