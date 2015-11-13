//
//  LocationCommon.m
//  iBang
//
//  Created by yyx on 15/6/26.
//  Copyright (c) 2015年 kiwi. All rights reserved.
//

#import "LocationCommon.h"
#import "UpLoadMyLocation.h"

@implementation LocationCommon

/**
 上传用户自身的位置
 **/
+ (void)upLoadUserLocation:(CLLocation *) location{
    UpLoadMyLocation *upLoadLoacationApi = [[UpLoadMyLocation alloc] initLoactionWithLng:location];
    [upLoadLoacationApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request){
        if (request) {
            id result = [request responseJSONObject];
            float s = [result[@"rst"] floatValue];
            if (s == 0.0f) {
                NSLog(@"用户位置上传成功！");
            }
        }
    } failure:^(YTKBaseRequest *request){
        if (request) {
            id result = [request responseJSONObject];
            NSLog(@"用户位置上传失败！");
        }
    }];
}

@end
