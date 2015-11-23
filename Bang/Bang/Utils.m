//
//  Utils.m
//  iBang
//
//  Created by yyx on 15/8/27.
//  Copyright (c) 2015年 kiwi. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+(BOOL)valueIsNull:(id)object{
    if (object != [NSNull null]) {
        return YES;
    }else{
        return NO;
    }
}

/**
 *获取订单状态的文字描述
 */
+(NSString *)StatusString:(NSUInteger)status{
    NSString *s = @"";
    switch (status) {
        case 0:
            s=@"等待接单";
            break;
        case 10:
            s=@"已接单";
            break;
        case 20:
            s=@"等待客户上车";
            break;
        case 30:
            s=@"代驾中";
            break;
        case 40:
            s=@"代驾完成";
            break;
        case 50:
            s=@"待支付";
            break;
        case 58:
            s=@"已支付";
            break;
        case 60:
            s=@"服务结束";
            break;
        case 100:
            s=@"订单完成";
            break;
            
        default:
            break;
    }
    return s;
}

/**
 *司机的操作按钮的文字描述
 */
+(NSString *)driverBtnStatusString:(NSUInteger)status{
    NSString *s = @"";
    switch (status) {
        case 0:
            s=@"接单";
            break;
        case 10:
            s=@"开始等待";
            break;
        case 20:
            s=@"开始代驾";
            break;
        case 30:
            s=@"完成代驾";
            break;
        case 40:
            s=@"确认支付";
            break;
        case 50:
            s=@"确认支付";
            break;
        case 58:
            s=@"订单完成";
            break;
        case 60:
            s=@"订单完成";
            break;
        case 100:
            s=@"订单完成";
            break;
            
        default:
            break;
    }
    return s;
}

/**
 *用户的操作按钮的文字描述
 */
+(NSString *)clinetBtnStatusString:(NSUInteger)status{
    NSString *s = @"";
    switch (status) {
        case 0:
            s=@"等待接单";
            break;
        case 10:
            s=@"等您上车";
            break;
        case 20:
            s=@"代驾开始";
            break;
        case 30:
            s=@"代驾中";
            break;
        case 40:
            s=@"去支付";
            break;
        case 50:
            s=@"去支付";
            break;
        case 58:
            s=@"评价一下";
            break;
        case 60:
            s=@"服务结束";
            break;
        case 100:
            s=@"订单完成";
            break;
            
        default:
            break;
    }
    return s;
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
        UIGraphicsBeginImageContext(rect.size);
    
        CGContextRef context = UIGraphicsGetCurrentContext();
    
        CGContextSetFillColorWithColor(context, [color CGColor]);
    
        CGContextFillRect(context, rect);
    
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
        UIGraphicsEndImageContext();
    
        return image;
    
    }

/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

@end
