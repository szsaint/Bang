//
//  RouteCell.m
//  iBang
//
//  Created by yyx on 15/11/7.
//  Copyright © 2015年 kiwi. All rights reserved.
//

#import "RouteCell.h"

@implementation RouteCell

- (void)awakeFromNib {
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _from = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
        [_from setImage:[UIImage imageNamed:@"起点"]];
        _to = [[UIImageView alloc] initWithFrame:CGRectMake(10, 50, 30, 30)];
        [_to setImage:[UIImage imageNamed:@"终点"]];
        _fromTxt = [[UILabel alloc] initWithFrame:CGRectMake(45, 10, SCREEN_WIDTH-85, 30)];
        _fromTxt.textAlignment = NSTextAlignmentLeft;
        _fromTxt.font = [UIFont fontWithName:@"Arial" size:14.0];
        
        _toTxt = [[UILabel alloc] initWithFrame:CGRectMake(45, 50, SCREEN_WIDTH-85, 30)];
        _toTxt.textAlignment = NSTextAlignmentLeft;
        _toTxt.font = [UIFont fontWithName:@"Arial" size:14.0];
        
//        _go = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-40, 30, 30, 30)];
//        [_go setImage:[UIImage imageNamed:@"时间"]];
        
        [self.contentView addSubview:_from];
        [self.contentView addSubview:_to];
        [self.contentView addSubview:_fromTxt];
        [self.contentView addSubview:_toTxt];
 //       [self.contentView addSubview:_go];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
