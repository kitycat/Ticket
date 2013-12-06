//
//  SearchViewController.m
//  liudaticket
//
//  Created by only on 13-11-28.
//  Copyright (c) 2013年 mmc. All rights reserved.
//

#import "SearchViewController.h"
#import "HPLTagCloudGenerator.h"
#import "ProductlistViewController.h"
#import "MBProgressHUD.h"
#import "ViewController.h"
@interface SearchViewController ()

@end

@implementation SearchViewController

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
    
   }
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    UIView *tagview=[[UIView alloc] initWithFrame:CGRectMake(0, 40, 320, 360)];
    tagview.backgroundColor=[UIColor clearColor];
    [self.view addSubview:tagview];
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // This runs in a background thread
        
        // dictionary of tags
        NSDictionary *tagDict = @{@"大明湖": @"url",
                                  @"灵岩寺": @5,
                                  @"趵突泉": @7,
                                  @"阿尔卡迪亚": @2,
                                  @"千佛山": @"http://baidu.com",
                                  @"潭山": @4,
                                  @"黄山": @9,
                                  @"台儿庄": @11,
                                  @"九华山": @"http://baidu.com",
                                  @"杭州西湖": @4,
                                  @"一览": @9,
                                  @"济南植物园": @11};
        
        
        HPLTagCloudGenerator *tagGenerator = [[HPLTagCloudGenerator alloc] init];
        tagGenerator.size = CGSizeMake(tagview.frame.size.width, tagview.frame.size.height);
        tagGenerator.tagDict = tagDict;
        
        NSArray *views = [tagGenerator generateTagViews];
        
        NSLog(@"视图%f",tagview.frame.size.height);
        dispatch_async( dispatch_get_main_queue(), ^{
            // This runs in the UI Thread
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.7];
            [UIView setAnimationDelegate:self];
            
           
            for(UIView *v in views) {
                v.clipsToBounds=NO;
                v.userInteractionEnabled=YES;
                v.transform = CGAffineTransformScale([self transformForOrientation], 1.08, 1.09);
                 [tagview addSubview:v];               
            }
            
             [UIView commitAnimations];
        });
    });

}

/*键盘搜索按钮*/
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [self.searchBar setShowsCancelButton:NO];
    [self doSearch:searchBar];
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

   // MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:NO];
/*搜索*/
- (void)doSearch:(UISearchBar *)searchBar{
    //...

        MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        //ProductlistViewController *vc= [[ProductlistViewController alloc]init];
  [[NSNotificationCenter defaultCenter] postNotificationName:@"pushKeyVC" object:self userInfo:[NSMutableDictionary dictionaryWithObject:self.searchBar.text forKey:@"keywords"]];
    [self dismissViewControllerAnimated:NO completion:nil];
       
        [hud hide:YES];
   // }];
   
   
}

- (CGAffineTransform)transformForOrientation {
	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
	if (UIInterfaceOrientationLandscapeLeft == orientation) {
		return CGAffineTransformMakeRotation(M_PI*1.5);
	} else if (UIInterfaceOrientationLandscapeRight == orientation) {
		return CGAffineTransformMakeRotation(M_PI/2);
	} else if (UIInterfaceOrientationPortraitUpsideDown == orientation) {
		return CGAffineTransformMakeRotation(-M_PI);
	} else {
		return CGAffineTransformIdentity;
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"内存警告");
}
//搜索返回
- (IBAction)backview:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
    for(id cc in [self.searchBar subviews])
    {
        if([cc isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)cc;
            [btn setTitle:@"取消"  forState:UIControlStateNormal];
            break;
        }
    }
}
//点击取消
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    [self.searchBar setShowsCancelButton:NO];
}

@end
