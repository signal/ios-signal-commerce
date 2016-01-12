//
//  MagentoShoppingService.m
//  Signal Commerce
//
//  Created by Andrew on 1/11/16.
//  Copyright © 2016 Signal. All rights reserved.
//

#import "MagentoShoppingService.h"
#import "SIGCategory.h"
#import "SIGCategoryListResponse.h"

#ifdef DEBUG
#define SLog(...) NSLog(__VA_ARGS__);
#else
#define SLog(...)
#endif

static NSString * const COMMERCE_URL = @"https://commerce.signal.ninja/api/rest";

@implementation MagentoShoppingService

-(SIGCategoryListResponse *)findAllCategories {
    NSString *urlString = [COMMERCE_URL stringByAppendingString: @"/categories"];
    SLog(@"Fetching %@", urlString);
    NSURL *myURL = [NSURL URLWithString: urlString];
    NSURLRequest *myRequest = [NSURLRequest requestWithURL:myURL];
    NSURLResponse *response = [[NSURLResponse alloc] init];
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:myRequest
                                         returningResponse: &response error: &error];
    if (data == nil) {
        return nil;
    }
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:0
                                                                   error:&error];
    return [[SIGCategoryListResponse alloc] initFromJson:parsedObject];
}

-(NSArray<SIGProduct *> *)findProductsForCategory:(SIGCategory *)category {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    return [arr copy];
}

@end
