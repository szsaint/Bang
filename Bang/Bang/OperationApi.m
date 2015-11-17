//
//  OperationApi.m
//  iBang
//
//  Created by yyx on 15/11/7.
//  Copyright © 2015年 kiwi. All rights reserved.
//

#import "OperationApi.h"

@implementation OperationApi
{
    NSString *_url;
    NSDictionary *_params;
}

-(id) initWithUrl:(NSString *)url params:(NSDictionary *)params{
    self = [super init];
    if (self) {
        _url = url;
        _params = params;
    }
    return self;
}

-(NSString *)requestUrl{
    return _url;
}

-(id) requestArgument{
    return _params;
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
