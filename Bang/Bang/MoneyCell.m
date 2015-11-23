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
        _jine.font = [UIFont systemFontOfSize:22];//[UIFont fontWithName:@"Arial" size:18.f];
        [_jine setTextColor:[UIColor blackColor]];
        
        _distance = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-50, 55, 100, 45)];
        _distance.textAlignment = NSTextAlignmentCenter;
        _distance.font = [UIFont systemFontOfSize:20];//[UIFont fontWithName:@"Arial" size:12.f];
        [_distance setTextColor:[UIColor grayColor]];
        
        UILabel *titletab =[[UILabel alloc]initWithFrame:CGRectMake(0, 5, SCREEN_WIDTH, 100)];
        //titletab.text=@"正在为您代驾...";
        titletab.font =[UIFont systemFontOfSize:20];
        titletab.textColor=CONTENT_COLOR;
        titletab.textAlignment=NSTextAlignmentCenter;
        self.titlelab =titletab;
        [self.contentView addSubview:titletab];
        titletab.hidden=YES;
        
        [self.contentView addSubview:_jine];
        [self.contentView addSubview:_distance];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setStasus:(NSInteger)stasus{
    _stasus =stasus;
    if (_stasus==20) {
        self.titlelab.text=@"司机正在为您等待";
        self.titlelab.hidden=NO;
    }else{
        self.titlelab.text=@"正在为您代驾";
        self.titlelab.hidden=NO;
 
    }
}
@end
