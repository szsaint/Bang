//
//  StarApi.h
//  iBang
//
//  Created by yyx on 15/9/6.
//  Copyright (c) 2015年 kiwi. All rights reserved.
//

#import "YTKRequest.h"

@interface StarApi : YTKRequest
- (id)initWithOrderId:(NSString *) orderId andComment:(NSString *)comment withScore:(CGFloat) score;

- (id)responseJSONObject;

- (NSInteger)responseStatusCode;
@end
