//
//  AppDelegate.h
//  liudaticket
//
//  Created by EricWei on 13-11-27.
//  Copyright (c) 2013年 mmc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "MKNetworkEngine.h"
#define ApplicationDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)
@class ViewController;



@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;
@property (strong, nonatomic) MKNetworkEngine *engine;
//声明tabBarController
@property(strong,nonatomic)UITabBarController *tabBarController;

@end

