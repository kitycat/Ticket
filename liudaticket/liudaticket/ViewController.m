//
//  ViewController.m
//  liudaticket
//
//  Created by EricWei on 13-11-27.
//  Copyright (c) 2013年 mmc. All rights reserved.
//

#import "ViewController.h"
#import "SearchViewController.h"
#import "MKNetworkKit.h"
#import "SBJson.h"
#import "InfoViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MJRefresh.h"
#import "HttpService.h"
#import "EGOImageView.h"
#import "OrderListInfoController.h"
#import "ShanDongCityInfoDetailViewController.h"
@interface ViewController ()<MJRefreshBaseViewDelegate>
{
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
}

@end

@implementation ViewController
@synthesize tableView = _tableView;
@synthesize RMarray;
@synthesize RZarray;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"溜达淘票",@"溜达淘票");
        [self.tabBarItem setImage:[UIImage imageNamed:@"tabbar_index_unselected.png"]];
        pageCount = 1;
    }
    //搜索按钮
    UIBarButtonItem *searchBar = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(search:)];
    self.navigationItem.rightBarButtonItem = searchBar;
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self reloadHeader];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    __unsafe_unretained ViewController *vc = self;
	// Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.tableView];
    //请求热卖景点
    _header = [[MJRefreshHeaderView alloc] init];
    _header.delegate = self;
    _header.scrollView = self.tableView;
    _footer = [[MJRefreshFooterView alloc] init];
    _footer.delegate = self;
    _footer.scrollView = self.tableView;
    _footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 2秒后刷新表格
        [vc performSelector:@selector(reloadFooter) withObject:nil afterDelay:1];
    };
    
    _header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 2秒后刷新表格
        [vc performSelector:@selector(reloadHeader) withObject:nil afterDelay:1];
    };
}

//创建tableview
- (UITableView *)tableView
{
    if(_tableView == nil)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-180)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.RMarray.count + self.RZarray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellString = @"cellstring";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellString];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellString];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//右箭头
    }
    if(indexPath.row == 0)
    {
        if(self.RMarray != nil)
        {
            //加载热卖区
            NSString *RMimageUrl = [[self.RMarray objectAtIndex:indexPath.row]objectForKey:@"url"];
            EGOImageView *RMimageView = [[EGOImageView alloc]initWithFrame:CGRectMake(5, 5, 310, 140)];
            RMimageView.imageURL = [NSURL URLWithString:RMimageUrl];
            [cell.contentView addSubview:RMimageView];
            //热卖图标
            EGOImageView *RMView = [[EGOImageView alloc]initWithFrame:CGRectMake(1, 1, 50, 50)];
            [RMView setImage:[UIImage imageNamed:@"rm.png"]];
            [RMimageView addSubview:RMView];
            //景点名称
            UILabel *RMlabel = [[UILabel alloc]initWithFrame:CGRectMake(0,120 , 309, 20)];
            RMlabel.text = [[RMarray objectAtIndex:indexPath.row]objectForKey:@"flag"];
            [RMlabel setBackgroundColor:[UIColor grayColor]];
            [RMlabel setAlpha:0.6];
            RMlabel.highlighted = YES;
            RMlabel.highlightedTextColor = [UIColor whiteColor];
            [RMimageView addSubview:RMlabel];
            
        }
    }else{
        if(self.RZarray.count >0)
        {
            //加载认证区
            NSString *RZimageUrl = [[self.RZarray objectAtIndex:(indexPath.row-1)]objectForKey:@"url"];
            EGOImageView *RZimageView = [[EGOImageView alloc]initWithFrame:CGRectMake(5, 5, 310, 140)];
            RZimageView.imageURL = [NSURL URLWithString:RZimageUrl];
            [cell.contentView addSubview:RZimageView];
            //认证图标
            EGOImageView *RZView = [[EGOImageView alloc]initWithFrame:CGRectMake(1, 1, 50, 50)];
            [RZView setImage:[UIImage imageNamed:@"rz.png"]];
            [RZimageView addSubview:RZView];
            //景点名称
            UILabel *RZlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 120, 309, 20)];
            RZlabel.text = [[RZarray objectAtIndex:(indexPath.row-1)]objectForKey:@"flag"];
            [RZlabel setBackgroundColor:[UIColor grayColor]];
            [RZlabel setAlpha:0.6];
            RZlabel.highlighted = YES;
            RZlabel.highlightedTextColor = [UIColor whiteColor];
            [RZView addSubview:RZlabel];
        }
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    ShanDongCityInfoDetailViewController *sdCityInfoDetailVC= [ShanDongCityInfoDetailViewController new];
    
   
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title=@"返回";
    self.navigationItem.backBarButtonItem = backItem;
    
    //获取景点ID
    NSString *proid=nil;
    if (indexPath.row==0)
        proid=[[self.RMarray objectAtIndex:0] objectForKey:@"id"] ;
    else
        proid=[[self.RZarray objectAtIndex:indexPath.row-1] objectForKey:@"id"];
    
    
    MKNetworkEngine *engine=[[[HttpService alloc] init] engine];
    [engine useCache];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1",@"ver",
                                   @"json",@"format",
                                   @"product_detail",@"action",
                                   proid,@"pro_id",
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
    if([self.view window] == nil)
    {
        self.view = nil;
        _RZarray = nil;
        _RMarray = nil;
    }
}



