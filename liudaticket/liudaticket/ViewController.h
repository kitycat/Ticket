//
//  ViewController.h
//  liudaticket
//
//  Created by EricWei on 13-11-27.
//  Copyright (c) 2013年 mmc. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray * _RMarray;
    NSMutableArray * _RZarray;
    NSInteger pageCount;
}
@property(strong,nonatomic) UITableView *tableView;
@property(strong,nonatomic)NSMutableArray *RMarray;
@property(strong,nonatomic)NSMutableArray *RZarray;
@end
