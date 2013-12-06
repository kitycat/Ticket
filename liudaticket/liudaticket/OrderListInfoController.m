//
//  OrderListInfoController.m
//  liudaticket
//
//  Created by only on 13-12-5.
//  Copyright (c) 2013年 mmc. All rights reserved.
//

#import "OrderListInfoController.h"
#import "MKNetworkKit.h"
#import "SBJson.h"
@interface OrderListInfoController ()

@end

@implementation OrderListInfoController
@synthesize OrderInfoTableview = _OrderInfoTableview;
@synthesize NameLabel;        //商品名称
@synthesize OrderTypeLabel;   //订单类型
@synthesize OrderStateLabel;  //订单状态
@synthesize VolumeLabel;      //消费卷码
@synthesize ExpiredTimeLabel; //过期时间
@synthesize OrderNumberLabel; //订单编号
@synthesize OrderTime;        //下单时间
@synthesize Money;            //支付金额


//{
//    buytime = "2013-12-04 13:28:55";
//    flag = "\U6ce2\U7f57\U5cea";
//    name = "\U4ec5\U970035\U5143\U5373\U53ef\U83b7\U5f97\U4ef7\U503c60\U5143\U7684\U6ce2\U7f57\U5cea\U666f\U533a\U6210\U4eba\U95e8\U7968\U4e00\U5f20\Uff0c\U5feb\U6765\U62a2\U8d2d\U5427!!!";
//    orderid = 2013120470039;
//    pay = 0;
//    paymoney = 0;
//    paytype = "\U652f\U4ed8\U5b9d";
//    productnum = 1;
//    productprice = 35;
//    totalprice = 35;
//}

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
    // Do any additional setup after loading the view from its nib.
    [self.view addSubview:self.OrderInfoTableview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UITableView *)OrderInfoTableview
{
    if(_OrderInfoTableview == nil)
    {
        _OrderInfoTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-180)style:UITableViewStyleGrouped];
        _OrderInfoTableview.delegate = self;
        _OrderInfoTableview.dataSource = self;
        _OrderInfoTableview.showsVerticalScrollIndicator = NO;
    }
    return _OrderInfoTableview;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(100, 10, 200, 20)];
    [label setBackgroundColor:[UIColor clearColor]];
    label.font = [UIFont systemFontOfSize:13.0];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:13.0];
        [cell.contentView addSubview:label];
    }
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"商品名称:";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//右箭头
            label.text = @"bbbb";
            break;
        case 1:
            cell.textLabel.text = @"订单类型:";
            label.text = @"支付宝";
            label.textColor = [UIColor redColor];
            break;
        case 2:
            cell.textLabel.text = @"订单状态:";
            label.textColor = [UIColor redColor];
            if(true)
            {
                UIButton *GotoPayButton = [UIButton buttonWithType:UIButtonTypeCustom];
                GotoPayButton.frame = CGRectMake(228, 1, 70, 42);
                [GotoPayButton setTitle:@"去支付" forState:UIControlStateNormal];
                [GotoPayButton setBackgroundColor:[UIColor orangeColor]];
                [GotoPayButton addTarget:self action:@selector(GotoPay:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:GotoPayButton];
                label.text = @"未支付";
            }else{
                label.text = @"已支付";
            }
            break;
        case 3:
            cell.textLabel.text = @"消费卷码:";
            break;
        case 4:
            cell.textLabel.text = @"过期时间:";
            break;
        case 5:
            cell.textLabel.text = @"订单编号:";
            break;
        case 6:
            cell.textLabel.text = @"下单时间:";
            break;
        case 7:
            cell.textLabel.text = @"支付金额:";
            break;
        case 8:
        default:
            break;
    }
    return cell;
}

//去支付
- (void)GotoPay:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"支付成功" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
    [alert show];
}
@end
