//
//  RechargeApi.h
//  Bang
//
//  Created by wl on 15/11/19.
//  Copyright © 2015年 saint. All rights reserved.
//

#import "YTKRequest.h"
@interface RechargeApi : YTKRequest
- (id) initWithInfo:(NSDictionary *) info;
- (id) responseJSONObject;
@end
