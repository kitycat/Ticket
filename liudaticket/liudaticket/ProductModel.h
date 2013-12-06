//
//  ProductModel.h
//  liudaticket
//
//  Created by Eric on 13-12-2.
//  Copyright (c) 2013年 mmc. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface ProductModel : NSObject
@property (strong, nonatomic)NSString *pro_id;
@property (strong, nonatomic)NSString *pro_name;
@property (strong, nonatomic)NSString *pro_flag;
@property (strong, nonatomic)NSString *pro_price;
@property (strong, nonatomic)NSString *pro_nowprice;
@property (strong, nonatomic)NSString *pro_content;
@property (strong, nonatomic)NSString *pro_cue;
@property (strong, nonatomic)NSString *pro_type;
@property (strong, nonatomic)NSString *pro_oncemax;
@property (strong, nonatomic)NSString *pro_oncemin;
@property (strong, nonatomic)NSString *pro_status;
@property (strong, nonatomic)NSString *pro_cityname;
@property (strong, nonatomic)NSString *pro_intro;
@property (strong, nonatomic)NSMutableArray *pro_imagearray;
- (ProductModel *)getProductModel:(NSMutableDictionary *) dic;
@end
