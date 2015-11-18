//
//  RichCashController.m
//  BangDriver
//
//  Created by wl on 15/11/12.
//  Copyright © 2015年 saint. All rights reserved.
//

#import "RichCashController.h"
#define topMargin  SCREEN_HEIGHT/480*155.0f

@interface RichCashController ()
@property (nonatomic,strong)UITextField *cashTextField;
@property (nonatomic,strong)UITextField *passWordTextField;
@property (nonatomic,strong)UILabel *canRichCash;//可提现金额

@end

@implementation RichCashController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

-(void)setUI{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake( 20, 20, 44, 44);
    [backBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tap];
    
    UILabel *canRichCashTitle =[[UILabel alloc]initWithFrame:CGRectMake(50, 64+20, SCREEN_WIDTH-100, 25)];
    canRichCashTitle.font=[UIFont systemFontOfSize:15];
    canRichCashTitle.textColor=[UIColor grayColor];
    canRichCashTitle.text=@"可提现金额";
    canRichCashTitle.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:canRichCashTitle];
    
    UILabel *canRichCash =[[UILabel alloc]initWithFrame:CGRectMake(50, 64+20+25, SCREEN_WIDTH-100, 30)];
    canRichCash.font =[UIFont systemFontOfSize:20];
    canRichCash.textAlignment=NSTextAlignmentCenter;
    canRichCash.textColor=CONTENT_COLOR;
    canRichCash.text=@"1000.00";
    [self.view addSubview:canRichCash];
    self.canRichCash =canRichCash;
    
    
    self.view.backgroundColor =[UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
    CGFloat marginLeft =12;
    NSArray *titleArr =@[@"提现金额:",@"登陆密码:"];
    for (int i =0; i<2; i++) {
        UILabel *titleLab  =[[UILabel alloc]initWithFrame:CGRectMake(marginLeft, topMargin+70*i, 80, 50)];
        titleLab.text=titleArr[i];
        [self.view addSubview:titleLab];
        
        UITextField *textfield =[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLab.frame)+8, topMargin+70*i+3, SCREEN_WIDTH-marginLeft-88-marginLeft, 44)];
        [textfield setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
        textfield.backgroundColor=[UIColor whiteColor];
        textfield.layer.cornerRadius=6.0;
        textfield.layer.masksToBounds=YES;
        textfield.tintColor=[UIColor grayColor];
        if (i==0) {
            textfield.keyboardType=UIKeyboardTypeNumberPad;
            textfield.placeholder=@" 输入提现金额";
            self.cashTextField=textfield;
        }else{
            textfield.keyboardType=UIKeyboardTypeASCIICapable;
            textfield.placeholder=@" 输入登陆密码";
            textfield.secureTextEntry=YES;
            self.passWordTextField=textfield;
        }
        [self.view addSubview:textfield];
    }
    
    //topUP  提现
    UIButton *topUpBtn =[[UIButton alloc]initWithFrame:CGRectMake(30, SCREEN_HEIGHT-48, SCREEN_WIDTH-60, 40)];
    [topUpBtn setBackgroundColor:CONTENT_COLOR];
    [topUpBtn setTitle:@"确认提现" forState:UIControlStateNormal];
    [topUpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    topUpBtn.layer.cornerRadius=5;
    topUpBtn.layer.masksToBounds=YES;
    [topUpBtn addTarget:self action:@selector(topUpBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:topUpBtn];
    
}
- (void)backButtonPressed:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)topUpBtnOnClick:(UIButton *)sender{
    NSString *richCash =self.cashTextField.text;
    NSString *passWord =self.passWordTextField.text;
    NSLog(@"%@---%@",richCash,passWord);
}
-(void)tap:(UITapGestureRecognizer *)sender{
    [self.view endEditing:YES];
}
#pragma mark   UITextField  delegate

@end
