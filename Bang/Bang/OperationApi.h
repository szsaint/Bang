//
//  OperationApi.h
//  iBang
//
//  Created by yyx on 15/11/7.
//  Copyright © 2015年 kiwi. All rights reserved.
//

#import "YTKRequest.h"

@interface OperationApi : YTKRequest

- (id)initWithUrl:(NSString *)url params:(NSDictionary *) params;

- (id)responseJSONObject;

- (NSInteger)responseStatusCode;

@end