- (void)search:(id)sender
{
    SearchViewController *searchController = [[SearchViewController alloc]init];
    [self presentViewController:searchController animated:NO completion:nil];
}
#pragma mark 下拉加载
- (void)reloadFooter
{
    pageCount++;
    NSMutableDictionary *RZparams = [[NSMutableDictionary alloc]init];
    [RZparams setObject:@"1" forKey:@"ver"];
    [RZparams setObject:@"json" forKey:@"format"];
    [RZparams setObject: @"product_list" forKey:@"action"];
    [RZparams setObject:@"5" forKey:@"pageCount"];
    [RZparams setObject:[NSString stringWithFormat:@"%i",pageCount] forKey:@"PageIndex"];
    MKNetworkEngine *RZengine = [[MKNetworkEngine alloc]initWithHostName:@"42.51.8.205:8099/"];
    MKNetworkOperation *RZop = [RZengine operationWithPath:@"api/api.ashx" params:RZparams httpMethod:@"GET" ssl:NO];
    [RZop addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        SBJsonParser *RZparser = [[SBJsonParser alloc]init];
        NSMutableDictionary *RZobj = [RZparser objectWithData:[completedOperation responseData]];
        if([[RZobj objectForKey:@"result"]isEqualToString:@"200"])
        {
            NSMutableArray *againArray=[RZobj objectForKey:@"info"];
            if ([againArray count]>0) {
                for (int i=0; i<[againArray count]; i++)
                {
                    [self.RZarray addObject:[againArray objectAtIndex:i]];
                }
                [self.tableView reloadData];
                
            }
        }else
        {
            pageCount--;
        }
        [_footer endRefreshing];
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"%@",error);
        [_footer endRefreshing];
    }];
    [RZengine enqueueOperation:RZop];
    
}

#pragma mark 上拉刷新
- (void)reloadHeader
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:@"1" forKey:@"ver"];
    [params setObject:@"json" forKey:@"format"];
    [params setObject: @"product_hot" forKey:@"action"];
    [params setObject:@"1" forKey:@"pageCount"];
    MKNetworkEngine *engine = [[MKNetworkEngine alloc]initWithHostName:@"42.51.8.205:8099/"];
    MKNetworkOperation *op = [engine operationWithPath:@"api/api.ashx" params:params httpMethod:@"GET" ssl:NO];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        SBJsonParser *parser = [[SBJsonParser alloc]init];
        NSMutableDictionary *obj = [parser objectWithData:[completedOperation responseData]];
        if([[obj objectForKey:@"result"]isEqualToString:@"200"])
        {
            self.RMarray = [obj objectForKey:@"info"];
            [self.tableView reloadData];
            [_footer endRefreshing];
        }
        pageCount = 1;
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"%@",error);
    }];
    [engine enqueueOperation:op];
    
    //请求认证区
    NSMutableDictionary *RZparams = [[NSMutableDictionary alloc]init];
    [RZparams setObject:@"1" forKey:@"ver"];
    [RZparams setObject:@"json" forKey:@"format"];
    [RZparams setObject: @"product_list" forKey:@"action"];
    [RZparams setObject:@"5" forKey:@"pageCount"];
    [RZparams setObject:@"1" forKey:@"PageIndex"];
    MKNetworkEngine *RZengine = [[MKNetworkEngine alloc]initWithHostName:@"42.51.8.205:8099/"];
    MKNetworkOperation *RZop = [RZengine operationWithPath:@"api/api.ashx" params:RZparams httpMethod:@"GET" ssl:NO];
    [RZop addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        SBJsonParser *RZparser = [[SBJsonParser alloc]init];
        NSMutableDictionary *RZobj = [RZparser objectWithData:[completedOperation responseData]];
        if([[RZobj objectForKey:@"result"]isEqualToString:@"200"])
        {
            self.RZarray = [RZobj objectForKey:@"info"];
            [self.tableView reloadData];
            [_header endRefreshing];
        }
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"%@",error);
    }];
    [RZengine enqueueOperation:RZop];
    
}
@end
