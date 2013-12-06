//
//  ProductModel.m
//  liudaticket
//
//  Created by Eric on 13-12-2.
//  Copyright (c) 2013年 mmc. All rights reserved.
//

#import "ProductModel.h"
#import <Foundation/Foundation.h>
@implementation ProductModel
//获取景点实体
-(ProductModel *)getProductModel:(NSMutableDictionary *)dic
{
    ProductModel *productModel = [[ProductModel alloc]init];
    if ([dic count]>0) {
        productModel.pro_id = (NSString *)[[dic objectForKey:@"id"] description];
        productModel.pro_name = (NSString *)[[dic objectForKey:@"name"]description];
          productModel.pro_cue = (NSString *)[[dic objectForKey:@"cue"]description];
        productModel.pro_flag = (NSString *)[[dic objectForKey:@"flag"]description];
        productModel.pro_price = (NSString *)[[dic objectForKey:@"price"]description];
        productModel.pro_nowprice = (NSString *)[[dic objectForKey:@"nowprice"]description];
        productModel.pro_intro = (NSString *)[[dic objectForKey:@"intro"]description];
        productModel.pro_content = (NSString *)[[dic objectForKey:@"content"]description];
        productModel.pro_type = (NSString *)[[dic objectForKey:@"type"]description];
        productModel.pro_oncemax = (NSString *)[[dic objectForKey:@"oncemax"]description];
        productModel.pro_oncemin = (NSString *)[[dic objectForKey:@"oncemin"]description];
        productModel.pro_status = (NSString *)[[dic objectForKey:@"status"]description];
        productModel.pro_cityname = (NSString *)[[dic objectForKey:@"cityname"]description];
//        NSLog(@"%@",productModel.pro_price);
    }
     //NSLog(@"%@",productModel.pro_price);
    return productModel;
}

@end
