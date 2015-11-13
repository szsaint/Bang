//
//  UpLoadMyLocation.m
//  iBang
//
//  Created by yyx on 15/6/25.
//  Copyright (c) 2015年 kiwi. All rights reserved.
//  提交我当前的位置

#import "UpLoadMyLocation.h"

@implementation UpLoadMyLocation
{
    MAUserLocation *_location;
}

- (id)initLoactionWithLng:(MAUserLocation *) location{
    self = [super init];
    if (self) {
        _location = location;
    }
    return self;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPut;
}


- (NSString *)requestUrl{
    return @"/location/0";
}

- (id)requestArgument{
    return @{
             @"lng":[NSNumber numberWithDouble:_location.coordinate.longitude],
             @"lat":[NSNumber numberWithDouble:_location.coordinate.latitude]
            };
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
