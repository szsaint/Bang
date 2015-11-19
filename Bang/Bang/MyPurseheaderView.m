//
//  MyPurseheaderView.m
//  BangDriver
//
//  Created by wl on 15/11/11.
//  Copyright © 2015年 saint. All rights reserved.
//

#import "MyPurseheaderView.h"
#define MoneyFont     [UIFont systemFontOfSize:18]

@interface MyPurseheaderView ()

@property (nonatomic,strong)UILabel *totalTitle;
@property (nonatomic,strong)UILabel *titleStand;

@property (nonatomic,strong)UILabel *cashTitle;
@property (nonatomic,strong)UILabel *cashStand;


@end

@implementation MyPurseheaderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor =[UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:0.7];
        [self setUpSubViews];
    }
    return self;
}
-(void)setUpSubViews{
    self.totalTitle =[self creatCenterAlimentLab];
    self.totalTitle.text=@"总金额";
    [self addSubview:self.totalTitle];
    
    self.titleStand=[self creatCenterAlimentLab];
    self.titleStand.text=@"元";
    [self addSubview:self.titleStand];
    
    
//    self.cashTitle=[self creatCenterAlimentLab];
//    self.cashTitle.text=@"可提现";
//    [self addSubview:self.cashTitle];
//    
//    self.cashStand=[self creatCenterAlimentLab];
//    self.cashStand.text=@"元";
//    [self addSubview:self.cashStand];
//    
    
    self.totalMoney =[[UILabel alloc]init];
    self.totalMoney.font =[UIFont systemFontOfSize:20];
    self.totalMoney.textAlignment =NSTextAlignmentCenter;
    self.totalMoney.textColor=CONTENT_COLOR;
    [self addSubview:self.totalMoney];
    
//    self.cashMoney =[[UILabel alloc]init];
//    self.cashMoney.font =[UIFont systemFontOfSize:20];
//    self.cashMoney.textAlignment =NSTextAlignmentCenter;
//    self.cashMoney.textColor=CONTENT_COLOR;
//    [self addSubview:self.cashMoney];
//    
    
}

-(UILabel *)creatCenterAlimentLab{
    UILabel *lab =[[UILabel alloc]init];
    lab.font=[UIFont systemFontOfSize:12];
    lab.textAlignment=NSTextAlignmentCenter;
    lab.textColor=[UIColor grayColor];
    return lab;
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

+(instancetype)purseHeaderWithTotalMoney:(NSString *)tottalMoney cashMoney:(NSString *)cashMoney{
    MyPurseheaderView *header =[[MyPurseheaderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    CGFloat margin =20;
    header.totalMoney.frame =CGRectMake(margin, 32, SCREEN_WIDTH-2*margin, 36);
    header.totalTitle.frame =CGRectMake(margin, 12, SCREEN_WIDTH-2*margin, 20);
    header.titleStand.frame =CGRectMake(margin, 100-12-20, SCREEN_WIDTH-2*margin, 20);
    
//    CGFloat xx =SCREEN_WIDTH/2+margin;
//    header.cashMoney.frame=CGRectMake(xx, 32,  SCREEN_WIDTH/2-2*margin, 36);
//    header.cashTitle.frame =CGRectMake(xx, 12,  SCREEN_WIDTH/2-2*margin, 20);
//    header.cashStand.frame =CGRectMake(xx, 100-12-20,  SCREEN_WIDTH/2-2*margin, 20);
    
    header.totalMoney.text=tottalMoney;
//    header.cashMoney.text=cashMoney;
    
    return header;
}








@end
