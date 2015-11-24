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
        _jine = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-100, 5, 200, 45)];
        _jine.textAlignment = NSTextAlignmentCenter;
        _jine.font = [UIFont systemFontOfSize:28];//[UIFont fontWithName:@"Arial" size:18.f];
        [_jine setTextColor:CONTENT_COLOR];
        
        _distance = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-100, 50, 200, 30)];
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
        
        
        UIButton *orederDetail =[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-40, 90, 80, 20)];
        [orederDetail setTitle:@"查看明细" forState:UIControlStateNormal];
        [orederDetail setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        orederDetail.titleLabel.font=[UIFont systemFontOfSize:13];
        [orederDetail addTarget:self action:@selector(orderDetailBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        orederDetail.hidden=YES;
        self.orderDetail =orederDetail;
        [self.contentView addSubview:orederDetail];
        
        
        
        [self.contentView addSubview:_jine];
        [self.contentView addSubview:_distance];
    }
    return self;
}
-(void)orderDetailBtnOnClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(MoneyCell:orederDetailOnClick:)]) {
        [self.delegate MoneyCell:self orederDetailOnClick:sender];
    }
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
