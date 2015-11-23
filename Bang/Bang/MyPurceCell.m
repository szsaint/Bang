//
//  MyPurceCell.m
//  BangDriver
//
//  Created by wl on 15/11/11.
//  Copyright © 2015年 saint. All rights reserved.
//

#import "MyPurceCell.h"
#import "MyPurceModel.h"

#define leftW     SCREEN_WIDTH/320.0f*70
#define cellH     90
#define labColor [UIColor grayColor]

@interface MyPurceCell ()
@property (nonatomic,strong)UILabel *getMoney;//获得的酬劳

@property (nonatomic,strong)UILabel *time;//所得酬劳时间

@property (nonatomic,strong)UILabel *place;//从哪里获得酬劳

//@property (nonatomic,strong)NSMutableArray *labArray;

@property (nonatomic,strong)UILabel *orderNumber;//订单号



@end

@implementation MyPurceCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+(instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier{
    MyPurceCell *cell =[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell =[[MyPurceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpSubViews];
    }
    return self;
}

-(void)setUpSubViews{
    
    UIView *line =[[UIView alloc]initWithFrame:CGRectMake(leftW, 0, 0.5, cellH-20)];
    line.backgroundColor =[UIColor grayColor];
    line.alpha=0.3;
    [self.contentView addSubview:line];
    CGFloat margin = 10;
    self.getMoney =[[UILabel alloc]initWithFrame:CGRectMake(margin, 0, leftW-2*margin, cellH)];
    self.getMoney.textColor =CONTENT_COLOR;
    self.getMoney.font=[UIFont systemFontOfSize:15];
    self.getMoney.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview:self.getMoney];
    CGFloat maxW =SCREEN_WIDTH-leftW-2*margin;
    //出发地点
    self.place =[[UILabel alloc]initWithFrame:CGRectMake(leftW+margin, 0,maxW, 30)];
    self.place.font =[UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.place];

    //预约时间
    self.time=[self creatGraylab];
    self.time.frame=CGRectMake(leftW+margin,30, maxW, 30);
    [self.contentView addSubview:self.time];
    //订单号
    self.orderNumber =[[UILabel alloc]initWithFrame:CGRectMake(leftW+margin, 65, maxW, 20)];
    self.orderNumber.font =[UIFont systemFontOfSize:12];
    self.orderNumber.textColor=labColor;
    [self.contentView addSubview:self.orderNumber];

    
    
}
-(UILabel *)creatGraylab{
    UILabel *lab =[[UILabel alloc]init];
    lab.font=[UIFont systemFontOfSize:15];
    return lab;
}


-(void)setModel:(MyPurceModel *)model{
    _model =model;
    self.getMoney.text=model.getMoney;
    self.time.text =[NSString stringWithFormat:@"预约时间：%@",model.time];
    self.place.text=[NSString stringWithFormat:@"出发地点：%@",model.place];
    self.orderNumber.text=[NSString stringWithFormat:@"订单号：%@",model.orderNumber];
   
}

@end
