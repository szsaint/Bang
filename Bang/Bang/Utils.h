//
//  Utils.h
//  iBang
//
//  Created by yyx on 15/8/27.
//  Copyright (c) 2015年 kiwi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

+(BOOL)valueIsNull:(id)object;

+(NSString *)StatusString:(NSUInteger) status;

+(NSString *)driverBtnStatusString:(NSUInteger)status;

+(NSString *)clinetBtnStatusString:(NSUInteger)status;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

@end
