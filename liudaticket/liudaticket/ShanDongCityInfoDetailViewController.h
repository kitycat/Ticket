//
//  ShanDongCityInfoDetailViewController.h
//  liudaticket
//
//  Created by Eric on 13-11-30.
//  Copyright (c) 2013年 mmc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBPageFlowView.h"
#import "ProductModel.h"
@interface ShanDongCityInfoDetailViewController : UIViewController<SBPageFlowViewDataSource,SBPageFlowViewDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (strong,nonatomic)  NSMutableDictionary *setDetailDic;
//图片切换视图
@property (strong ,nonatomic)SBPageFlowView *flowView;
@property(strong,nonatomic) UIPageControl *pageControl;
//信息显示tableview视图
@property (strong ,nonatomic)UITableView *propertyTableView;
@property (strong ,nonatomic)UITableView *priceTableView;
@property (strong, nonatomic) UIScrollView *scrollview;
@property (strong,nonatomic)UIView *floatview;
@property (strong ,nonatomic)ProductModel *productModel;

@end
