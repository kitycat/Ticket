//
//  SearchOrderListViewController.h
//  liudaticket
//
//  Created by Eric on 13-12-4.
//  Copyright (c) 2013年 mmc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchOrderListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic) NSString *strPerson;
@property (strong,nonatomic) NSString *strPhone;
@property (strong,nonatomic) UITableView *tableViewList;
@property  (strong,nonatomic) NSMutableArray *arraylist;
@property (nonatomic) NSInteger pageindexcount;
@end
