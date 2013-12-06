//
//  SearchViewController.h
//  liudaticket
//
//  Created by only on 13-11-28.
//  Copyright (c) 2013年 mmc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController
@property(strong,nonatomic)IBOutlet UISearchBar *searchBar;
//搜索返回
- (IBAction)backview:(id)sender;
@end
