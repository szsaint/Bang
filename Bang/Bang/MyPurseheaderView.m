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

@property (nonatomic,strong)UILabel *totalMoney;//总金额
@property (nonatomic,strong)UILabel *cashMoney;//可提现金额

//@property (nonatomic,strong)UIView *onlineView;
//@property (nonatomic,strong)UILabel *onlineMoney;//线上金额
//@property (nonatomic,strong)UIView *line;


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
    
    
    self.cashTitle=[self creatCenterAlimentLab];
    self.cashTitle.text=@"可提现";
    [self addSubview:self.cashTitle];
    
    self.cashStand=[self creatCenterAlimentLab];
    self.cashStand.text=@"元";
    [self addSubview:self.cashStand];
    
    
    self.totalMoney =[[UILabel alloc]init];
    self.totalMoney.font =[UIFont systemFontOfSize:18];
    self.totalMoney.textAlignment =NSTextAlignmentRight;
    self.totalMoney.textColor=CONTENT_COLOR;
    [self addSubview:self.totalMoney];
    
    self.cashMoney =[[UILabel alloc]init];
    self.cashMoney.font =[UIFont systemFontOfSize:18];
    self.cashMoney.textAlignment =NSTextAlignmentLeft;
    self.cashMoney.textColor=CONTENT_COLOR;
    [self addSubview:self.cashMoney];
    
//    self.onlineView =[[UIView alloc]init];
//    self.onlineView.backgroundColor =[UIColor whiteColor];
//    [self addSubview:self.onlineView];
//    self.onlineMoney=[[UILabel alloc]init];
//    self.onlineMoney.font=[UIFont systemFontOfSize:14];
//    [self.onlineView addSubview:self.onlineMoney];
//    self.line =[[UIView alloc]init];
//    self.line.backgroundColor=[UIColor grayColor];
//    self.line.alpha=0.2;
//    [self.onlineView addSubview:self.line];
    
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
//    self.onlineView.frame=CGRectMake(0, 100, SCREEN_WIDTH, 35);
//    self.onlineMoney.frame=CGRectMake(12, 0, SCREEN_WIDTH-24, 35);
//    self.line.frame=CGRectMake(0, 34, SCREEN_WIDTH, 0.5);
}

+(instancetype)purseHeaderWithTotalMoney:(NSString *)tottalMoney cashMoney:(NSString *)cashMoney{
    MyPurseheaderView *header =[[MyPurseheaderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    CGFloat margin =20;
    CGSize moneyS =[tottalMoney sizeWithAttributes:@{NSFontAttributeName:MoneyFont}];
    header.totalMoney.frame =CGRectMake(SCREEN_WIDTH/2-margin-moneyS.width, (100-moneyS.height)/2, moneyS.width, moneyS.height);
    header.totalTitle.frame =CGRectMake(SCREEN_WIDTH/2-margin-moneyS.width, 12, moneyS.width, 20);
    header.titleStand.frame =CGRectMake(SCREEN_WIDTH/2-margin-moneyS.width, 100-12-20, moneyS.width, 20);
    
    CGSize cashS =[cashMoney sizeWithAttributes:@{NSFontAttributeName:MoneyFont}];
    CGFloat xx =SCREEN_WIDTH/2+margin;
    header.cashMoney.frame=CGRectMake(xx, (100-cashS.height)/2, cashS.width, cashS.height);
    header.cashTitle.frame =CGRectMake(xx, 12, cashS.width, 20);
    header.cashStand.frame =CGRectMake(xx, 100-12-20, cashS.width, 20);
    
    header.totalMoney.text=tottalMoney;
    header.cashMoney.text=cashMoney;
   // header.onlineMoney.text=[NSString stringWithFormat:@"线上收入：%@",onlineMoney];
    
    return header;
}








@end
