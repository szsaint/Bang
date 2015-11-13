//
//  LocationCommon.h
//  iBang
//
//  Created by yyx on 15/6/26.
//  Copyright (c) 2015年 kiwi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>

@interface LocationCommon : NSObject

+ (void)upLoadUserLocation:(MAUserLocation *) location;

@end
