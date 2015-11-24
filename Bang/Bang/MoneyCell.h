//
//  MoneyCell.h
//  iBang
//
//  Created by yyx on 15/11/9.
//  Copyright © 2015年 kiwi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MoneyCell;
@protocol MoneyCellDelegate <NSObject>

-(void)MoneyCell:(MoneyCell *)cell orederDetailOnClick:(UIButton *)sender;

@end
@interface MoneyCell : UITableViewCell

@property (nonatomic,strong) UILabel *jine;
@property (nonatomic,strong) UILabel *distance;
@property (nonatomic,strong) UILabel *titlelab;
@property (nonatomic,strong) UIButton *orderDetail;//查看明细

@property (nonatomic,assign)NSInteger stasus;
@property (nonatomic,weak)id<MoneyCellDelegate>delegate;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
