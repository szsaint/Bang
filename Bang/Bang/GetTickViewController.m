//
//  GetTickViewController.m
//  iBang
//
//  Created by yyx on 15/8/27.
//  Copyright (c) 2015年 kiwi. All rights reserved.
//

#import "GetTickViewController.h"
#import "ConvertTicket.h"
#import "KIWIAlertView.h"

@interface GetTickViewController ()<UITableViewDelegate,UITableViewDataSource,KIWIAlertViewDelegate>

- (void)initUserDataSource;
- (void)initUserInterface;

@end

@implementation GetTickViewController{
    UITextField *_codeField;
    UIButton *_submitBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUserDataSource];
    [self initUserInterface];
}

- (void)initUserDataSource
{
    
}

- (void)initUserInterface
{
//    UIView *topView = [[UIView alloc] init];
//    topView.frame = CGRectMake( 0, 0, SCREEN_WIDTH, 64);
//    topView.backgroundColor = [UIColor whiteColor];
//    topView.alpha = 0.975f;
//    [self.view addSubview:topView];
    
    UILabel *topicLabel = [[UILabel alloc] init];
    topicLabel.frame = CGRectMake( (SCREEN_WIDTH - 150)/2, 32, 150, 20);
    topicLabel.text = @"兑换优惠券";
    topicLabel.textAlignment = NSTextAlignmentCenter;
    topicLabel.textColor = [UIColor blackColor];
    topicLabel.font = [UIFont systemFontOfSize:22.0f];
//    [topView addSubview:topicLabel];
    self.navigationItem.titleView = topicLabel;
    
//    UIView *bottomLine = [[UIView alloc] init];
//    bottomLine.frame = CGRectMake( 0, 63.5, SCREEN_WIDTH, 1);
//    bottomLine.backgroundColor = [UIColor lightGrayColor];
//    [topView addSubview:bottomLine];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake( 20, 20, 44, 44);
    [backBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    [topView addSubview:backBtn];
    UIBarButtonItem *bacItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = bacItem;
    
    _codeField = [[UITextField alloc] initWithFrame:CGRectMake(10, 84, SCREEN_WIDTH-20, 60)];
    _codeField.layer.cornerRadius = 5.0f;
    _codeField.layer.borderColor = RGB(41, 140, 88, 1).CGColor;
    _codeField.layer.borderWidth = 1.0f;
    _codeField.font = [UIFont fontWithName:@"Arial" size:28.0f];
    _codeField.textColor = RGB(41, 140, 88, 1);
    _codeField.textAlignment = NSTextAlignmentCenter;
    _codeField.placeholder = @"输入兑换码";
    [self.view addSubview:_codeField];
    
    // 立即下单 按钮
    _submitBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _submitBtn.frame = CGRectMake(10, 164, SCREEN_WIDTH-20, 40);
    [_submitBtn setTitle:@"立即兑换" forState:UIControlStateNormal];
    [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_submitBtn.titleLabel setFont:[UIFont systemFontOfSize:28.0f]];
    [_submitBtn setBackgroundImage:[UIImage imageNamed:@"下单按钮"] forState:UIControlStateNormal];
    [_submitBtn addTarget:self action:@selector(loadTickFromNum:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_submitBtn];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];

}

-(void)loadTickFromNum:(UIButton *) button{
//    NSString *te = [_codeField text];
    if (![_codeField text]) {
        KIWIAlertView *alertView = [[KIWIAlertView alloc] initWithTitle:@"失败了" icon:nil message:@"请正确填写兑换码" delegate:self buttonTitles:@"好的", nil];
        [alertView setMessageColor:[UIColor blackColor] fontSize:0];
        [alertView setTag:0];
        [_codeField resignFirstResponder];
        [alertView show];
    }else{
    ConvertTicket *api = [[ConvertTicket alloc] initWithTicketCode:[_codeField text]];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        if (request) {
            //json如下
            id result = [request responseJSONObject];
            float s = [result[@"rst"] floatValue];
            if (s == 0.0f) {
                KIWIAlertView *alertView = [[KIWIAlertView alloc] initWithTitle:@"成功" icon:nil message:result[@"msg"] delegate:self buttonTitles:@"谢谢", nil];
                [alertView setMessageColor:[UIColor blackColor] fontSize:0];
                [alertView setTag:1];
                [_codeField resignFirstResponder];
                [alertView show];
            }else{
                KIWIAlertView *alertView = [[KIWIAlertView alloc] initWithTitle:@"失败了" icon:nil message:result[@"msg"] delegate:self buttonTitles:@"好的", nil];
                [alertView setMessageColor:[UIColor blackColor] fontSize:0];
                [alertView setTag:0];
                [_codeField resignFirstResponder];
                [alertView show];

            }
        }
    } failure:^(YTKBaseRequest *request) {
        id res = [request responseJSONObject];
        KIWIAlertView *alertView = [[KIWIAlertView alloc] initWithTitle:@"失败了" icon:nil message:@"网络有问题啊" delegate:self buttonTitles:@"好的", nil];
        [alertView setMessageColor:[UIColor blackColor] fontSize:0];
        [alertView setTag:0];
        [_codeField resignFirstResponder];
        [alertView show];

    }];
    }
}

- (void)alertView:(KIWIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView tag] == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [_codeField resignFirstResponder];
}

- (void)backButtonPressed:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
