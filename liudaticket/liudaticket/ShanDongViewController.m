//
//  ShanDongViewController.m
//  liudaticket
//
//  Created by EricWei on 13-11-28.
//  Copyright (c) 2013年 mmc. All rights reserved.
//

#import "ShanDongViewController.h"

#import "CityTableViewIndexBar.h"
#import "ShanDongCityInfoViewController.h"
#import "MKNetworkKit.h"
#import "SBJson.h"
#import "HttpService.h"
@interface ShanDongViewController ()<
UITableViewDataSource,
UITableViewDelegate,
CityTableViewIndexBarDelegate>{
    __weak IBOutlet CityTableViewIndexBar    *indexBar;
    __weak IBOutlet UITableView             *plainTableView;
    
    NSArray *sections;
    NSArray *rows;
}


@end

@implementation ShanDongViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"山东",@"山东");
        [self.tabBarItem setImage:[UIImage imageNamed:@"tabbar_cart_unselected"]];
        if([[[UIDevice currentDevice] systemVersion] floatValue] >=5.0)
        {
            [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabbar_cart"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar_cart_unselected"]];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    sections = @[@"B", @"D", @"H", @"J", @"L", @"Q", @"R", @"T", @"W", @"Y", @"Z"];
    
    rows = @[@[@"滨州"],
             @[@"东营",@"德州"],
             @[@"菏泽"],
             @[@"济南", @"济宁"],
             @[@"莱芜", @"临沂", @"聊城"],
             @[@"青岛"],
             @[@"日照"],
             @[@"泰安"],
             @[@"威海", @"潍坊"],
             @[@"烟台"],
             @[@"枣庄", @"淄博"]];
    
    indexBar.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    [indexBar setIndexes:sections]; // to always have exact number of sections in table and indexBar
    return [sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [rows[section] count];
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return sections[section];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"TableViewCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    [cell.textLabel setText:rows[indexPath.section][indexPath.row]];
    [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica" size:16]];
    return cell;
}

#pragma mark - AIMTableViewIndexBarDelegate

- (void)tableViewIndexBar:(CityTableViewIndexBar *)indexBar didSelectSectionAtIndex:(NSInteger)index{
    if ([plainTableView numberOfSections] > index && index > -1){   // for safety, should always be YES
        [plainTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]
                              atScrollPosition:UITableViewScrollPositionTop
                                      animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ShanDongCityInfoViewController *cityVC= [[ShanDongCityInfoViewController alloc] init];
    cityVC.cityName=[[rows objectAtIndex:indexPath.section] objectAtIndex:[indexPath row]];
    if([cityVC indexCount]==nil)
    {
        cityVC.indexCount=@"1";
    }else
    {
        cityVC.indexCount=[NSString stringWithFormat:@"%i",[cityVC.indexCount intValue] +1];
    }
    NSLog(@"计数器是%@",cityVC.indexCount);
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    //backItem.tintColor = [UIColor colorWithRed:167/255.0 green:216/255.0 blue:106/255.0 alpha:1.0];
    backItem.title=@"返回";
    self.navigationItem.backBarButtonItem = backItem;
    
    
    MKNetworkEngine *engine=[[[HttpService alloc] init] engine];
    [engine useCache];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1",@"ver",
                                   @"json",@"format",
                                   @"product_cityName",@"action",
                                  [[rows objectAtIndex:indexPath.section] objectAtIndex:[indexPath row]],@"cityName",
                                   cityVC.indexCount,@"pageIndex",
                                   @"2",@"pageCount",
                                   nil];
    
    
  
    
    MKNetworkOperation *op = [engine operationWithPath:@"api/api.ashx" params:params  httpMethod:@"GET" ssl:NO];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        SBJsonParser *parser = [[SBJsonParser alloc]init];
        
        NSDictionary *returnObj = [parser objectWithString:[completedOperation responseString]];
       //NSLog([[NSString alloc] initWithData:[returnObj objectForKey:@"result"] encoding:NSASCIIStringEncoding]);
       //NSLog(@"%@",[returnObj objectForKey:@"result"]);
        //NSLog(@"%@",returnObj);
        if([[returnObj objectForKey:@"result"]isEqualToString:@"200"])
        {
                    
            cityVC.secInfoArray=[returnObj objectForKey:@"info"];
            cityVC.indexCount=@"1";
              
        }
        [self.navigationController  pushViewController:cityVC animated:YES];  

        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"error%@",error);
    }];
    [engine enqueueOperation:op];
    
    
    
    
    
    
    
}

@end
