//
//  GetUserInfoApi.m
//  iBang
//
//  Created by 龙斐 on 15/6/24.
//  Copyright (c) 2015年 kiwi. All rights reserved.
//

#import "GetUserInfoApi.h"

@implementation GetUserInfoApi
{
    NSString *_userId;
}

- (id)initWithUserId:(NSString *)userId
{
    self = [super init];
    if (self) {
        _userId = userId;
    }
    return self;
}

- (NSString *)requestUrl
{
    return [@"/user/" stringByAppendingString:_userId];
}

- (id)requestArgument
{
    return @{ @"id":_userId };
}

//请求头示例
//所有接口调用时需要设置header X-Requested-With:XMLHttpRequest
//默认发送方法 application/x-www-form-urlencoded
//在发送文件时 multipart/form-data
-(NSDictionary *) requestHeaderFieldValueDictionary{
    NSDictionary *headerDic = [NSDictionary dictionaryWithObjectsAndKeys:@"XMLHttpRequest",@"X-Requested-With",@"application/x-www-form-urlencoded",@"Content-Type", nil];
    //所有请求都必须设置
    //    [headerDic setValue:@"XMLHttpRequest" forKey:@"X-Requested-With"];
    //默认发送 设置
    //    [headerDic setValue:@"application/x-www-form-urlencoded" forKey:@"Content-Type"];
    //文件上传／发送 设置,注册登录为默认发送，所以注释
    //[headerDic setValue:@"multipart/form-data" forKey:@"Content-Type"];
    return headerDic;
}

- (id)responseJSONObject
{
    return self.requestOperation.responseObject;
}

- (NSInteger)responseStatusCode
{
    return self.requestOperation.response.statusCode;
}

@end
