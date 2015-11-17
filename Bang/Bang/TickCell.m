//
//  TickCell.m
//  iBang
//
//  Created by yyx on 15/8/27.
//  Copyright (c) 2015年 kiwi. All rights reserved.
//

#import "TickCell.h"

@implementation TickCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *bl = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, (SCREEN_WIDTH-10)/3*2, 90)];
        bl.image = [UIImage imageNamed:@"优惠券背景左"];
        _name = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, (SCREEN_WIDTH-10)/3*2-10, 70)];
        [_name setTextColor:RGB(41, 140, 88, 1)];
        _name.font = [UIFont fontWithName:@"Arial" size:28.0f];
        _name.textAlignment = NSTextAlignmentCenter;
        UIImageView *br = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-10)/3*2+5, 5, (SCREEN_WIDTH-10)/3, 90)];
        br.image = [UIImage imageNamed:@"优惠券背景右"];
        _time = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-10)/3*2+10, 10, (SCREEN_WIDTH-10)/3-10, 80)];
        [_time setTextColor:[UIColor lightGrayColor]];
        _time.font = [UIFont fontWithName:@"Arial" size:14.0f];
        _time.textAlignment = NSTextAlignmentCenter;
        _time.numberOfLines = 3;
        //        [bl addSubview:_name];
//        [br addSubview:_time];
//        [bl bringSubviewToFront:_name];
//        [br bringSubviewToFront:_time];
        [self.contentView addSubview:bl];
        [self.contentView addSubview:br];
        [self.contentView addSubview:_name];
        [self.contentView addSubview:_time];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    if (highlighted) {
        self.backgroundColor = RGB(41, 140, 88, 1);
        
    }else{
        self.backgroundColor =  RGB(19, 20, 37, 1);
    }
}


@end
