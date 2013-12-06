//
//  OrderSuccessViewController.m
//  liudaticket
//
//  Created by Eric on 13-12-4.
//  Copyright (c) 2013年 mmc. All rights reserved.
//

#import "OrderSuccessViewController.h"

@interface OrderSuccessViewController ()

@end

@implementation OrderSuccessViewController

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
    self.Label_OrderId.text=self.orderid;
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
