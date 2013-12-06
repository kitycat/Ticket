//
//  MyTicKetViewController.m
//  liudaticket
//
//  Created by only on 13-11-27.
//  Copyright (c) 2013年 mmc. All rights reserved.
//

#import "MyTicKetViewController.h"

@interface MyTicKetViewController ()

@end

@implementation MyTicKetViewController
#pragma mark 构造方法
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"我的淘票";
        [self.tabBarItem setImage:[UIImage imageNamed:@"tabbar_my_unselected"]];
        if([[[UIDevice currentDevice] systemVersion] floatValue] >=5.0)
        {
            [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabbar_my"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar_my_unselected"]];
            
           
        }
    }
    return self;
}
#pragma mark 视图加载
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark 内存警告
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
