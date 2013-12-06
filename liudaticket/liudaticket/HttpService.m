//
//  HttpService.m
//  liudaticket
//
//  Created by Eric on 13-11-30.
//  Copyright (c) 2013年 mmc. All rights reserved.
//

#import "HttpService.h"
#import "MKNetworkEngine.h"
@implementation HttpService

- (MKNetworkEngine *)engine
{
    if(_engine == nil)
    {
        _engine = [[MKNetworkEngine alloc]initWithHostName:@"42.51.8.205:8099/" customHeaderFields:nil];
        [_engine useCache];
    }
    return _engine;
}
@end
