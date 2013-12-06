//
//  OrderSuccessViewController.h
//  liudaticket
//
//  Created by Eric on 13-12-4.
//  Copyright (c) 2013年 mmc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderSuccessViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *Label_OrderId;
@property (strong, nonatomic) IBOutlet UIButton *Button_Pay;
@property (strong, nonatomic)  NSString *orderid;
@end
