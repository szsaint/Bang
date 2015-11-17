//
//  SurePayApi.h
//  iBang
//
//  Created by yyx on 15/9/16.
//  Copyright (c) 2015年 kiwi. All rights reserved.
//

#import "YTKRequest.h"

@interface SurePayApi : YTKRequest

- (id)initWithOrderId:(NSString *) orderId;

- (id)responseJSONObject;

- (NSInteger)responseStatusCode;

@end
