//
//  GetPayOrder.h
//  Bang
//  获取支付订单信息
//  Created by wl on 15/11/23.
//  Copyright © 2015年 saint. All rights reserved.
//

#import "YTKRequest.h"

@interface GetPayOrder : YTKRequest
- (id)initWithOrderId:(NSString *)orderID;

- (id)responseJSONObject;

- (NSInteger)responseStatusCode;

@end
