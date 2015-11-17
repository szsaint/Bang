//
//  ConvertTicket.m
//  iBang
//
//  Created by yyx on 15/6/26.
//  Copyright (c) 2015年 kiwi. All rights reserved.
//  通过优惠券代码兑换优惠券

#import "ConvertTicket.h"

@implementation ConvertTicket
{
    NSString *_code;
}

- (id)initWithTicketCode:(NSString *)code{
    self = [super init];
    if (self) {
        _code = code;
    }
    return self;
}

- (NSString *)requestUrl{
    return @"/ticket";
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodPost;
}

- (id)requestArgument{
    return @{
             @"code":_code
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
