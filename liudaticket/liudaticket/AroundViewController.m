//
//  AroundViewController.m
//  liudaticket
//
//  Created by EricWei on 13-11-28.
//  Copyright (c) 2013年 mmc. All rights reserved.
//

#import "AroundViewController.h"
#import <CoreLocation/CoreLocation.h>
@interface AroundViewController ()

@end

@implementation AroundViewController(TemporaryHack)  

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
         self.title = NSLocalizedString(@"周边",@"周边");
        [self.tabBarItem setImage:[UIImage imageNamed:@"tabbar_category_unselected"]];
        if([[[UIDevice currentDevice] systemVersion] floatValue] >=5.0)
        {
            [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabbar_category"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar_category_unselected"]];
                   }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    checkinLocation = newLocation;
    
    //do something else
}
- (void) setupLocationManager {
    self->locationManager = [[CLLocationManager alloc] init];
    if ([CLLocationManager locationServicesEnabled]) {
        NSLog( @"Starting CLLocationManager" );
        self->locationManager.delegate = self;
        self->locationManager.distanceFilter = 200;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [self->locationManager startUpdatingLocation];
    } else {
        NSLog( @"Cannot Starting CLLocationManager" );
        /*self.locationManager.delegate = self;
         self.locationManager.distanceFilter = 200;
         locationManager.desiredAccuracy = kCLLocationAccuracyBest;
         [self.locationManager startUpdatingLocation];*/
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
