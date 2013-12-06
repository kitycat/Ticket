//
//  ShanDongCityInfoDetailViewController.m
//  liudaticket
//
//  Created by Eric on 13-11-30.
//  Copyright (c) 2013年 mmc. All rights reserved.
//

#import "ShanDongCityInfoDetailViewController.h"
#import "ProductModel.h"
#import <QuartzCore/QuartzCore.h>
#import "YMGlobal.h"
#import "SBJson.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "UILabelStrikeThrough.h"
#import "BuyViewController.h"
@interface ShanDongCityInfoDetailViewController ()

@end

@implementation ShanDongCityInfoDetailViewController
@synthesize propertyTableView = _propertyTableView;
@synthesize scrollview = _scrollview;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"景点详情";
        // NSNotification
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //取出图片
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:NO];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:@"product_img" forKey:@"action"];
    [params setObject:_productModel.pro_id forKey:@"pro_id"];
    MKNetworkOperation *op = [YMGlobal getOperation:params];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        SBJsonParser *parser = [[SBJsonParser alloc]init];
        NSMutableDictionary *obj = [parser objectWithData:[completedOperation responseData]];
        if([[obj objectForKey:@"result"]isEqualToString:@"200"])
        {
            _productModel.pro_imagearray=[obj objectForKey:@"info"];
        }
        [_flowView reloadData];
        [hud hide:YES];
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [hud hide:YES];
    }];
    [ApplicationDelegate.engine enqueueOperation:op];
}
+ (NSString *)flattenHTML:(NSString *)html trimWhiteSpace:(BOOL)trim {
    NSScanner *theScanner = [NSScanner scannerWithString:html];
    NSString *text = nil;
    
    while ([theScanner isAtEnd] == NO) {
        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text] ;
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        html = [html stringByReplacingOccurrencesOfString:
                [ NSString stringWithFormat:@"%@>", text]
                                               withString:@""];
    }
    
    // trim off whitespace
    return trim ? [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] : html;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    NSLog(@"字典是%@",_setDetailDic);
    _productModel=[[[ProductModel alloc] init] getProductModel:_setDetailDic];
    
   
    [self.view addSubview:self.scrollview];
    // [self.scrollview setContentSize:CGSizeMake(320, 200)];
    self.scrollview.showsVerticalScrollIndicator = NO;
    self.scrollview.bounces = NO;
    [self.scrollview addSubview:self.flowView];
    
    self.scrollview.backgroundColor=[UIColor whiteColor];
    
    
    //goodsName
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 220, 270, 40)];
    [nameLabel setFont:[UIFont fontWithName:@"Helvetica" size:15]];
    NSString *infoname=[NSString stringWithFormat:@"景点信息\r\n%@",_productModel.pro_name];
    nameLabel.text=infoname;
    //nameLabel.backgroundColor=[UIColor clearColor];
    nameLabel.numberOfLines=0;
    nameLabel.lineBreakMode=NSLineBreakByWordWrapping;
    CGSize size = CGSizeMake(320,2000);
    nameLabel.highlighted=YES;
    
    
    nameLabel.adjustsFontSizeToFitWidth = YES;
    CGSize labelsize = [infoname sizeWithFont:nameLabel.font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    nameLabel.frame = CGRectMake(10, 215, 300, labelsize.height);
    [self.scrollview addSubview:nameLabel];
    
    
    //景点简介
    UIView *infoview= [[UIView alloc] initWithFrame:CGRectMake(10, 271+labelsize.height, 300, 85)];
    infoview.backgroundColor=[UIColor whiteColor];
    infoview.layer.cornerRadius=8;
    infoview.layer.borderColor=[UIColor colorWithRed:255/255.0 green:240/255.0 blue:245/255.0 alpha:10.0].CGColor;
    infoview.layer.borderWidth=3;
    
    infoview.layer.shadowColor=[UIColor grayColor].CGColor;
    [self.scrollview addSubview:infoview];
    
    UIImageView  *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 28, 20)];
    [imageView setImage:[UIImage imageNamed:@"jj_ico.png"]];
    [infoview addSubview:imageView];
    //简介标题
    UILabel *jjtitle=[[UILabel alloc]initWithFrame:CGRectMake(42, 10, 90, 20)];
    jjtitle.text=@"景点简介";
    jjtitle.font=[UIFont fontWithName:@"Helvetica-Bold" size:16];
    jjtitle.textColor=[UIColor colorWithRed:102/255.0 green:100/255.0 blue:92/255.0 alpha:10.0];
    //jjtitle.backgroundColor=[UIColor clearColor];
    jjtitle.highlighted=YES;
    [infoview addSubview:jjtitle];
    //虚线
    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 20, 290, 20)];
    [self.view addSubview:imageView1];
    
    
    UIGraphicsBeginImageContext(imageView1.frame.size);   //开始画线
    [imageView1.image drawInRect:CGRectMake(0, 0, imageView1.frame.size.width, imageView1.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);  //设置线条终点形状
    
    
    float lengths[] = {5,5};
    CGContextRef line = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(line, [UIColor blackColor].CGColor);
    
    CGContextSetLineDash(line, 0, lengths, 2);  //画虚线
    CGContextMoveToPoint(line, 0.0, 20.0);    //开始画线
    CGContextAddLineToPoint(line, 280.0, 20.0);
    CGContextStrokePath(line);
    
    imageView1.image = UIGraphicsGetImageFromCurrentImageContext();
    [infoview addSubview:imageView1];
    //内容简介
    UILabel *labelinfo=[[UILabel alloc]initWithFrame:CGRectMake(12, 50, 290, 40)];
    [labelinfo setFont:[UIFont fontWithName:@"Helvetica" size:14]];
    NSString *infocontent= [ShanDongCityInfoDetailViewController flattenHTML:[_productModel.pro_content stringByReplacingOccurrencesOfString:@"</p>" withString:@"\n"] trimWhiteSpace:YES ];
    labelinfo.text=infocontent;
    //labelinfo.backgroundColor=[UIColor clearColor];
    labelinfo.highlighted=YES;
   // labelinfo.backgroundColor=[UIColor whiteColor];
    labelinfo.numberOfLines=0;
    labelinfo.lineBreakMode=NSLineBreakByWordWrapping;
    CGSize sizeinfo = CGSizeMake(290,2000);
    
    
    
    labelinfo.adjustsFontSizeToFitWidth = YES;
    CGSize labelsizeinfo = [infocontent sizeWithFont:labelinfo.font constrainedToSize:sizeinfo lineBreakMode:NSLineBreakByWordWrapping];
    labelinfo.frame = CGRectMake(10, 50, 290, labelsizeinfo.height);
    infoview.frame=CGRectMake(10, 271+(labelsize.height-40),300,60+labelsizeinfo.height);
    [infoview addSubview:labelinfo];
    
    
    //规则
    UIView *infocue= [[UIView alloc] initWithFrame:CGRectMake(10, infoview.frame.origin.y+infoview.frame.size.height+50, 300, 85)];
    infocue.backgroundColor=[UIColor whiteColor];
    infocue.layer.cornerRadius=8;
    infocue.layer.borderColor=[UIColor colorWithRed:255/255.0 green:240/255.0 blue:245/255.0 alpha:10.0].CGColor;
    infocue.layer.borderWidth=3;
    infocue.layer.shadowColor=[UIColor grayColor].CGColor;
    [self.scrollview addSubview:infocue];
    
    
    UILabel *labelcue=[[UILabel alloc]initWithFrame:CGRectMake(12, 10, 290, 40)];
    [labelcue setFont:[UIFont fontWithName:@"Helvetica" size:14]];
    NSString *infocuestring= [ShanDongCityInfoDetailViewController flattenHTML:[_productModel.pro_cue stringByReplacingOccurrencesOfString:@"</p>" withString:@"\n"] trimWhiteSpace:YES ];
    labelcue.text=infocuestring;
    labelcue.backgroundColor=[UIColor clearColor];
    labelcue.numberOfLines=0;
    labelcue.lineBreakMode=NSLineBreakByWordWrapping;
    CGSize sizecue = CGSizeMake(290,2000);
    
    labelcue.adjustsFontSizeToFitWidth = YES;
    CGSize labelsizecue = [infocuestring sizeWithFont:labelcue.font constrainedToSize:sizecue lineBreakMode:NSLineBreakByWordWrapping];
    labelcue.frame = CGRectMake(10, 15, 290, labelsizecue.height);
    infocue.frame=CGRectMake(10, infoview.frame.origin.y+infoview.frame.size.height+5,300,20+labelsizecue.height);
    [infocue addSubview:labelcue];
    [self.scrollview setContentSize:CGSizeMake(320, infocue.frame.origin.y+infocue.frame.size.height+220)];
    
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, infocue.frame.origin.y+infocue.frame.size.height+190,self.view.frame.size.width, 20)];
    
    //设置页面的数量
    [_pageControl setNumberOfPages:5];
    
    //监听页面是否发生改变
    
    [self.view addSubview:_pageControl];
    
    
    
    _floatview=[[UIView alloc]initWithFrame:CGRectMake(0, 165, 320, 45)];
    _floatview.backgroundColor=[UIColor colorWithRed:249/255.0 green:249/255.0 blue:247/255.0 alpha:10.0];
    
    [self.scrollview addSubview:_floatview];
    [self.scrollview  bringSubviewToFront:_floatview];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 43, 320, 2)];
    [lineView setBackgroundColor:[UIColor colorWithRed:215/255.0 green:215/255.0 blue:215/255.0 alpha:3.0]];
    [self.floatview addSubview:lineView];
    
    UILabel *nowprice=[[UILabel alloc]initWithFrame:CGRectMake(15, 3, 50, 40)];
    [nowprice setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
    nowprice.textColor=[UIColor colorWithRed:47/255.0 green:130/255.0 blue:214/255.0 alpha:3.0];
    
    
    [nowprice setNumberOfLines:0];
    NSString *s = [NSString stringWithFormat:@"%@元",_productModel.pro_nowprice];
    //UIFont *fontprice = [UIFont fontWithName:@"Arial" size:12];
    CGSize sizeprice = CGSizeMake(320,2000);
    nowprice.text=s;
    CGSize labelsizeprice = [s sizeWithFont:nowprice.font constrainedToSize:sizeprice lineBreakMode:NSLineBreakByWordWrapping];
    [nowprice setFrame:CGRectMake(15,3, labelsizeprice.width, 40)];
    nowprice.backgroundColor=[UIColor clearColor];
    
    [_floatview addSubview:nowprice];
    
    
    UILabelStrikeThrough *mktLabel = [[UILabelStrikeThrough alloc]initWithFrame:CGRectMake(labelsizeprice.width+15+8, 3, 80, 40)];
    [mktLabel setFont:[UIFont systemFontOfSize:12.0]];
    mktLabel.strikeThroughEnabled = YES;
    [mktLabel setTextColor:[UIColor grayColor]];
    mktLabel.backgroundColor=[UIColor clearColor];
    NSString *smkt = [NSString stringWithFormat:@"%@元",_productModel.pro_price];
    UIFont *fontmkt = [UIFont fontWithName:@"Arial" size:12];
    CGSize sizemkt = CGSizeMake(320,2000);
    mktLabel.text=smkt;
    CGSize labelsizemkt = [smkt sizeWithFont:fontmkt constrainedToSize:sizemkt lineBreakMode:NSLineBreakByWordWrapping];
    [mktLabel setFrame:CGRectMake(labelsizeprice.width+15+8,3, labelsizemkt.width, 40)];
    
    [_floatview addSubview:mktLabel];
    
    
    UIButton *buttonbuy=[UIButton buttonWithType:UIButtonTypeCustom];
    buttonbuy.frame=CGRectMake(320-102, 3, 100, 38);
    [buttonbuy setTitle:@"立即购买" forState:UIControlStateNormal];
    buttonbuy.backgroundColor=[UIColor orangeColor];
    buttonbuy.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:16];
    [buttonbuy addTarget:self action:@selector(buy) forControlEvents:UIControlEventTouchUpInside];
    [_floatview addSubview:buttonbuy];
    
}
-(void)buy
{
    BuyViewController *buyVC=[BuyViewController new];
    buyVC.pro_name=_productModel.pro_name;
    buyVC.pro_price=_productModel.pro_nowprice;
    buyVC.pro_Id=_productModel.pro_id;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    //backItem.tintColor = [UIColor colorWithRed:167/255.0 green:216/255.0 blue:106/255.0 alpha:1.0];
    backItem.title=@"返回";
    self.navigationItem.backBarButtonItem = backItem;
     [self.navigationController  pushViewController:buyVC animated:YES];
}
#pragma mark - PagedFlowView Datasource
//返回显示View的个数
- (NSInteger)numberOfPagesInFlowView:(SBPageFlowView *)flowView{
    return [self.productModel.pro_imagearray count];
    
}

