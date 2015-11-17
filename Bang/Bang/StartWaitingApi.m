//
//  StartWaitingApi.m
//  iBang
//
//  Created by yyx on 15/6/26.
//  Copyright (c) 2015年 kiwi. All rights reserved.
//  开始等待客户上车

#import "StartWaitingApi.h"

@implementation StartWaitingApi
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
    return [NSString stringWithFormat:@"%@%@%@",@"/order/",_serverId,@"/start_waiting"];
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
