//
//  OrderSearchViewController.m
//  liudaticket
//
//  Created by Eric on 13-12-4.
//  Copyright (c) 2013年 mmc. All rights reserved.
//

#import "OrderSearchViewController.h"
#import "SearchOrderListViewController.h"
#import "MBProgressHUD.h"
@interface OrderSearchViewController ()

@end

@implementation OrderSearchViewController
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
            UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithTitle:@"查询" style:UIBarButtonItemStyleBordered target:self action:@selector(search)];
           
            self.navigationItem.rightBarButtonItem = searchItem;
            
            

        }
    }
    return self;
}
-(void)showMessage:(NSString *)strMessage hudModel:(MBProgressHUD *)hud{
    
    hud.labelText = strMessage;
    hud.labelFont=[UIFont systemFontOfSize:12.0];
    hud.mode = MBProgressHUDModeText;

    hud.margin = 10.f;
    hud.yOffset = 1.f;
    hud.xOffset=1.f;
    [hud hide:YES afterDelay:2];
}
-(NSString *)IsTrimSpace:(NSString *)str{
    if (str.length==0) {
        return @"";
    }
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}
-(void)search
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:NO];
        hud.removeFromSuperViewOnHide=YES;
    if ([self IsTrimSpace:self.TextFieldPerson.text].length==0) {
        [self showMessage:@"请填写联系人" hudModel:hud];        
        return;
    }
    if ([self IsTrimSpace:self.TextFieldPhone.text].length==0) {
        [self showMessage:@"请填写联系方式" hudModel:hud];
        return;
    }
    [hud hide:YES];
    SearchOrderListViewController *vc= [SearchOrderListViewController new];
    vc.strPerson=self.TextFieldPerson.text;
    vc.strPhone=self.TextFieldPhone.text;
    [self.navigationController pushViewController:vc animated:NO];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.TextFieldPerson.text=@"";
    self.TextFieldPhone.text=@"";
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.SearchOrdertableview];
    //[self.TextFieldPerson becomeFirstResponder];
    
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(handleBackgroundTap:)];
    tapRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapRecognizer];
    
}
- (void) handleBackgroundTap:(UITapGestureRecognizer*)sender
{
    [self.TextFieldPhone resignFirstResponder];
    [self.TextFieldPerson resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
//重写UItableview的getter方法
- (UITableView *)SearchOrdertableview
{
    if (_SearchOrdertableview == nil) {
        _SearchOrdertableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - 64) style:UITableViewStyleGrouped];
        _SearchOrdertableview.delegate = self;
        _SearchOrdertableview.dataSource = self;
        _SearchOrdertableview.backgroundView = nil;
        _SearchOrdertableview.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
    }
    return _SearchOrdertableview;
}

//重写TextFieldPerson的Getter方法
-(UITextField *)TextFieldPerson
{
    if (_TextFieldPerson==nil) {
        //创建联系人Label
        UILabel *labelPerson =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 40)];
        labelPerson.text=@"联系人:  ";
        labelPerson.backgroundColor=[UIColor clearColor];
        labelPerson.font=[UIFont systemFontOfSize:14.0];
        labelPerson.textAlignment=NSTextAlignmentRight;
        //创建TextFieldPerson
        _TextFieldPerson=[[UITextField alloc] initWithFrame:CGRectMake(10, 5, 300, 40)];
        _TextFieldPerson.placeholder=@"联系人";
        _TextFieldPerson.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
        _TextFieldPerson.clearButtonMode=UITextFieldViewModeWhileEditing;//清空按钮
        _TextFieldPerson.leftView=labelPerson;
        _TextFieldPerson.leftViewMode=UITextFieldViewModeAlways;
        _TextFieldPerson.font=[UIFont systemFontOfSize:14.0f];
        _TextFieldPerson.returnKeyType=UIReturnKeyDone;
        _TextFieldPerson.delegate=self;
    }
    return _TextFieldPerson;
}
//重写TextFieldPhone的Getter方
-(UITextField *)TextFieldPhone
{
    if (_TextFieldPhone==nil) {
        //创建联系人Label
        UILabel *labelPhone =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 40)];
        labelPhone.text=@"联系方式:  ";
        labelPhone.backgroundColor=[UIColor clearColor];
        labelPhone.font=[UIFont systemFontOfSize:14.0];
        labelPhone.textAlignment=NSTextAlignmentRight;
        //创建TextFieldPhone
        _TextFieldPhone=[[UITextField alloc] initWithFrame:CGRectMake(10, 5, 300, 40)];
        _TextFieldPhone.placeholder=@"联系方式";
        _TextFieldPhone.clearButtonMode=UITextFieldViewModeWhileEditing;//清空按钮
        _TextFieldPhone.leftView=labelPhone;
        _TextFieldPhone.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
        _TextFieldPhone.leftViewMode=UITextFieldViewModeAlways;
        _TextFieldPhone.font=[UIFont systemFontOfSize:14.0f];
        _TextFieldPhone.returnKeyType=UIReturnKeyDone;
        _TextFieldPhone.delegate=self;
       
    }
    return _TextFieldPhone;

}

// 触摸背景，关闭键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    UIView *view = (UIView *)[touch view];
    if (view == self.view) {
        [self.TextFieldPerson resignFirstResponder];
        [self.TextFieldPhone resignFirstResponder];
    }
}
-(UIButton *)ButtonSearch{
    if (_ButtonSearch==nil) {
        _ButtonSearch=[UIButton buttonWithType:UIButtonTypeCustom];
        _ButtonSearch.frame=CGRectMake(10, 5, 100, 30);
        _ButtonSearch.backgroundColor=[UIColor orangeColor];
        [_ButtonSearch setTitle:@"搜索" forState:UIControlStateNormal];
        [_ButtonSearch setTitle:@"搜索" forState:UIControlStateHighlighted];
        [_ButtonSearch addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
    }
return _ButtonSearch;
}

#pragma  mark - UITableView的各种方法
//返回TableView中section的个数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//返回指定section的rows行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger rowsNum=0;
    switch (section) {
        case 0:
            rowsNum=2;
            break;
        default:
            rowsNum=1;
            break;
    }
    return rowsNum;
}
//返回指定Row的g高度
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
    
}
//返回指定row的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *tableviewCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    //tableviewCell.selectionStyle=UITableViewCellSelectionStyleNone;
    if(tableviewCell == nil)
    {
        tableviewCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        //tableviewCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        tableviewCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [tableviewCell addSubview:self.TextFieldPerson];
        } else if (indexPath.row == 1) {
            [tableviewCell addSubview:self.TextFieldPhone];
        }
    }
    return tableviewCell;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
