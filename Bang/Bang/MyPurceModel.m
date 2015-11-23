//
//  MyPurceModel.m
//  BangDriver
//
//  Created by wl on 15/11/12.
//  Copyright © 2015年 saint. All rights reserved.
//

#import "MyPurceModel.h"

@implementation MyPurceModel
+(instancetype)modelInitWithDic:(NSDictionary *)dic{
    MyPurceModel *model  =[[self alloc]init];
    model.time =dic[@"created_at"];
    model.place=dic[@"address"];
    model.orderNumber=dic[@"sn"];
    model.getMoney=[NSString stringWithFormat:@"-%@",dic[@"actual_price"]];
    return model;
}
@end
