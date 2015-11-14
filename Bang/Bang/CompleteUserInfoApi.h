//
//  CompleteUserInfoApi.h
//  iBang
//
//  Created by yyx on 15/7/15.
//  Copyright (c) 2015年 kiwi. All rights reserved.
//

#import "YTKRequest.h"

@interface CompleteUserInfoApi : YTKRequest

- (id) initWithInfo:(NSDictionary *) info;
- (id) responseJSONObject;

@end
