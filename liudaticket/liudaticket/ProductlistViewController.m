//
//  ProductlistViewController.m
//  liudaticket
//
//  Created by Eric on 13-12-5.
//  Copyright (c) 2013年 mmc. All rights reserved.
//

#import "ProductlistViewController.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import "MKNetworkKit.h"
#import "SBJson.h"
#import "YMGlobal.h"
#import "AppDelegate.h"
#import "ShanDongCityInfoDetailViewController.h"
@interface ProductlistViewController ()<MJRefreshBaseViewDelegate>
{
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
}


@end

@implementation ProductlistViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    //NSLog(@"viewwillapper");
    //[self.tableview_productlist reloadData];
}

- (void)viewDidLoad
{
    self.pageindexCount=1;
    [super viewDidLoad];
    [self.view addSubview:self.tableview_productlist];
    //[self setExtraCellLineHidden:self.tableview_productlist];
    __unsafe_unretained ProductlistViewController *vc = self;
    
    _header = [[MJRefreshHeaderView alloc] init];
    _header.delegate = self;
    _header.scrollView = self.tableview_productlist;
    _footer = [[MJRefreshFooterView alloc] init];
    _footer.delegate = self;
    _footer.scrollView = self.tableview_productlist;
    
    //底部下拉刷新
    _footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
       
            [vc performSelector:@selector(reloadFooter) withObject:nil afterDelay:1];
        
       
    };
    //顶部刷新
    _header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        [vc performSelector:@selector(reloadHeader) withObject:nil afterDelay:1];
    };
    [self reloadHeader];
    [self.tableview_productlist reloadData];
    NSLog(@"viewdidload方法");
}
-(void)reloadFooter
{
    if (self.pageindexCount==1 && self.arrayList.count==0)
    {
        self.pageindexCount=1;
    }else
    {
        self.pageindexCount++;
    }
    NSLog(@"pageindexcount是%i",self.pageindexCount);
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    hud.removeFromSuperViewOnHide=YES;
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:@"product_search" forKey:@"action"];
    [params setObject:@"的" forKey:@"title"];
    [params setObject:[NSString stringWithFormat:@"%i",self.pageindexCount] forKey:@"pageindex"];
    [params setObject:@"105" forKey:@"pageCount"];
    
    MKNetworkOperation *op = [YMGlobal getOperation:params];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
            SBJsonParser *parser = [[SBJsonParser alloc]init];
            NSMutableDictionary *obj = [parser objectWithData:[completedOperation responseData]];
            
            if([[obj objectForKey:@"result"]isEqualToString:@"200"])
            {
                self.arrayAgain=[obj objectForKey:@"info"];
                
                if (self.arrayAgain.count==0)
                {
                    self.pageindexCount--;
                }
                else
                {
                    //NSLog(@"arrayagain 个数%i",[arrayAgain count]);
                    for (int j=0; j<[self.arrayAgain count]; j++)
                    {
                        [self.arrayList addObject:[self.arrayAgain objectAtIndex:j]];
                    }
                    NSLog(@"数组的成员个数是%i",self.arrayList.count);
                    [self.tableview_productlist reloadData];
                }
                
            }else
            {
                self.pageindexCount--;
            }
            [hud hide:YES];
            [_footer endRefreshing];
         
       
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        //NSLog(@"错误是%@",error);
        self.pageindexCount--;
        [_footer endRefreshing];
        [hud hide:YES];
    }];
    [ApplicationDelegate.engine enqueueOperation:op];
    
    
}


-(void)reloadHeader
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    hud.removeFromSuperViewOnHide=YES;
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:@"product_search" forKey:@"action"];
    //    [params setObject:self.strKeyword forKey:@"title"];
    [params setObject:self.strKeyword forKey:@"title"];
    [params setObject:@"1" forKey:@"pageindex"];
    [params setObject:@"5" forKey:@"pageCount"];
    MKNetworkOperation *op = [YMGlobal getOperation:params];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        SBJsonParser *parser = [[SBJsonParser alloc]init];
        NSMutableDictionary *obj = [parser objectWithData:[completedOperation responseData]];
        
        if([[obj objectForKey:@"result"]isEqualToString:@"200"])
        {
            self.arrayList=[obj objectForKey:@"info"];
            [self.tableview_productlist reloadData];
        }
        NSLog(@"ddds");
        self.pageindexCount=1;
        [hud hide:YES];
        [_header endRefreshing];
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"错误是%@",error);
        [_header endRefreshing];
        [hud hide:YES];
    }];
    [ApplicationDelegate.engine enqueueOperation:op];
    
}


