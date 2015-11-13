//
//  AaptchaApi.h
//  iBang
//
//  Created by yyx on 15/7/12.
//  Copyright (c) 2015年 kiwi. All rights reserved.
//

#import "YTKRequest.h"

@interface AaptchaApi : YTKRequest

- (id) initWithPhone:(NSString *) phone;

- (id) responseJSONObject;

@end
