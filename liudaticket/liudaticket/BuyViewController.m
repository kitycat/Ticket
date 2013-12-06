//
//  BuyViewController.m
//  liudaticket
//
//  Created by Eric on 13-12-3.
//  Copyright (c) 2013年 mmc. All rights reserved.
//

#import "BuyViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "RadioButton.h"
#import "MKNetworkEngine.h"
#import "MBProgressHUD.h"
#import "YMGlobal.h"
#import "AppDelegate.h"
#import "SBJson.h"
#import "OrderSuccessViewController.h"
@interface BuyViewController ()

@end

@implementation BuyViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"溜达淘票";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //goodsName
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 300, 40)];
    [nameLabel setFont:[UIFont fontWithName:@"BanglaSangamMN" size:15]];
    NSString *infoname=[NSString stringWithFormat:@"景点信息\r\n%@",_pro_name];
    nameLabel.text=infoname;
    //nameLabel.backgroundColor=[UIColor clearColor];
    nameLabel.numberOfLines=0;
    nameLabel.lineBreakMode=NSLineBreakByWordWrapping;
    CGSize size = CGSizeMake(320,2000);
    nameLabel.highlighted=YES;
    
    nameLabel.adjustsFontSizeToFitWidth = YES;
    CGSize labelsize = [infoname sizeWithFont:nameLabel.font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    nameLabel.frame = CGRectMake(10, 10, 300, labelsize.height);
    [self.view addSubview:nameLabel];
    
    //景点简介
    UIView *infoview= [[UIView alloc] initWithFrame:CGRectMake(10, 13+labelsize.height, 300, 170)];
    infoview.backgroundColor=[UIColor whiteColor];
    infoview.layer.cornerRadius=8;
    infoview.layer.borderColor=[UIColor colorWithRed:255/255.0 green:240/255.0 blue:245/255.0 alpha:10.0].CGColor;
    infoview.layer.borderWidth=3;
    
    infoview.layer.shadowColor=[UIColor grayColor].CGColor;
    [self.view addSubview:infoview];
    
    UILabel *label_pro_countinfo=[[UILabel alloc] initWithFrame:CGRectMake(10, 15, 60, 20)];
    label_pro_countinfo.text=@"订购数量:";
    label_pro_countinfo.font=[UIFont fontWithName:@"BanglaSangamMN" size:13.0];
    //label_pro_countinfo.textColor=[UIColor colorWithRed:189/255.0 green:189/255.0 blue:189/255.0 alpha:1.0];
    label_pro_countinfo.textAlignment=UIControlContentHorizontalAlignmentRight;
    [infoview addSubview:label_pro_countinfo];
    
    _accountField = [[UITextField alloc] initWithFrame:CGRectMake(75, 8, 80, 25)];
    _accountField.delegate=self;
    [_accountField setBorderStyle:UITextBorderStyleLine]; //外框类型
    //[_accountField setbo];
    _accountField.layer.borderColor = [[UIColor colorWithRed:189/255.0 green:189/255.0 blue:189/255.0 alpha:1.0] CGColor];
    _accountField.layer.borderWidth = 1.0f;
    _accountField.returnKeyType=UIReturnKeyDone;
    [_accountField addTarget:self action:@selector(textFieldDone:)  forControlEvents:UIControlEventTouchDown];
    _accountField.keyboardType = UIKeyboardTypeNumberPad;
    _accountField.secureTextEntry = NO; //是否以密码形式显示
    [infoview addSubview:_accountField];
    
    UILabel *nowprice=[[UILabel alloc] initWithFrame:CGRectMake(160, 3, 80, 20)];
    NSString *s = [NSString stringWithFormat:@"%.2f元",[_pro_price floatValue]];
    //UIFont *fontprice = [UIFont fontWithName:@"Arial" size:12];
    CGSize sizeprice = CGSizeMake(320,2000);
    nowprice.text=s;
    CGSize labelsizeprice = [s sizeWithFont:nowprice.font constrainedToSize:sizeprice lineBreakMode:NSLineBreakByWordWrapping];
    [nowprice setFrame:CGRectMake(160,10, labelsizeprice.width, 20)];
    nowprice.textColor=[UIColor redColor];
    
    [infoview addSubview:nowprice];
    
    
    
    UILabel *label_pro_person=[[UILabel alloc] initWithFrame:CGRectMake(10, 45, 60, 20)];
    label_pro_person.text=@"联系人:";
    label_pro_person.textAlignment=UIControlContentHorizontalAlignmentRight;
    label_pro_person.font=[UIFont fontWithName:@"BanglaSangamMN" size:13.0];
    //label_pro_person.textColor=[UIColor colorWithRed:189/255.0 green:189/255.0 blue:189/255.0 alpha:1.0];
    [infoview addSubview:label_pro_person];
    
    
    _personField = [[UITextField alloc] initWithFrame:CGRectMake(75, 40 , 180, 25)];
    _personField.delegate=self;
    [_personField setBorderStyle:UITextBorderStyleLine]; //外框类型
    //[_accountField setbo];
    _personField.layer.borderColor = [[UIColor colorWithRed:189/255.0 green:189/255.0 blue:189/255.0 alpha:1.0] CGColor];
    _personField.layer.borderWidth = 1.0f;
    _personField.returnKeyType=UIReturnKeyDone;
    //_accountField.placeholder = @"用户名"; //默认显示的字
    // _personField.keyboardType = UIKeyboardTypeDefault;
    _personField.secureTextEntry = NO; //是否以密码形式显示
    [infoview addSubview:_personField];
    
    
    
    
    
    
    
    UILabel *label_pro_phone=[[UILabel alloc] initWithFrame:CGRectMake(10, 77, 60, 20)];
    label_pro_phone.text=@"联系号码:";
    label_pro_phone.textAlignment=UIControlContentHorizontalAlignmentRight;
    label_pro_phone.font=[UIFont fontWithName:@"BanglaSangamMN" size:13.0];
    //label_pro_phone.textColor=[UIColor colorWithRed:189/255.0 green:189/255.0 blue:189/255.0 alpha:1.0];
    [infoview addSubview:label_pro_phone];
    
    
    _phoneField = [[UITextField alloc] initWithFrame:CGRectMake(75, 72 , 180, 25)];
    _phoneField.delegate=self;
    [_phoneField setBorderStyle:UITextBorderStyleLine]; //外框类型
    //[_accountField setbo];
    _phoneField.layer.borderColor = [[UIColor colorWithRed:189/255.0 green:189/255.0 blue:189/255.0 alpha:1.0] CGColor];
    _phoneField.layer.borderWidth = 1.0f;
    // _phoneField.returnKeyType=UIReturnKeyDone;
    //_accountField.placeholder = @"用户名"; //默认显示的字
    _phoneField.keyboardType = UIKeyboardTypePhonePad;
    _phoneField.secureTextEntry = NO; //是否以密码形式显示
    [_phoneField addTarget:self action:@selector(textFieldDone:)  forControlEvents:UIControlEventTouchDown];
    [infoview addSubview:_phoneField];
    
    
    
    
    UILabel *label_pro_tradetype=[[UILabel alloc] initWithFrame:CGRectMake(10, 107, 60, 20)];
    label_pro_tradetype.text=@"支付方式:";
    label_pro_tradetype.textAlignment=UIControlContentHorizontalAlignmentRight;
    label_pro_tradetype.font=[UIFont fontWithName:@"BanglaSangamMN" size:13.0];
    //label_pro_tradetype.textColor=[UIColor colorWithRed:189/255.0 green:189/255.0 blue:189/255.0 alpha:1.0];
    [infoview addSubview:label_pro_tradetype];
    
    RadioButton *rb1 = [[RadioButton alloc] initWithGroupId:@"one" index:0];
    RadioButton *rb2 = [[RadioButton alloc] initWithGroupId:@"one" index:1];
    rb1.frame = CGRectMake(85,105,22,22);
    rb2.frame = CGRectMake(155,105,22,22);
    [infoview addSubview:rb1];
    [infoview addSubview:rb2];
    //[rb1 release];
    [rb1 setChecked:YES];
    UILabel *label1 =[[UILabel alloc] initWithFrame:CGRectMake(105, 108, 60, 20)];
    label1.backgroundColor = [UIColor clearColor];
    label1.font=[UIFont fontWithName:@"BanglaSangamMN" size:12];
    label1.text = @"在线支付";
    [infoview addSubview:label1];
    
    UILabel *label2 =[[UILabel alloc] initWithFrame:CGRectMake(175, 108, 60, 20)];
    label2.backgroundColor = [UIColor clearColor];
    label2.font=[UIFont fontWithName:@"BanglaSangamMN" size:12];
    label2.text = @"景点到付";
    [infoview addSubview:label2];
    
    [RadioButton addObserverForGroupId:@"one" observer:self];
    
    _pro_paytype=@"2";
    
    
    UIButton *buttonbuy=[UIButton buttonWithType:UIButtonTypeCustom];
    buttonbuy.frame=CGRectMake(185, 130, 90,30);
    [buttonbuy setTitle:@"提交订单" forState:UIControlStateNormal];
    buttonbuy.backgroundColor=[UIColor orangeColor];
    buttonbuy.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:16];
    [buttonbuy addTarget:self action:@selector(buy) forControlEvents:UIControlEventTouchUpInside];
    [infoview addSubview:buttonbuy];
    
}
- (BOOL)isPureInt:(NSString*)string{
    if ([self IsTrimSpace:string].length==0) {
        return NO;
    }
    NSScanner* scan = [NSScanner scannerWithString:[self IsTrimSpace:string]];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}
