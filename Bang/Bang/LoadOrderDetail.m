//
//  LoadOrderDetail.m
//  iBang
//
//  Created by yyx on 15/10/2.
//  Copyright © 2015年 kiwi. All rights reserved.
//

#import "LoadOrderDetail.h"

@implementation LoadOrderDetail{
    NSString *_orderId;
}

-(id)initWithOrderId:(NSString *)orderId{
    self = [super init];
    if (self) {
        _orderId = orderId;
    }
    return self;
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodGet;
}

- (NSString *)requestUrl{
    return [NSString stringWithFormat:@"%@%@%@",@"order/",_orderId,@"/detail"];
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
