//
//  AppointTimeCell.m
//  iBang
//
//  Created by yyx on 15/11/7.
//  Copyright © 2015年 kiwi. All rights reserved.
//

#import "AppointTimeCell.h"

@implementation AppointTimeCell

- (void)awakeFromNib {
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 20, 20)];
        [_icon setImage:[UIImage imageNamed:@"时间"]];
        _time = [[UILabel alloc] initWithFrame:CGRectMake(45, 10, SCREEN_WIDTH-45, 30)];
        _time.textAlignment = NSTextAlignmentLeft;
        _time.font = [UIFont fontWithName:@"Arial" size:14.0];
        
        [self.contentView addSubview:_icon];
        [self.contentView addSubview:_time];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
