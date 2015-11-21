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
        
        _call = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-60, 15, 50, 50)];
        [_call setImage:[UIImage imageNamed:@"电话按钮"] forState:UIControlStateNormal];
        
        UILabel *titltlab =[[UILabel alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 40)];
        titltlab.font =[UIFont systemFontOfSize:18];
        titltlab.textColor =CONTENT_COLOR;
        titltlab.textAlignment=NSTextAlignmentCenter;
        [self.contentView addSubview:titltlab];
        self.titleLab=titltlab;
        titltlab.hidden=YES;
        
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
-(void)setStatus:(int)status{
    _status =status;
    if (status==0) {
        //未接单
        self.titleLab.hidden=NO;
        self.call.hidden=YES;
        self.titleLab.text=@"等待接单";
    }
}
@end
