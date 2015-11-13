//
//  UserLoginApi.h
//  iBang
//
//  Created by 龙斐 on 15/6/24.
//  Copyright (c) 2015年 kiwi. All rights reserved.
//

#import "YTKRequest.h"

@interface UserLoginApi : YTKRequest

- (id)initWithUsername:(NSString *)username password:(NSString *)password;

- (id) responseJSONObject;

- (NSInteger)responseStatusCode;

- (NSDictionary *)responseHeaders;

@end
