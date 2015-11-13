//
//  GetUserInfoApi.h
//  iBang
//
//  Created by 龙斐 on 15/6/24.
//  Copyright (c) 2015年 kiwi. All rights reserved.
//

#import "YTKRequest.h"

@interface GetUserInfoApi : YTKRequest

- (id)initWithUserId:(NSString *)userId;

@end
