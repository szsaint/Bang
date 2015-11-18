//
//  MyPurceCell.h
//  BangDriver
//
//  Created by wl on 15/11/11.
//  Copyright © 2015年 saint. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, MyPurceCellType) {
    MyPurceCellTypePayOnline,          // 线上支付
    MyPurceCellTypeCash,               // 现金支付
    MyPurceCellTypeReward              // 各类奖励
};



@class MyPurceModel;

@interface MyPurceCell : UITableViewCell
@property (nonatomic,strong)MyPurceModel *model;


+(instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier;
@end
