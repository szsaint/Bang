//
//  LoadMyOrders.h
//  iBang
//
//  Created by yyx on 15/8/10.
//  Copyright (c) 2015年 kiwi. All rights reserved.
//

#import "YTKRequest.h"

@interface LoadMyOrders : YTKRequest

- (id)initWithUrl:(NSString *) url;

- (id)responseJSONObject;

- (NSInteger)responseStatusCode;

@end
