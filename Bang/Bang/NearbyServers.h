//
//  NearbyServers.h
//  iBang
//
//  Created by yyx on 15/6/25.
//  Copyright (c) 2015年 kiwi. All rights reserved.
//  获取附近的人

#import "YTKRequest.h"

@interface NearbyServers : YTKRequest

- (id)initWithLng:(double) lng andLat:(double) lat andRange:(int) range andType:(NSString *) type;

- (id)responseJSONObject;

- (NSInteger)responseStatusCode;

@end
