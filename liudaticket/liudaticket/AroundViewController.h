//
//  AroundViewController.h
//  liudaticket
//
//  Created by EricWei on 13-11-28.
//  Copyright (c) 2013年 mmc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import <CoreLocation/CoreLocation.h>
@interface AroundViewController : UIViewController<CLLocationManagerDelegate>{
    CLLocationManager *locationManager;
    CLLocation *checkinLocation;
}
@end
