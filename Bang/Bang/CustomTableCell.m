//
//  CustomTableCell.m
//  iBang
//
//  Created by yyx on 15/7/7.
//  Copyright (c) 2015年 kiwi. All rights reserved.
//

#import "CustomTableCell.h"

@implementation CustomTableCell
@synthesize titleImg = _titleImg;
@synthesize titleLabel = _titleLabel;
@synthesize goImg = _goImg;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 45);
        _titleImg = [[UIImageView alloc] initWithFrame:CGRectMake(8, 5, 35, 35)];
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(51, 5, SCREEN_WIDTH-102, 35)];
        [_titleLabel setTextColor:[UIColor blackColor]];
        [_titleLabel setHighlightedTextColor:[UIColor whiteColor]];
        _goImg = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-51, 5, 35, 35)];
        [_goImg setImage:[UIImage imageNamed:@"gocell"]];
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-110, 5, 90, 35)];
        [_detailLabel setTextColor:[UIColor blackColor]];
        _detailLabel.textAlignment = NSTextAlignmentRight;
        [_detailLabel setHighlightedTextColor:[UIColor whiteColor]];
        _detailLabel.hidden = YES;
        [self.contentView addSubview:_titleImg];
        [self.contentView addSubview:_titleLabel];
        [self.contentView addSubview:_goImg];
        [self.contentView addSubview:_detailLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    if (highlighted) {
        self.backgroundColor = RGB(41, 140, 88, 1);
        [_titleLabel setTextColor:[UIColor whiteColor]];
        [_detailLabel setTextColor:[UIColor whiteColor]];
        
    }else{
        self.backgroundColor = [UIColor whiteColor];
        [_titleLabel setTextColor:[UIColor blackColor]];
        [_detailLabel setTextColor:[UIColor blackColor]];
        
    }
}

@end