- (CGSize)sizeForPageInFlowView:(SBPageFlowView *)flowView;{
    return CGSizeMake(250, 148);
}

//返回给某列使用的View
- (UIView *)flowView:(SBPageFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    UIImageView *imageView = (UIImageView *)[flowView dequeueReusableCell];
    if (!imageView) {
        imageView = [[UIImageView alloc] init];
        imageView.layer.masksToBounds = YES;
        imageView.layer.borderColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1.0].CGColor;
        imageView.layer.borderWidth = 2;
    }
    imageView.image = [UIImage imageNamed:@"goods_default.png"];
    if((self.productModel.pro_imagearray !=nil)&&([self.productModel.pro_imagearray count]>0))
    {
        [YMGlobal loadImage:[[self.productModel.pro_imagearray objectAtIndex:index] objectForKey:@"url"] andImageView:imageView];
    }
    return imageView;
}

#pragma mark - PagedFlowView Delegate
- (void)didReloadData:(UIView *)cell cellForPageAtIndex:(NSInteger)index
{
    UIImageView *imageView = (UIImageView *)cell;
    imageView.image = [UIImage imageNamed:@"goods_default.png"];
    
    if(self.productModel.pro_imagearray !=nil)
    {
        [YMGlobal loadImage:[[self.productModel.pro_imagearray objectAtIndex:index] objectForKey:@"url"] andImageView:imageView];
    }
    
}

