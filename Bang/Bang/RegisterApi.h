//
//  RegisterApi.h
//  iBang
//
//  Created by 龙斐 on 15/6/10.
//  Copyright (c) 2015年 kiwi. All rights reserved.
//

#import "YTKRequest.h"

@interface RegisterApi : YTKRequest

- (id)initWithPhoneNumber:(NSString *)phoneNumber andCaptCha:(NSString *) captcha andPwd:(NSString *) pwd;

- (id) responseJSONObject;

- (NSInteger)responseStatusCode;

@end
