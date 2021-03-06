//
//  SIGProduct.m
//  Signal Commerce
//
//  Created by Andrew on 1/11/16.
//  Copyright © 2016 Signal. All rights reserved.
//

#import "FICUtilities.h"
#import "SIGProduct.h"
#import "SIGMoney.h"

@implementation SIGProduct

-initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (!self) {
        return nil;
    }
    _instock = [dict[@"is_saleable"] boolValue];
    _name = dict[@"name"];
    _productId = dict[@"entity_id"];
    _fullDescription = dict[@"description"];
    _shortDescription = dict[@"short_description"];
    _imageUrl = dict[@"image_url"];
    _cost = [[SIGMoney alloc] initWithNumber: dict[@"final_price_without_tax"]];
    _costWithTax = [[SIGMoney alloc] initWithNumber: dict[@"final_price_with_tax"]];
    _tax = [_costWithTax minus: _cost];
    _regularCost = [[SIGMoney alloc] initWithNumber: dict[@"regular_price_without_tax"]];
    _regularCostWithTax = [[SIGMoney alloc] initWithNumber: dict[@"regular_price_with_tax"]];
    _regularTax = [_regularCostWithTax minus: _regularCost];
    _sku = dict[@"sku"];
    return self;
}

-(SIGMoney *)actualCost:(BOOL)preferred {
    return preferred ? _cost : _regularCost;
}


-(SIGMoney *)actualTax:(BOOL)preferred {
    return preferred ? _tax : _regularTax;
}

-(SIGMoney *)actualCostWithTax:(BOOL)preferred {
    return preferred ? _costWithTax : _regularCostWithTax;
}

-(BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    if (![object isKindOfClass: [SIGProduct class]]) {
        return NO;
    }
    SIGProduct *prod = object;
    return [prod.name isEqualToString:_name];

}

#pragma mark - FICEntity methods (methods for loading images from Fast Image Cache)

- (NSString *)UUID {
    CFUUIDBytes UUIDBytes = FICUUIDBytesFromMD5HashOfString(_sku);
    NSString *UUID = FICStringWithUUIDBytes(UUIDBytes);

    return UUID;
}

- (NSString *)sourceImageUUID {
    CFUUIDBytes sourceImageUUIDBytes = FICUUIDBytesFromMD5HashOfString([ [NSURL URLWithString: _imageUrl] absoluteString]);
    NSString *sourceImageUUID = FICStringWithUUIDBytes(sourceImageUUIDBytes);

    return sourceImageUUID;
}

- (NSURL *)sourceImageURLWithFormatName:(NSString *)formatName {
    return [NSURL URLWithString:_imageUrl];
}


- (FICEntityImageDrawingBlock)drawingBlockForImage:(UIImage *)image withFormatName:(NSString *)formatName {
    FICEntityImageDrawingBlock drawingBlock = ^(CGContextRef context, CGSize contextSize) {
        CGRect contextBounds = CGRectZero;
        contextBounds.size = contextSize;
        CGContextClearRect(context, contextBounds);

        UIGraphicsPushContext(context);
        [image drawInRect:contextBounds];
        UIGraphicsPopContext();
    };
    return drawingBlock;
}

@end
