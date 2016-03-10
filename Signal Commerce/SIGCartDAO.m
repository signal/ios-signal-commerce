//
//  SIGCartDAO.m
//  Signal Commerce
//
//  Created by Andrew on 3/1/16.
//  Copyright © 2016 Signal. All rights reserved.
//

#import "SIGCartDAO.h"
#import "SIGCart.h"
#import "SIGCartItem.h"
#import "SIGProduct.h"
#import "SIGMoney.h"
#import <FMDB/FMDatabase.h>

@implementation SIGCartDAO

-(instancetype)init {
    self = [super init];

    return self;
}

-(void)save:(SIGCart * _Nonnull)cart {
    FMDatabase *db = [self openDB];
    [db executeUpdate: @"delete from cart_item"];
    for (SIGCartItem *item in [cart cartItems]) {
        SIGProduct *product = item.product;
        [db executeUpdate:@"insert into cart_item (product_id, name, imageUrl, fullDescription, sku, shortDescription, cost, costWithTax, tax, instock, quantity) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)" withArgumentsInArray:@[product.productId, product.name, product.imageUrl, product.fullDescription, product.sku, product.shortDescription, @(product.cost.internalNumber), @(product.costWithTax.internalNumber), @(product.tax.internalNumber), @(product.instock), @(item.quantity)]];
    }
    [db close];
}

-(SIGCart * _Nullable)load {
    FMDatabase *db = [self openDB];
    SIGCart *cart = [[SIGCart alloc] init];
    FMResultSet *rs = [db executeQuery: @"select * from cart_item"];
    while ([rs next]) {
        NSDictionary *params = @{@"is_saleable" : @([rs boolForColumn: @"instock"]),
                                 @"entity_id" : @([rs intForColumn:@"product_id"]),
                                 @"name" : [rs stringForColumn:@"name"],
                                 @"description" : [rs stringForColumn:@"fullDescription"],
                                 @"short_description" :  [rs stringForColumn:@"shortDescription"],
                                 @"image_url" : [rs stringForColumn:@"imageUrl"],
                                 @"final_price_without_tax" : @((float)[rs intForColumn:@"cost"] / 100),
                                 @"final_price_with_tax" : @((float)[rs intForColumn:@"costWithTax"] / 100),
                                 @"sku": [rs stringForColumn: @"sku"]
                                 };
        SIGProduct *product = [[SIGProduct alloc] initWithDictionary: params];
        [cart add:product withQuantity:[rs intForColumn:@"quantity"]];
    }
    [db close];
    return cart;
}

-(FMDatabase *)openDB {
    NSString *docsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *dbPath   = [docsPath stringByAppendingPathComponent:@"shopping.db"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL dbExists = [fileManager fileExistsAtPath:dbPath];
    FMDatabase *db     = [FMDatabase databaseWithPath:dbPath];
    if (![db open]) {
        return nil;
    }
    if (!dbExists) {
        [db executeUpdate: @"create table version (version integer);" ];
        [db executeUpdate: @"create table cart_item (product_id text, name text, imageUrl text, fullDescription text, sku text, shortDescription text, cost integer, costWithTax integer, tax integer, instock integer, quantity integer);"];
    }
    return db;
}

@end
