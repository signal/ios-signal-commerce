//
//  SIGImageCache.h
//  Signal Commerce
//
//  Created by Andrew on 1/13/16.
//  Copyright © 2016 Signal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FICImageCache.h"

@class SIGProduct;

@interface SIGImageCache : NSObject<FICImageCacheDelegate>

-(void)findPreviewImageForProduct:(SIGProduct *)product onComplete:(FICImageCacheCompletionBlock)completionBlock;

@end
