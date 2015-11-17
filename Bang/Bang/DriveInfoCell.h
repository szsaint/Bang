//
//  DriveInfoCell.h
//  iBang
//
//  Created by yyx on 15/11/7.
//  Copyright © 2015年 kiwi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DriveInfoCell : UITableViewCell

@property (nonatomic,strong) UIImageView *avatar;
@property (nonatomic,strong) UILabel *name;
@property (nonatomic,strong) UIButton *call;
@property (nonatomic,strong) NSString *phone;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
