//
//  LoadOrderDetail.h
//  iBang
//
//  Created by yyx on 15/10/2.
//  Copyright © 2015年 kiwi. All rights reserved.
//

#import "YTKRequest.h"

@interface LoadOrderDetail : YTKRequest

- (id)initWithOrderId:(NSString *) orderId;

- (id)responseJSONObject;

- (NSInteger)responseStatusCode;

@end
