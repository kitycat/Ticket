//
//  ShanDongCityInfoViewController.m
//  liudaticket
//
//  Created by Eric on 13-11-29.
//  Copyright (c) 2013年 mmc. All rights reserved.
//

#import "ShanDongCityInfoViewController.h"
#import "MJRefresh.h"
#import "ShanDongCityInfoViewController.h"
#import "MKNetworkKit.h"
#import "SBJson.h"
#import "HttpService.h"
#import "ShanDongCityInfoDetailViewController.h"
#import "MBProgressHUD.h"
// 2.刷新代理协议（达到刷新状态就会调用）
@interface ShanDongCityInfoViewController () <MJRefreshBaseViewDelegate>{
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;}
@end

@implementation ShanDongCityInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setExtraCellLineHidden:self.cityview];
    __unsafe_unretained ShanDongCityInfoViewController *vc = self;
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = self.cityName;
    _header = [[MJRefreshHeaderView alloc] init];
    _header.delegate = self;
    _header.scrollView = self.cityview;
    _footer = [[MJRefreshFooterView alloc] init];
    _footer.delegate = self;
    _footer.scrollView = self.cityview;
    
    
    
    
    _footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 2秒后刷新表格
        [vc performSelector:@selector(reloadFooter) withObject:nil afterDelay:1];
    };
    
    
    _header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        [vc performSelector:@selector(reloadHeader) withObject:nil afterDelay:1];
    };
}
#pragma mark - 刷新的代理方法---进入下拉刷新\上拉加载更多都有可能调用这个方法
//- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
//{
//    if (refreshView == _header) { // 下拉刷新d
//        // 增加9个假数据
//        for (int i = 0; i<7; i++) {
//            //[_deals insertObject:[self randomDeal] atIndex:0];
//        }
//
//        // 2秒后刷新表格
//        [self performSelector:@selector(reloadHeader) withObject:nil afterDelay:2];
//    }
//}
#pragma mark 刷新数据
- (void)reloadFooter
{
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:NO];
    MKNetworkEngine *engine=[[[HttpService alloc] init] engine];
    NSLog(@"ksdjkfsjkdfjksdfjksjk^%@",[NSString stringWithFormat:@"%i",[self.indexCount intValue] +1]);
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1",@"ver",
                                   @"json",@"format",
                                   @"product_cityName",@"action",
                                   self.cityName,@"cityName",
                                   [NSString stringWithFormat:@"%i",[self.indexCount intValue] +1],@"pageIndex",
                                   @"2",@"pageCount",  nil];
    MKNetworkOperation *op = [engine operationWithPath:@"api/api.ashx" params:params httpMethod:@"GET" ssl:NO];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        SBJsonParser *parser = [[SBJsonParser alloc]init];
        NSMutableDictionary *returnObj = [parser objectWithString:[completedOperation responseString]];
        NSLog(@"状态%@",[returnObj objectForKey:@"result"]);
        if([[returnObj objectForKey:@"result"]isEqualToString:@"200"])
        {
            NSMutableArray *againArray=[returnObj objectForKey:@"info"];
            if ([againArray count]>0) {
                for (int i=0; i<[againArray count]; i++)
                {
                    [self.secInfoArray addObject:[againArray objectAtIndex:i]];
                }
                NSLog(@"真正的计数器是 : %@", [NSString stringWithFormat:@"%i",[self.indexCount intValue] +1]);
                self.indexCount=[NSString stringWithFormat:@"%i",[self.indexCount intValue] +1];
            }
            
            
        }
        [_footer endRefreshing];
        [self.cityview reloadData];
        [hud hide:YES];
    }
                errorHandler:^(MKNetworkOperation *completedOperation, NSError *error)
     {
         [hud hide:YES];
         NSLog(@"MKNetwork request error : %@", [error localizedDescription]);
     }
     ];
    [engine enqueueOperation:op];
    
    
    // 结束刷新状态
    //[_header endRefreshing];
    
}
- (void)reloadHeader
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:NO];
    MKNetworkEngine *engine = [[MKNetworkEngine alloc]initWithHostName:@"42.51.8.205:8099/" customHeaderFields:nil];
    [engine useCache];
    
    self.indexCount=@"1";
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1",@"ver",
                                   @"json",@"format",  @"product_cityName",@"action",  self.cityName,@"cityName",
                                   
                                   @"1",@"pageIndex",  @"2",@"pageCount",  nil];
    MKNetworkOperation *op = [engine operationWithPath:@"api/api.ashx" params:params httpMethod:@"GET" ssl:NO];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        SBJsonParser *parser = [[SBJsonParser alloc]init];  NSDictionary *returnObj = [parser objectWithString:[completedOperation responseString]];
        
        if([[returnObj objectForKey:@"result"]isEqualToString:@"200"])
        {
            self.secInfoArray=[returnObj objectForKey:@"info"];
            
            
        }
        NSLog(@"真正的计数器是 : %@", self.indexCount);
        
        [_header endRefreshing];
        [self.cityview reloadData];
        [hud hide:YES];
    }
                errorHandler:^(MKNetworkOperation *completedOperation, NSError *error)
     {
         [hud hide:YES];
         NSLog(@"error%@",error);
     }];
    [engine enqueueOperation:op];
    
    
    // 结束刷新状态
    [_header endRefreshing];
    [self.cityview reloadData];
    //[_footer endRefreshing];
}

-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.secInfoArray count]==0) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }else{
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    return [self.secInfoArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    cell.textLabel.text = [[self.secInfoArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.textLabel.font = [UIFont systemFontOfSize:17.0];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    //tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShanDongCityInfoDetailViewController *sdCityInfoDetailVC= [ShanDongCityInfoDetailViewController new];
    
    //sdCityInfoDetailVC.cityInfoId=[[self.secInfoArray objectAtIndex:indexPath.row] objectForKey:@"id"];
   // sdCityInfoDetailVC.cityinfoName=[[self.secInfoArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    //backItem.tintColor = [UIColor colorWithRed:167/255.0 green:216/255.0 blue:106/255.0 alpha:1.0];
    backItem.title=@"返回";
    self.navigationItem.backBarButtonItem = backItem;
    
    
    MKNetworkEngine *engine=[[[HttpService alloc] init] engine];
    [engine useCache];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1",@"ver",
                                   @"json",@"format",
                                   @"product_detail",@"action",
                                   [[self.secInfoArray objectAtIndex:indexPath.row] objectForKey:@"id"],@"pro_id",
                                   nil];
    
    
    MKNetworkOperation *op = [engine operationWithPath:@"api/api.ashx" params:params  httpMethod:@"GET" ssl:NO];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        SBJsonParser *parser = [[SBJsonParser alloc]init];
        
        NSDictionary *returnObj = [parser objectWithString:[completedOperation responseString]];
        if([[returnObj objectForKey:@"result"]isEqualToString:@"200"])
        {
            sdCityInfoDetailVC.setDetailDic=[returnObj objectForKey:@"info"];
        }
        [self.navigationController  pushViewController:sdCityInfoDetailVC animated:YES];
        
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"error%@",error);
    }];
    [engine enqueueOperation:op];
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