-(NSString *)IsTrimSpace:(NSString *)str{
    if (str.length==0) {
        return @"";
    }
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}
-(void)showMessage:(NSString *)strMessage hudModel:(MBProgressHUD *)hud{
    
    hud.labelText = strMessage;
    hud.labelFont=[UIFont systemFontOfSize:12.0];
    hud.mode = MBProgressHUDModeText;
    
    hud.margin = 10.f;
    hud.yOffset = 150.f;
    [hud hide:YES afterDelay:2];
}
-(void)buy
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:NO];
    hud.removeFromSuperViewOnHide = YES;
    if (![self isPureInt:_accountField.text]) {
        [self showMessage:@"订购数量不能空且为数字" hudModel:hud];
        return;
    }
    if (_personField.text.length==0) {
        [self showMessage:@"请填写联系人" hudModel:hud];
        return;
    }
    if (_phoneField.text.length==0) {
        [self showMessage:@"请填写联系方式" hudModel:hud];
        return;
    }
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:@"order_add" forKey:@"action"];
    [params setObject:[self IsTrimSpace:_personField.text] forKey:@"username"];
    [params setObject:[self IsTrimSpace:_phoneField.text] forKey:@"phone"];
    [params setObject:[self IsTrimSpace:_pro_Id] forKey:@"productid"];
    [params setObject:[self IsTrimSpace:_accountField.text] forKey:@"productnum"];
    [params setObject:[self IsTrimSpace:_pro_price] forKey:@"productprice"];
    [params setObject:[self IsTrimSpace:@"0"] forKey:@"expressprice"];
    [params setObject:[self IsTrimSpace:_pro_paytype] forKey:@"paytype"];
    MKNetworkOperation *op = [YMGlobal getOperation:params];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        SBJsonParser *parser = [[SBJsonParser alloc]init];
        NSMutableDictionary *obj = [parser objectWithData:[completedOperation responseData]];
        
        if([[obj objectForKey:@"result"]isEqualToString:@"200"])
        {
            OrderSuccessViewController *orderSuccessVC=[OrderSuccessViewController new];
            _pro_orderid=@"2013120427877";
            orderSuccessVC.orderid=_pro_orderid;
            UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
            //backItem.tintColor = [UIColor colorWithRed:167/255.0 green:216/255.0 blue:106/255.0 alpha:1.0];
            backItem.title=@"返回";
            self.navigationItem.backBarButtonItem = backItem;
            [self.navigationController pushViewController:orderSuccessVC animated:NO];
            //[hud hide: YES];
            
        }
        [hud hide:YES];
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"错误是%@",error);
        [hud hide:YES];
    }];
    [ApplicationDelegate.engine enqueueOperation:op];
    
    
}
-(void)radioButtonSelectedAtIndex:(NSUInteger)index inGroup:(NSString *)groupId{
    
    if ([groupId isEqualToString:@"one"]) {
        if (index==0)
            _pro_paytype=@"2";
        else
            _pro_paytype=@"3";
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDone:(id)sender{
    [sender resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
