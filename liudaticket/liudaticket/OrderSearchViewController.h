//
//  OrderSearchViewController.h
//  liudaticket
//
//  Created by Eric on 13-12-4.
//  Copyright (c) 2013年 mmc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderSearchViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (strong,nonatomic) UITableView *SearchOrdertableview;
@property (strong,nonatomic) UITextField *TextFieldPerson;
@property (strong,nonatomic) UITextField *TextFieldPhone;
@property (strong,nonatomic)  UIButton *ButtonSearch;
@end
