//
//  UserLoginApi.m
//  iBang
//
//  Created by 龙斐 on 15/6/24.
//  Copyright (c) 2015年 kiwi. All rights reserved.
//

#import "UserLoginApi.h"

@implementation UserLoginApi
{
    NSString *_username;
    NSString *_password;
}

- (id)initWithUsername:(NSString *)username password:(NSString *)password
{
    self = [super init];
    if (self) {
        _username = username;
        _password = password;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"/user";
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPost;
}

- (id)requestArgument
{
    return @{@"username":_username,
                 @"password":_password};
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

//获取请求的响应头（字典）
- (NSDictionary *)responseHeaders {
    return self.requestOperation.response.allHeaderFields;
}

- (id) responseJSONObject{
    return self.requestOperation.responseObject;
}

- (NSInteger) responseStatusCode{
    return self.requestOperation.response.statusCode;
}

@end
