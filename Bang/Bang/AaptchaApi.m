//
//  AaptchaApi.m
//  iBang
//
//  Created by yyx on 15/7/12.
//  Copyright (c) 2015年 kiwi. All rights reserved.
//

#import "AaptchaApi.h"

@implementation AaptchaApi{
    NSString *_phone;
}

- (id) initWithPhone:(NSString *)phone{
    self = [super init];
    if (self) {
        _phone = phone;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"/captcha";
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPost;
}

- (id)requestArgument
{
    return @{@"phone":_phone};
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


@end
