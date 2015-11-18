//
//  MyPurceFootView.m
//  BangDriver
//
//  Created by wl on 15/11/12.
//  Copyright © 2015年 saint. All rights reserved.
//

#import "MyPurceFootView.h"
@interface MyPurceFootView ()
@property (nonatomic,strong)UIButton *richCash;//提现

@property (nonatomic,strong)UIButton *topUp;//充值

@property (nonatomic,strong)UIView *line;
@end

@implementation MyPurceFootView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setUpSubViews];
        self.backgroundColor=[UIColor whiteColor];
    }
    return self;
}
-(void)setUpSubViews{
    UIButton *richCash =[[UIButton alloc]init];
    [richCash setTitle:@"提现" forState:UIControlStateNormal];
    [richCash setTitleColor:CONTENT_COLOR forState:UIControlStateNormal];
    [richCash addTarget:self action:@selector(richBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.richCash=richCash;
    [self addSubview:richCash];
    
    
    UIButton *topUp =[[UIButton alloc]init];
    [topUp setTitle:@"充值" forState:UIControlStateNormal];
    [topUp setBackgroundColor:CONTENT_COLOR];
    [topUp setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [topUp addTarget:self action:@selector(topUpBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.topUp=topUp;
    [self addSubview:topUp];
    
    UIView *line =[[UIView alloc]init];
    line.backgroundColor=[UIColor grayColor];
    line.alpha=0.3;
    self.line=line;
    [self addSubview: line];
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat hh =self.frame.size.height;
    CGFloat ww =self.frame.size.width;
    self.richCash.frame=CGRectMake(0, 0, ww/2, hh);
    self.topUp.frame=CGRectMake(ww/2, 0, ww/2, hh);
    self.line.frame=CGRectMake(0, 0, ww, 0.5);
}
-(void)richBtnOnClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(MyPurceFootView:didSelectedRichCashBtn:)]) {
        [self.delegate MyPurceFootView:self didSelectedRichCashBtn:sender];
    }
}
-(void)topUpBtnOnClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(MyPurceFootView:didSelectedTopUp:)]) {
        [self.delegate MyPurceFootView:self didSelectedTopUp:sender];
    }
    
}
@end
