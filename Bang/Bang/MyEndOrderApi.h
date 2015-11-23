//
//  MyEndOrderApi.h
//  Bang
//
//  Created by wl on 15/11/19.
//  Copyright © 2015年 saint. All rights reserved.
//

#import "YTKRequest.h"

@interface MyEndOrderApi : YTKRequest

- (id) initWithUrl:(NSString *) url;
- (id) responseJSONObject;


@end
