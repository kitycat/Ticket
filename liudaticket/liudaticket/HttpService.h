//
//  HttpService.h
//  liudaticket
//
//  Created by Eric on 13-11-30.
//  Copyright (c) 2013年 mmc. All rights reserved.
//

#import "MKNetworkEngine.h"

@interface HttpService : MKNetworkEngine
@property (strong, nonatomic) MKNetworkEngine *engine;
@end
