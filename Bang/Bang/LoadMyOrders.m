//
//  LoadMyOrders.m
//  iBang
//
//  Created by yyx on 15/8/10.
//  Copyright (c) 2015年 kiwi. All rights reserved.
//

#import "LoadMyOrders.h"

@implementation LoadMyOrders
{
    NSString *_url;
}

- (id)initWithUrl:(NSString *)url
{
    self = [super init];
    if (self) {
        _url = url;
    }
    return self;
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodGet;
}

- (NSString *)requestUrl{
    return _url;
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
