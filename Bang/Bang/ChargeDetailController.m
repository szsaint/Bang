//
//  ChargeDetailController.m
//  Bang
//
//  Created by wl on 15/11/24.
//  Copyright © 2015年 saint. All rights reserved.
//

#import "ChargeDetailController.h"
#define marginLeft  40

@interface ChargeDetailController ()

@end

@implementation ChargeDetailController{
    NSArray *_leftArray;
    NSArray *_rightArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    self.title=@"费用明细";
    if (self.chargeArray) {
        
        CGFloat start_distance =[[self.chargeArray valueForKey:@"start_distance"] integerValue]/1000.00;
        NSString *startStr =[NSString stringWithFormat:@"起步里程(%.2f公里)",start_distance];
        
        NSString *wait_time =[self.chargeArray valueForKey:@"wait_time"];
        NSString *waitStr =[NSString stringWithFormat:@"等待时间(%@分钟)",wait_time];
        
        
        CGFloat work_distance =[[self.chargeArray valueForKey:@"work_distance"] integerValue]/1000.00;
        NSString *workStr =[NSString stringWithFormat:@"后续里程(%.2f)",work_distance];
        
        NSString *start_cost =[NSString stringWithFormat:@"%@元",[self.chargeArray valueForKey:@"start_cost"]];
        NSString *wait_cost =[NSString stringWithFormat:@"%@元",[self.chargeArray valueForKey:@"wait_cost"]];
        NSString *work_cost =[NSString stringWithFormat:@"%@元",[self.chargeArray valueForKey:@"work_cost"]];
        
        if ([self.chargeArray valueForKey:@"discount"]&&[self.chargeArray valueForKey:@"discount"]!=[NSNull null]) {
            NSString *discount =[self.chargeArray valueForKey:@"discount"];
            NSString *disCountStr =@"优惠折扣";
            _leftArray =@[startStr,waitStr,workStr,disCountStr];
            _rightArray=@[start_cost,wait_cost,work_cost,discount];
        }else{
            _leftArray =@[startStr,waitStr,workStr,@"优惠折扣"];
            _rightArray=@[start_cost,wait_cost,work_cost,@"-0.00元"];

        }
        
    }

    [self setUI];
}
//起步里程(3公里)
//等待时间(等待时间)
//后续里程(公里)
//优惠券..
//实际费用
//"order_id": "142", "wait_time": "148.00", "wait_cost": "80.00", "start_distance": "3000.00", "start_cost": "39.00", "work_time": "3.00", "work_distance": "5888.00", "work_cost": "20.00", "ticket_id": "13", "initial_price": "139.00", "actual_price": "139.00", "payment_id": "3", "result": "1" }
-(void)setUI{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake( 20, 20, 44, 44);
    [backBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;

    
    UIView *back =[[UIView alloc]init];
    back.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:back];
    CGFloat ww =SCREEN_WIDTH-2*marginLeft;
    UILabel *actulPrice =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, ww, 80)];
    actulPrice.textColor=CONTENT_COLOR;
    actulPrice.font=[UIFont systemFontOfSize:40];
    actulPrice.textAlignment=NSTextAlignmentCenter;
    NSString *str =[NSString stringWithFormat:@"%@元",[self.chargeArray valueForKey:@"actual_price"]];
    actulPrice.attributedText=[self creatAttributeStr:str];
    [back addSubview:actulPrice];

    for (int i =0; i<4; i++) {
        UILabel *lab =[self creatLeftLab];
        lab.text=_leftArray[i];
        lab.frame=CGRectMake(0, 120+20*i, ww/2+50, 20);
        [back addSubview:lab];
        
        UILabel *lab2 =[self creatRightLab];
        lab2.text=_rightArray[i];
        lab2.frame =CGRectMake(ww/2+50,120+20*i, ww/2-50, 20);
        [back addSubview:lab2];
        if (i==3) {
            lab.textColor=CONTENT_COLOR;
            lab2.textColor=CONTENT_COLOR;
            CGFloat yy =CGRectGetMaxY(lab2.frame);
            back.frame=CGRectMake(0, 0, ww, yy+10);
            back.center=self.view.center;
            
        }
    }
    
    
    
}

-(UILabel *)creatLeftLab{
    UILabel *lab =[[UILabel alloc]init];
    lab.textAlignment=NSTextAlignmentLeft;
    lab.font=[UIFont systemFontOfSize:14];
    return lab;
}

-(UILabel *)creatRightLab{
    UILabel *lab =[[UILabel alloc]init];
    lab.textAlignment=NSTextAlignmentRight;
    lab.font=[UIFont systemFontOfSize:14];
    return lab;
}

- (void)backButtonPressed:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSAttributedString *)creatAttributeStr:(NSString *)str{
    if (str==nil||str.length<2)
       return nil;
    NSInteger length =str.length;
    NSString *forwardStr =[str substringToIndex:length-1];
    NSString *lastStr =[str substringFromIndex:length-1];
    
    NSMutableAttributedString *att =[[NSMutableAttributedString alloc]initWithString:str];
    
    NSDictionary * attributesForLastWord = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:40.0f],
                                             NSForegroundColorAttributeName: CONTENT_COLOR};
    
        NSDictionary * attributeslastWord = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],NSForegroundColorAttributeName: [UIColor blackColor]};
        // 设置文字样式
        [att setAttributes:attributeslastWord range:[str rangeOfString:lastStr]];
        [att setAttributes:attributesForLastWord range:[str rangeOfString:forwardStr]];
    
        // 返回已经设置好了的带有样式的文字
    return [[NSAttributedString alloc] initWithAttributedString:att];
    
    
    return att;
}

@end
