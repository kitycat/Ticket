//
//  SearchOrderListViewController.m
//  liudaticket
//
//  Created by Eric on 13-12-4.
//  Copyright (c) 2013年 mmc. All rights reserved.
//

#import "SearchOrderListViewController.h"
#import "MJRefresh.h"
#import "SBJson.h"
#import "MKNetworkEngine.h"
#import "MBProgressHUD.h"
#import "YMGlobal.h"
#import "AppDelegate.h"
#import "OrderListInfoController.h"
@interface SearchOrderListViewController ()<MJRefreshBaseViewDelegate>
{
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
}
@end

@implementation SearchOrderListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadHeader];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    __unsafe_unretained SearchOrderListViewController *vc = self;
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"查询结果";
    //隐藏多余的cell
    [self setExtraCellLineHidden:self.tableViewList];
    [self.view addSubview:self.tableViewList];
    _header = [[MJRefreshHeaderView alloc] init];
    _header.delegate = self;
    _header.scrollView = self.tableViewList;
    _footer = [[MJRefreshFooterView alloc] init];
    _footer.delegate = self;
    _footer.scrollView = self.tableViewList;
    
    
    
    
    //    _footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
    //        // 2秒后刷新表格
    //        [vc performSelector:@selector(reloadFooter) withObject:nil afterDelay:1];
    //    };
    
    _header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        
        // 2秒后刷新表格
        [vc performSelector:@selector(reloadHeader) withObject:nil afterDelay:1];
    };
    
}
-(void)reloadHeader
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:NO];
    hud.removeFromSuperViewOnHide=YES;
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:@"order_list" forKey:@"action"];
    [params setObject:self.strPerson forKey:@"username"];
    [params setObject:self.strPhone forKey:@"phone"];
    MKNetworkOperation *op = [YMGlobal getOperation:params];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        SBJsonParser *parser = [[SBJsonParser alloc]init];
        NSMutableDictionary *obj = [parser objectWithData:[completedOperation responseData]];
        
        if([[obj objectForKey:@"result"]isEqualToString:@"200"])
        {
            self.arraylist=[obj objectForKey:@"info"];
            if ([self.arraylist count]>0)
            {
                [self.tableViewList reloadData];
            }
            
        }
        [_header endRefreshing];
        [hud hide:YES];
        
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [_header endRefreshing];
        [hud hide:YES];
    }];
    [ApplicationDelegate.engine enqueueOperation:op];
    
}


-(UITableView *)tableViewList
{
    if (_tableViewList == nil) {
        _tableViewList = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableViewList.delegate = self;
        _tableViewList.dataSource = self;
    }
    return _tableViewList;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.arraylist count]==0) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }else{
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }

    return [self.arraylist count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    @synthesize NameLabel;        //商品名称
//    @synthesize OrderTypeLabel;   //订单类型
//    @synthesize OrderStateLabel;  //订单状态
//    @synthesize VolumeLabel;      //消费卷码
//    @synthesize ExpiredTimeLabel; //过期时间
//    @synthesize OrderNumberLabel; //订单编号
//    @synthesize OrderTime;        //下单时间
//    @synthesize Money;            //支付金额

    OrderListInfoController *vc=[OrderListInfoController new];
    vc.Dic_OrderInfo=[self.arraylist objectAtIndex:indexPath.row];
    NSLog(@"字典是%@",[self.arraylist objectAtIndex:indexPath.row]);
    [self.navigationController pushViewController:vc animated:YES];


}
-(NSString *)GetPaystatus:(NSString *)strPaytype
{
    if ([strPaytype isEqualToString:@"true"]) {
        return @"已支付";
    }else{
        return @"未支付";
    }
}
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    if ([self.arraylist count]>0) {
        cell.textLabel.text=[[self.arraylist objectAtIndex:indexPath.row] objectForKey:@"flag"];
        cell.textLabel.font=[UIFont fontWithName:@"Helvetica" size:13.0];
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(260, 10, 60, 20)];
        label.text=[self GetPaystatus:[NSString stringWithFormat:@"%@",[[self.arraylist objectAtIndex:indexPath.row] objectForKey:@"pay"]]];
        label.font=[UIFont systemFontOfSize:12.0f];
        label.textColor=[UIColor redColor];
        label.backgroundColor=[UIColor clearColor];
        [cell addSubview:label];
    }
    return cell;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
