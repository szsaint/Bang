//
//  MoneyCell.m
//  iBang
//
//  Created by yyx on 15/11/9.
//  Copyright © 2015年 kiwi. All rights reserved.
//

#import "MoneyCell.h"

@implementation MoneyCell

- (void)awakeFromNib {
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _jine = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-50, 5, 100, 45)];
        _jine.textAlignment = NSTextAlignmentCenter;
        _jine.font = [UIFont fontWithName:@"Arial" size:18.f];
        [_jine setTextColor:[UIColor blackColor]];
        
        _distance = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-50, 55, 100, 45)];
        _distance.textAlignment = NSTextAlignmentCenter;
        _distance.font = [UIFont fontWithName:@"Arial" size:12.f];
        [_distance setTextColor:[UIColor grayColor]];
        
        [self.contentView addSubview:_jine];
        [self.contentView addSubview:_distance];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
