//
//  CreateOrder.h
//  iBang
//
//  Created by yyx on 15/6/26.
//  Copyright (c) 2015年 kiwi. All rights reserved.
//

#import "YTKRequest.h"

@interface CreateOrder : YTKRequest

- (id)initWithOrder:(NSMutableDictionary *)order;

- (id)responseJSONObject;

- (NSInteger)responseStatusCode;

@end
