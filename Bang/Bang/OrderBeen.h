//
//  OrderBeen.h
//  iBang
//
//  Created by yyx on 15/10/2.
//  Copyright © 2015年 kiwi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderBeen : NSObject

@property (strong,nonatomic) NSString *orderId;
@property (strong,nonatomic) NSString *serverId;
@property (strong,nonatomic) NSString *clientId;
@property (strong,nonatomic) NSString *appointTime;
@property (strong,nonatomic) NSString *from;
@property (strong,nonatomic) NSString *to;
@property (strong,nonatomic) NSString *aPrice;
@property (strong,nonatomic) NSString *distance;
@property (strong,nonatomic) NSString *timelen;
@property (nonatomic) NSUInteger status;
@property (nonatomic) BOOL isMeCreateOrder;
@property (nonatomic) BOOL isToMeOrder;

@end
