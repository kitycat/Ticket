//
//  AppDelegate.m
//  liudaticket
//
//  Created by EricWei on 13-11-27.
//  Copyright (c) 2013年 mmc. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"
#import "MyTicKetViewController.h"
#import "ShanDongViewController.h"
#import "AroundViewController.h"
#import "MoreViewController.h"
#import "MKNetworkEngine.h"
#import "OrderSearchViewController.h"
#import "ProductlistViewController.h"

@implementation AppDelegate
@synthesize tabBarController;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
    // Override point for customization after application launch.
    UINavigationController *indexNavi = [[UINavigationController alloc]initWithRootViewController:[[ViewController alloc]initWithNibName:@"ViewController" bundle:nil]];
    
    UINavigationController *MyTicKetNavi = [[UINavigationController alloc]initWithRootViewController:[[OrderSearchViewController  alloc]initWithNibName:@"OrderSearchViewController" bundle:nil]];
    
    //山东
    UIViewController *shanDongView=  [[ShanDongViewController alloc] init];
    UINavigationController *ShanDongNavi=[[UINavigationController alloc] initWithRootViewController:shanDongView];
    //周边 
    UIViewController *aroundView=  [[AroundViewController alloc] init];
    UINavigationController *aroundNavi=[[UINavigationController alloc] initWithRootViewController:aroundView];
    //更多
    UIViewController *moreView=  [[MoreViewController alloc] init];
    UINavigationController *moreNavi=[[UINavigationController alloc] initWithRootViewController:moreView];
    
    self.tabBarController = [[UITabBarController alloc]init];
    
    self.tabBarController.delegate = self;
    self.tabBarController.viewControllers = @[indexNavi,ShanDongNavi,MyTicKetNavi,aroundNavi,moreNavi];
    self.window.rootViewController = self.tabBarController;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushVC:) name:@"pushKeyVC" object:nil];
    
    
   
    
    [self.window makeKeyAndVisible];
    return YES;
}
//@selector
- (void)pushVC:(NSNotification *)note
{
    UINavigationController *selectNav = (UINavigationController *)self.tabBarController.selectedViewController;
    ProductlistViewController *keyGoodsVC = [[ProductlistViewController alloc]init];
    
    UILabel *itemTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 170, 44)];
    itemTitle.textAlignment = NSTextAlignmentCenter;
    itemTitle.text = [NSString stringWithFormat:@"关键字\"%@\"的产品列表", [[note userInfo] objectForKey:@"keywords"]];
    keyGoodsVC.strKeyword=[[note userInfo] objectForKey:@"keywords"];
    itemTitle.font = [UIFont systemFontOfSize:15.0];
    itemTitle.backgroundColor = [UIColor clearColor];
    itemTitle.textColor = [UIColor whiteColor];
    keyGoodsVC.navigationItem.titleView = itemTitle;
    [selectNav pushViewController:keyGoodsVC animated:YES];
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (MKNetworkEngine *)engine
{
//    if(_engine == nil)
//    {
        _engine = [[MKNetworkEngine alloc]initWithHostName:API_HOSTNAME customHeaderFields:nil];
        [_engine useCache];
    //}
    return _engine;
}
@end
