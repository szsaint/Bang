//
//  StartWaitingApi.h
//  iBang
//
//  Created by yyx on 15/6/26.
//  Copyright (c) 2015年 kiwi. All rights reserved.
//

#import "YTKRequest.h"

@interface StartWaitingApi : YTKRequest

- (id)initWithServerId:(NSString *)serverId;

- (id)responseJSONObject;

- (NSInteger)responseStatusCode;

@end
