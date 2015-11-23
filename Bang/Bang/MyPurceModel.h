//
//  MyPurceModel.h
//  BangDriver
//
//  Created by wl on 15/11/12.
//  Copyright © 2015年 saint. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyPurceModel : NSObject
@property (nonatomic,copy)NSString *getMoney;//获得的酬劳
@property (nonatomic,copy)NSString *time;//预约时间
@property (nonatomic,copy)NSString *place;//出发地
@property (nonatomic,copy)NSString *orderNumber;//订单号
+(instancetype)modelInitWithDic:(NSDictionary *)dic;

@end
