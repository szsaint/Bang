//
//  StarApi.m
//  iBang
//
//  Created by yyx on 15/9/6.
//  Copyright (c) 2015年 kiwi. All rights reserved.
//

#import "StarApi.h"

@implementation StarApi{
    NSString *_orderId;
    NSString *_comment;
    CGFloat _score;
}

-(id)initWithOrderId:(NSString *)orderId andComment:(NSString *)comment withScore:(CGFloat)score{
    self = [super init];
    if (self) {
        _orderId = orderId;
        _comment = comment;
        _score = score;
    }
    return self;
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodPut;
}

- (NSString *)requestUrl{
    return [NSString stringWithFormat:@"%@%@%@",@"/order/",_orderId,@"/finish"];
}

- (id)requestArgument{
    return @{@"score":[NSNumber numberWithDouble:_score],
             @"comment":_comment};
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
