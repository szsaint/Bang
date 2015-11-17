//
//  AppointTimeCell.h
//  iBang
//
//  Created by yyx on 15/11/7.
//  Copyright © 2015年 kiwi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppointTimeCell : UITableViewCell

@property (nonatomic,strong) UIImageView *icon;
@property (nonatomic,strong) UILabel *time;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
