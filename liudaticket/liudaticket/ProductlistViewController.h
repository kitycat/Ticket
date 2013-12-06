//
//  ProductlistViewController.h
//  liudaticket
//
//  Created by Eric on 13-12-5.
//  Copyright (c) 2013年 mmc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductlistViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
//搜索返回
- (IBAction)backview:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *tableview_productlist;
@property (strong,nonatomic) NSMutableArray *arrayList;
@property (strong,nonatomic) NSMutableArray *arrayAgain;
@property (nonatomic) NSUInteger pageindexCount;
@property (nonatomic,strong) NSString *strKeyword;
@end
