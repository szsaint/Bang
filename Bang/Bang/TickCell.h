//
//  TickCell.h
//  iBang
//
//  Created by yyx on 15/8/27.
//  Copyright (c) 2015年 kiwi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TickCell : UITableViewCell

@property (nonatomic,strong) NSString *tickId;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) UILabel *time;
@property (nonatomic,strong) UILabel *name;
@property (nonatomic,strong) UILabel *desc;

-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
