//
//  DriveInfoCell.m
//  iBang
//
//  Created by yyx on 15/11/7.
//  Copyright © 2015年 kiwi. All rights reserved.
//

#import "DriveInfoCell.h"

@implementation DriveInfoCell

- (void)awakeFromNib {
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _avatar = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
        _avatar.layer.cornerRadius = _avatar.frame.size.height/2;
        _avatar.layer.masksToBounds = YES;
        
        _name = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, SCREEN_WIDTH-150, 60)];
        _name.textAlignment = NSTextAlignmentLeft;
        _name.font = [UIFont fontWithName:@"Arial" size:18.0];
        
        _call = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-60, 10, 50, 50)];
        [_call setImage:[UIImage imageNamed:@"电话按钮"] forState:UIControlStateNormal];
        
        [self.contentView addSubview:_avatar];
        [self.contentView addSubview:_name];
        [self.contentView addSubview:_call];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