//返回指定Row的行高
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
//返回指定section的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrayList count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShanDongCityInfoDetailViewController *sdCityInfoDetailVC= [ShanDongCityInfoDetailViewController new];
//    
//    sdCityInfoDetailVC.cityInfoId=[[self.arrayList objectAtIndex:indexPath.row] objectForKey:@"id"];
//    sdCityInfoDetailVC.cityinfoName=[[self.arrayList objectAtIndex:indexPath.row] objectForKey:@"name"];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    //backItem.tintColor = [UIColor colorWithRed:167/255.0 green:216/255.0 blue:106/255.0 alpha:1.0];
    backItem.title=@"返回";
    self.navigationItem.backBarButtonItem = backItem;
    
    

    
    
    
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:@"product_detail" forKey:@"action"];
    //    [params setObject:self.strKeyword forKey:@"title"];
    [params setObject:[[self.arrayList objectAtIndex:indexPath.row] objectForKey:@"id"] forKey:@"pro_id"];

    MKNetworkOperation *op = [YMGlobal getOperation:params];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        SBJsonParser *parser = [[SBJsonParser alloc]init];
        
        NSDictionary *returnObj = [parser objectWithString:[completedOperation responseString]];
        //NSLog([[NSString alloc] initWithData:[returnObj objectForKey:@"result"] encoding:NSASCIIStringEncoding]);
        //NSLog(@"%@",[returnObj objectForKey:@"result"]);
        //NSLog(@"%@",returnObj);
        if([[returnObj objectForKey:@"result"]isEqualToString:@"200"])
        {
            sdCityInfoDetailVC.setDetailDic=[returnObj objectForKey:@"info"];
        }
        [self.navigationController  pushViewController:sdCityInfoDetailVC animated:YES];
        
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"error%@",error);
    }];
 [ApplicationDelegate.engine enqueueOperation:op];

}
//生成cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    //景点图片
    UIImageView *image_proimg=[[UIImageView alloc] initWithFrame:CGRectMake(5.f, 5.f, 158.f, 90.f)];
    image_proimg.layer.borderWidth=1;
    image_proimg.layer.borderColor=[UIColor clearColor].CGColor;
    [YMGlobal loadImage:[[self.arrayList objectAtIndex:indexPath.row] objectForKey:@"url"] andImageView:image_proimg];
    [cell addSubview:image_proimg];
    
    //名称
    UILabel *label_proname=[[UILabel alloc] initWithFrame:CGRectMake(170.0f, 5.f, 20, 10.f)];
    label_proname.numberOfLines=0;
    label_proname.textAlignment=NSTextAlignmentLeft;
    CGSize sizecue = CGSizeMake(150,2000);
    label_proname.font=[UIFont systemFontOfSize:14.0f];
    label_proname.adjustsFontSizeToFitWidth = YES;
    NSString *strProname=[[self.arrayList objectAtIndex:indexPath.row] objectForKey:@"name"];
    CGSize labelsizecue = [strProname sizeWithFont:label_proname.font constrainedToSize:sizecue lineBreakMode:NSLineBreakByTruncatingHead];
    label_proname.text=strProname;
    //label_proname.textColor//=[UIColor clearColor];
    label_proname.frame = CGRectMake(170, 5, labelsizecue.width, labelsizecue.height);
    [cell addSubview:label_proname];
    //label_proname
    return cell;
}



















-(void)showMessage:(NSString *)strMessage hudModel:(MBProgressHUD *)hud{
    
    hud.labelText = strMessage;
    hud.labelFont=[UIFont systemFontOfSize:12.0];
    hud.mode = MBProgressHUDModeText;
    hud.removeFromSuperViewOnHide=YES;
    hud.margin = 10.f;
    hud.yOffset = 150.f;
    [hud hide:YES afterDelay:2];
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"内存警告");
}




@end
