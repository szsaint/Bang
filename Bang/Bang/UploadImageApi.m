//
//  UploadImageApi.m
//  iBang
//
//  Created by yyx on 15/7/15.
//  Copyright (c) 2015年 kiwi. All rights reserved.
//

#import "UploadImageApi.h"

@implementation UploadImageApi{
    UIImage *_image;
}

- (id)initWithImage:(UIImage *)image {
    self = [super init];
    if (self) {
        _image = image;
    }
    return self;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (NSString *)requestUrl {
    return @"/upload";
}


- (AFConstructingBlock)constructingBodyBlock {
    return ^(id<AFMultipartFormData> formData) {
        NSData *data = UIImageJPEGRepresentation(_image, 0.9);
        NSString *name = @"file";
        NSString *formKey = @"file";
        NSString *type = @"image/jpg";
        [formData appendPartWithFileData:data name:formKey fileName:name mimeType:type];
    };
}

//请求头示例
//所有接口调用时需要设置header X-Requested-With:XMLHttpRequest
//默认发送方法 application/x-www-form-urlencoded
//在发送文件时 multipart/form-data
-(NSDictionary *) requestHeaderFieldValueDictionary{
    NSDictionary *headerDic = [NSDictionary dictionaryWithObjectsAndKeys:@"XMLHttpRequest",@"X-Requested-With",@"multipart/form-data",@"Content-Type", nil];
    //所有请求都必须设置
    //    [headerDic setValue:@"XMLHttpRequest" forKey:@"X-Requested-With"];
    //默认发送 设置
    //    [headerDic setValue:@"application/x-www-form-urlencoded" forKey:@"Content-Type"];
    //文件上传／发送 设置,注册登录为默认发送，所以注释
    //[headerDic setValue:@"multipart/form-data" forKey:@"Content-Type"];
    return headerDic;
}

- (id)responseJSONObject {
    return self.requestOperation.responseObject;
}


@end
