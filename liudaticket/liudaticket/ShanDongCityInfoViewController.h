//
//  ShanDongCityInfoViewController.h
//  liudaticket
//
//  Created by Eric on 13-11-29.
//  Copyright (c) 2013年 mmc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShanDongCityInfoViewController : UIViewController
@property (strong, nonatomic)NSString *cityName;
@property (strong,nonatomic)NSMutableArray *secInfoArray;
@property (weak, nonatomic) IBOutlet UITableView *cityview;
@property (strong,nonatomic) NSString *indexCount;

@end