- (SBPageFlowView *)flowView
{
    if(_flowView == nil)
    {
        _flowView = [[SBPageFlowView alloc] initWithFrame:CGRectMake(0, 10, self.view.bounds.size.width, 148)];
        _flowView.delegate = self;
        _flowView.dataSource = self;
        _flowView.minimumPageAlpha = 0.4;
        _flowView.minimumPageScale = 0.8;
        _flowView.backgroundColor = [UIColor whiteColor];
        _flowView.defaultImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"goods_default.png"]];
        [_flowView reloadData];
    }
    return _flowView;
}
- (UIScrollView *)scrollview
{
    if(_scrollview == nil)
    {
        _scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 560)];
        _scrollview.delegate = self;
        //_scrollview.backgroundColor=[UIColor colorWithRed:247/255.0 green:246/255.0 blue:242/255.0 alpha:1.0];
        
        _scrollview.scrollEnabled=YES;
    }
    return _scrollview;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    [_pageControl setCurrentPage:fabs(scrollView.contentOffset.x/self.view.frame.size.width)];
    
    //NSLog(@"视图滚动中坐标（X,Y）=(%f,%f)",self.scrollview.contentOffset.x,self.scrollview.contentOffset.y);
    if (self.scrollview.contentOffset.y>165) {
        
        [self.floatview setFrame:CGRectMake(0, self.scrollview.contentOffset.y, 320, 43)];
    }else{
        
        [self.floatview setFrame:CGRectMake(0, 165, 320, 43)];
        
    }
    //NSLog(@"视图滚动中Y轴坐标%f",self.scrollview.contentOffset.y);
    
    
}
@end
