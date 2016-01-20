//
//  MagentoShoppingService.m
//  Signal Commerce
//
//  Created by Andrew on 1/11/16.
//  Copyright © 2016 Signal. All rights reserved.
//

#import "MagentoShoppingService.h"
#import "SIGCategory.h"
#import "SIGProduct.h"

#ifdef DEBUG
#define SLog(...) NSLog(__VA_ARGS__);
#else
#define SLog(...)
#endif

static NSString * const COMMERCE_URL = @"https://commerce.signal.ninja/api/rest";

@implementation MagentoShoppingService

-(NSArray<SIGCategory *> *)findAllCategories:(NSString *)parentCategory {
    NSString *urlString = [COMMERCE_URL stringByAppendingString: @"/categories"];
    if (parentCategory) {
        urlString = [urlString stringByAppendingFormat:@"/%@", parentCategory];
    }
    return [self parseCategories: [self request: urlString]];
}

-(NSArray<SIGProduct *> *)findProductsForCategory:(SIGCategory *)category {

    NSString *urlString = [COMMERCE_URL stringByAppendingFormat: @"/products?limit=100&category_id=%@", category.categoryId];
    id json = [self request:urlString];
    if ([json isKindOfClass: [NSDictionary class]]) {
        return [self parseProducts: json];
    }
    return [[NSArray alloc] init];
}

#pragma mark - private methods

- (id)request:(NSString *)url {
    SLog(@"Fetching %@", url);
    NSURL *myURL = [NSURL URLWithString: url];
    NSURLRequest *myRequest = [NSURLRequest requestWithURL:myURL];
    NSURLResponse *response = [[NSURLResponse alloc] init];
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:myRequest
                                         returningResponse: &response error: &error];
    if (data == nil) {
        return nil;
    }
    return [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
}

-(NSArray<SIGCategory *> *)parseCategories:(NSDictionary *)json {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (NSString *keyVal in [json allKeys]) {
        NSDictionary *value = [json objectForKey:keyVal];
        [arr addObject: [[SIGCategory alloc] initWithDictionary: value]];
    }
    return [arr copy];
}

-(NSArray<SIGProduct *> *)parseProducts:(NSDictionary *)json {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (NSString *keyVal in [json allKeys]) {
        NSDictionary *value = [json objectForKey:keyVal];
        [arr addObject: [[SIGProduct alloc] initWithDictionary: value]];
    }
    return [arr copy];
}

@end
