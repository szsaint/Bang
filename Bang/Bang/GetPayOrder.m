//
//  GetPayOrder.m
//  Bang
//
//  Created by wl on 15/11/23.
//  Copyright © 2015年 saint. All rights reserved.
//

#import "GetPayOrder.h"

@implementation GetPayOrder
{
    NSString *_orderID;
}

- (id)initWithOrderId:(NSString *)orderID{
    self = [super init];
    if (self) {
        _orderID = orderID;
    }
    return self;
}

- (NSString *)requestUrl{
    return [NSString stringWithFormat:@"%@%@%@",@"/order/",_orderID,@"/pay"];
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodGet;
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
