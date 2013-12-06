//
//  OrderListInfoController.h
//  liudaticket
//
//  Created by only on 13-12-5.
//  Copyright (c) 2013年 mmc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderListInfoController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic)UITableView *OrderInfoTableview;
@property(strong,nonatomic)NSMutableDictionary *Dic_OrderInfo;
@property(strong,nonatomic)UILabel *NameLabel;
@property(strong,nonatomic)UILabel *OrderTypeLabel;
@property(strong,nonatomic)UILabel *OrderStateLabel;
@property(strong,nonatomic)UILabel *VolumeLabel;
@property(strong,nonatomic)UILabel *ExpiredTimeLabel;
@property(strong,nonatomic)UILabel *OrderNumberLabel;
@property(strong,nonatomic)UILabel *OrderTime;
@property(strong,nonatomic)UILabel *Money;
@end
