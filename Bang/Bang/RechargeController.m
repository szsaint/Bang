//
//  RechargeController.m
//  Bang
//
//  Created by wl on 15/11/19.
//  Copyright © 2015年 saint. All rights reserved.
//

#import "RechargeController.h"
#import "BangActionSheet.h"
#import "RechargeApi.h"

#define vcColor  [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1]

@interface RechargeController ()<UITextFieldDelegate,UIActionSheetDelegate>


@property (nonatomic,strong)UIButton *curentSelectedBtn;

@property (nonatomic,strong)UITextField *textfield;

@property (nonatomic,strong)UIView *suerback;
@end

@implementation RechargeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

-(void)setUI{
    self.title =@"账户充值";
    self.tableView.tableFooterView=[[UIView alloc]init];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake( 20, 20, 44, 44);
    [backBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;

    
    UIView *suerback =[[UIView alloc]initWithFrame:self.view.bounds];
    suerback.backgroundColor=[UIColor whiteColor];
    self.suerback=suerback;
    [self.view addSubview:suerback];
    
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapEndEditing:)];
    [suerback addGestureRecognizer:tap];
    
    
    UILabel *titlelab =[[UILabel alloc]initWithFrame:CGRectMake(0, 12, SCREEN_WIDTH, 50)];
    titlelab.backgroundColor=vcColor;
    titlelab.layer.borderWidth=0.5;
    titlelab.layer.borderColor=[UIColor lightGrayColor].CGColor;
    titlelab.font=[UIFont systemFontOfSize:14];
    titlelab.textColor=[UIColor grayColor];
    titlelab.contentMode=UIViewContentModeBottomLeft;
    titlelab.text=@"  请选择充值金额";
    [suerback addSubview:titlelab];
    
    UIView *back =[[UIView alloc]initWithFrame:CGRectMake(0, 62, SCREEN_WIDTH, 210)];
    back.backgroundColor=[UIColor whiteColor];
    [suerback addSubview:back];
    CGFloat margin =20;
    CGFloat ww =(SCREEN_WIDTH-3*margin)/2;
    CGFloat hh=50;
    NSArray *titleArr =@[@"500",@"1000",@"2000",@"5000"];
    for (int i =0; i<4; i++) {
        int row =i/2;
        int coloum =i%2;
        UIButton *btn =[self creatBordBtn];
        btn.frame =CGRectMake(margin+(ww+margin)*coloum, 15+(hh+20)*row, ww, hh);
        btn.tag=100+i;
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(bordBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [back addSubview:btn];
    }
    
    UITextField *textfield =[[UITextField alloc]initWithFrame:CGRectMake(margin+5, 160, SCREEN_WIDTH-2*margin-10, 50)];
    textfield.backgroundColor=vcColor;
    textfield.placeholder =@"其他金额";
    textfield.delegate=self;
    textfield.layer.cornerRadius=6;
    textfield.layer.masksToBounds=YES;
    textfield.keyboardType=UIKeyboardTypeNumberPad;
    self.textfield =textfield;
    [back addSubview:textfield];
    
    UIButton *sureBtn =[[UIButton alloc]initWithFrame:CGRectMake(margin, SCREEN_HEIGHT
                                                                 -64-10-40, SCREEN_WIDTH-2*margin, 40)];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn setBackgroundColor:CONTENT_COLOR];
    sureBtn.layer.cornerRadius=6;
    sureBtn.layer.masksToBounds=YES;
    [sureBtn setTitle:@"确认充值" forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [suerback addSubview:sureBtn];
}

-(void)sureBtnOnClick:(UIButton *)sender{
    if (self.curentSelectedBtn||[self.textfield.text floatValue]>0) {
        BangActionSheet *sheet =[[BangActionSheet alloc]initWithTitle:@"选择支付方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"支付宝支付",@"微信支付", nil];
        [sheet showInView:self.view];
    }else{
        KIWIAlertView *alert =[[KIWIAlertView alloc]initWithTitle:@"提示" icon:nil message:@"请选择充值金额" delegate:nil buttonTitles:@"确认", nil];
        [alert show];
    }
}

-(void)tapEndEditing:(UITapGestureRecognizer *)sender{
    [self.view endEditing:YES];
}
-(void)bordBtnOnClick:(UIButton *)sender{
    sender.selected=!sender.selected;
    if (self.textfield.text.length!=0) {
        self.textfield.text=@"";
    }
    if (self.curentSelectedBtn==sender){
        if (sender.selected==NO) {
            self.curentSelectedBtn=nil;
        }
        return;
    }
    if (self.curentSelectedBtn==nil) {
        self.curentSelectedBtn=sender;
    }else{
        self.curentSelectedBtn.selected=NO;
        self.curentSelectedBtn=nil;
        self.curentSelectedBtn=sender;}
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.curentSelectedBtn) {
        self.curentSelectedBtn.selected=NO;
        self.curentSelectedBtn=nil;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.suerback.transform=CGAffineTransformIdentity;
    }];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.3 animations:^{
        self.suerback.transform =CGAffineTransformMakeTranslation(0, -60);
    }];
}

-(UIButton *)creatBordBtn{
    UIButton *btn =[[UIButton alloc]init];
    btn.layer.borderWidth=1;
    btn.layer.borderColor=CONTENT_COLOR.CGColor;
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [btn setBackgroundImage:[self createImageWithColor:CONTENT_COLOR] forState:UIControlStateSelected];
    return btn;
}
- (void)backButtonPressed:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (UIImage*) createImageWithColor: (UIColor*) color
{
    CGRect rect=CGRectMake(0,0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}


#pragma  mark  actionsheet delegate  去充值
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%ld",(long)buttonIndex);
    NSDictionary *dic =@{@"payment_id":@"2",@"recharge":@"100"};
    RechargeApi *api =[[RechargeApi alloc]initWithInfo:dic];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        id result =[request responseJSONObject];
        
    } failure:^(YTKBaseRequest *request) {
        
    }];
}



@end
