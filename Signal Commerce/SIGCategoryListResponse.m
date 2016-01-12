//
//  SIGCategoryListResponse.m
//  Signal Commerce
//
//  Created by Andrew on 1/12/16.
//  Copyright © 2016 Signal. All rights reserved.
//

#import "SIGCategoryListResponse.h"
#import "SIGCategory.h"

@implementation SIGCategoryListResponse

// designated constructor
-(instancetype)initFromJson:(NSDictionary *)json {
    return [self initWithJson:json andError:nil];
}

-(instancetype)initFromError:(NSError *)err {
    return [self initWithJson:nil andError:err];
}

-(instancetype)initWithJson:(NSDictionary *)json andError:(NSError *)error {
    self = [super init];
    if (!self) {
        return nil;
    }
    if (json == nil) {
        _categories = [[NSArray alloc] init];
    } else {
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        for (NSString *keyVal in [json allKeys]) {
            NSDictionary *value = [json objectForKey:keyVal];
            [arr addObject: [[SIGCategory alloc] initWithName: [value objectForKey:@"name"] id:keyVal]];
        }
        _categories = [arr copy];
    }
    _err = error;
    return self;
}

@end
