//
//  AcceptOrder.m
//  iBang
//
//  Created by yyx on 15/6/26.
//  Copyright (c) 2015年 kiwi. All rights reserved.
//  服务者接单 _serverId服务者的ID

#import "AcceptOrder.h"

@implementation AcceptOrder
{
    NSString *_serverId;
}

- (id)initWithServerId:(NSString *)serverId{
    self = [super init];
    if (self) {
        _serverId = serverId;
    }
    return self;
}

- (NSString *)requestUrl{
    return [NSString stringWithFormat:@"%@%@%@",@"/order/",_serverId,@"/accept"];
}

-(id)requestArgument{
    return @{
             @"server_device":@"ios"
             };
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodPut;
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
