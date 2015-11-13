//
//  UpLoadMyLocation.h
//  iBang
//
//  Created by yyx on 15/6/25.
//  Copyright (c) 2015年 kiwi. All rights reserved.
//

#import "YTKRequest.h"
#import <MAMapKit/MAMapKit.h>

@interface UpLoadMyLocation : YTKRequest

- (id)initLoactionWithLng:(MAUserLocation *) location;

- (id)responseJSONObject;

- (NSInteger)responseStatusCode;

@end
