//
//  NearbyServers.m
//  iBang
//
//  Created by yyx on 15/6/25.
//  Copyright (c) 2015年 kiwi. All rights reserved.
//  附近的服务者（type: driver/drinker/client — 查询的身份）

#import "NearbyServers.h"

@implementation NearbyServers
{
    double _lng;
    double _lat;
    int _range;
    NSString *_type;
}

- (id)initWithLng:(double)lng andLat:(double)lat andRange:(int)range andType:(NSString *)type
{
    self = [super init];
    if (self) {
        _lng = lng;
        _lat = lat;
        _range = range;
        _type = type;
    }
    return self;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodGet;
}


- (NSString *)requestUrl{
    return @"/location";
}

- (id)requestArgument{
    return @{
             @"lng":[NSNumber numberWithDouble:_lng],
             @"lat":[NSNumber numberWithDouble:_lat],
             @"range":[NSNumber numberWithInt:_range],
             @"type":_type};
}

//请求头示例
//所有接口调用时需要设置header X-Requested-With:XMLHttpRequest
//默认发送方法 application/x-www-form-urlencoded
//在发送文件时 multipart/form-data
-(NSDictionary *) requestHeaderFieldValueDictionary{
    NSDictionary *headerDic = [NSDictionary dictionaryWithObjectsAndKeys:@"XMLHttpRequest",@"X-Requested-With",@"application/x-www-form-urlencoded",@"Content-Type", nil];
    return headerDic;
}

- (id)responseJSONObject {
    return self.requestOperation.responseObject;
}

- (NSInteger)responseStatusCode {
    return self.requestOperation.response.statusCode;
}

@end
