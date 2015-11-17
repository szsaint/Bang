//
//  CustomTableCell.h
//  iBang
//
//  Created by yyx on 15/7/7.
//  Copyright (c) 2015年 kiwi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableCell : UITableViewCell

@property (nonatomic,strong) UIImageView *titleImg;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIImageView *goImg;
@property (nonatomic,strong) UILabel *detailLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
