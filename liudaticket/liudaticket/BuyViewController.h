//
//  BuyViewController.h
//  liudaticket
//
//  Created by Eric on 13-12-3.
//  Copyright (c) 2013年 mmc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RadioButton.h"
@interface BuyViewController : UIViewController<UITextFieldDelegate,RadioButtonDelegate>
@property (strong,nonatomic) NSString *pro_name;
@property (strong,nonatomic) NSString *pro_Id;
@property (strong,nonatomic) NSString *pro_price;
@property (strong,nonatomic) NSString *pro_paytype;
@property (strong,nonatomic) UITextField  *accountField;
@property (strong,nonatomic) UITextField  *personField;
@property (strong,nonatomic) UITextField  *phoneField;
@property (strong,nonatomic) NSString  *pro_orderid;

@end
