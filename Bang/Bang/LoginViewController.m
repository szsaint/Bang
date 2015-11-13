//
//  LoginViewController.m
//  iBang
//
//  Created by yyx on 15/5/18.
//  Copyright (c) 2015年 kiwi. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterApi.h"
#import "AaptchaApi.h"

#import "ViewController.h"
#import "KIWIAlertView.h"

@interface LoginViewController ()<UINavigationBarDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate,KIWIAlertViewDelegate>
{
    UIScrollView *_mainScrollView;//
    UITextField *_phoneNumTextField;
    UIButton *_getVerifyCodeBtn;
    UILabel *_getVerfyCodeLB;
    NSTimer *_timer;
     int _totalOfTime;
    NSUserDefaults *_iBangKey;
    NSString *_password;
    UITextField *_verifyTextField;
}

- (void)initDataSource;
- (void)initUserInterface;

@end

@implementation LoginViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor blackColor];
    self.title = @"注册";
    [self initDataSource];
    [self initUserInterface];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)initDataSource {
//    _iBangKey = [[KeychainItemWrapper alloc] initWithIdentifier:@"iBang_AuthToken" accessGroup:nil];
    _iBangKey = [NSUserDefaults standardUserDefaults];
    
    [self getPassWord];
}

- (void)initUserInterface {
    

    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake( 20, 27, 30, 30);
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [leftButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake( SCREEN_WIDTH - 50, 27, 30, 30);
    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [rightButton addTarget:self action:@selector(sureButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    _mainScrollView = [[UIScrollView alloc] init];
    _mainScrollView.frame = CGRectMake( 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    _mainScrollView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_mainScrollView];
    
    
    _phoneNumTextField = [[UITextField alloc] init];
    _phoneNumTextField.frame = CGRectMake( 10, 20, SCREEN_WIDTH - 20, 60);
    _phoneNumTextField.delegate = self;
    _phoneNumTextField.leftViewMode = UITextFieldViewModeAlways;
    _phoneNumTextField.placeholder = @"手机号码";
    _phoneNumTextField.textAlignment = NSTextAlignmentLeft;
    _phoneNumTextField.textColor = [UIColor darkGrayColor];
    _phoneNumTextField.font = [UIFont systemFontOfSize:18.0f];
    _phoneNumTextField.background = [UIImage imageNamed:@"输入框"];
    _phoneNumTextField.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    _phoneNumTextField.keyboardType = UIKeyboardTypeNumberPad;
    [_mainScrollView addSubview:_phoneNumTextField];
    
    
    UIView *verifyLeftView = [[UIView alloc] init];
    verifyLeftView.frame = CGRectMake( 0, 0, 5, 1);
    verifyLeftView.backgroundColor = [UIColor whiteColor];
    
    _verifyTextField = [[UITextField alloc] init];
    _verifyTextField.frame = CGRectMake(10, 81, SCREEN_WIDTH-120 , 60);
    _verifyTextField.delegate = self;
    _verifyTextField.leftView = verifyLeftView;
    _verifyTextField.leftViewMode = UITextFieldViewModeAlways;
    _verifyTextField.placeholder = @"验证码";
    _verifyTextField.textAlignment = NSTextAlignmentLeft;
    _verifyTextField.textColor = [UIColor darkGrayColor];
    _verifyTextField.font = [UIFont systemFontOfSize:18.0f];
    _verifyTextField.background = [UIImage imageNamed:@"输入框"];
    _verifyTextField.keyboardType = UIKeyboardTypeNumberPad;
    [_mainScrollView addSubview:_verifyTextField];
    
    _getVerifyCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _getVerifyCodeBtn.frame = CGRectMake( SCREEN_WIDTH - 110, 81, 100, 60);
    [_getVerifyCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_getVerifyCodeBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_getVerifyCodeBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [_getVerifyCodeBtn setBackgroundImage:[UIImage imageNamed:@"验证码按钮"] forState:UIControlStateNormal];
    [_getVerifyCodeBtn addTarget:self action:@selector(getVerifyCodeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_mainScrollView addSubview:_getVerifyCodeBtn];
    
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [_phoneNumTextField resignFirstResponder];
    [_verifyTextField resignFirstResponder];
}


#pragma mark -- Timer 
- (void)timerFireMethod:(NSTimer*)timer {
    if (_totalOfTime > 0) {
        [_getVerifyCodeBtn setTitle:[NSString stringWithFormat:@"倒计时 %d",_totalOfTime--] forState:UIControlStateNormal];

    } else if (_totalOfTime == 0) {
        [_timer invalidate];
        [_getVerifyCodeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        _getVerifyCodeBtn.userInteractionEnabled = YES;
    }
}

#pragma mark -- ButtonPressed

- (void)cancelButtonPressed:(UIButton *)button {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sureButtonPressed:(UIButton *)button {
    [self userRegister];
}

- (void)getVerifyCodeButtonPressed:(UIButton *)button {
    
    
    NSString *regex = @"((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL isMatch = [predicate evaluateWithObject:_phoneNumTextField.text];
    if (!isMatch) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号码" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    } else {
        AaptchaApi *api = [[AaptchaApi alloc] initWithPhone:_phoneNumTextField.text];
        [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            if (request) {
                NSInteger code = [request responseStatusCode];
                if (code == 200) {
                    KIWIAlertView *alertView = [[KIWIAlertView alloc] initWithTitle:@"成功" icon:nil message:@"验证码发送成功" delegate:self buttonTitles:@"确定", nil];
                    [alertView setMessageColor:[UIColor blackColor] fontSize:0];
                    [alertView setTag:0];
                    [_phoneNumTextField resignFirstResponder];
                    [_verifyTextField resignFirstResponder];
                    [alertView show];
                }
            }
        } failure:^(YTKBaseRequest *request) {
            KIWIAlertView *alertView = [[KIWIAlertView alloc] initWithTitle:@"失败" icon:nil message:@"请重新获取验证码" delegate:self buttonTitles:@"确定", nil];
            [alertView setMessageColor:[UIColor blackColor] fontSize:0];
            [alertView setTag:1];
            [_phoneNumTextField resignFirstResponder];
            [_verifyTextField resignFirstResponder];
            [alertView show];
        }];
    }
}

- (void)alertView:(KIWIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView tag] == 0) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];\
        _totalOfTime = 60;
        _getVerfyCodeLB.hidden = NO;
        _getVerifyCodeBtn.userInteractionEnabled = NO;
    }
}

- (void) userRegister{
    RegisterApi *api = [[RegisterApi alloc] initWithPhoneNumber:_phoneNumTextField.text andCaptCha:_verifyTextField.text andPwd:_password];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        if (request) {
            NSInteger code = [request responseStatusCode];
            if (code == 200) {
                [_iBangKey setValue:_phoneNumTextField.text forKey:kUserName];
                [_iBangKey setValue:_password forKey:kPassword];
                [_iBangKey synchronize];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    } failure:^(YTKBaseRequest *request) {
        NSInteger code = [request responseStatusCode];
        //json如下
        id result = [request responseJSONObject];
    }];
}

- (void) getPassWord{
    _password = @"";
    for (int i=0; i<8; i++) {
        _password = [_password stringByAppendingFormat:@"%i",arc4random()%9];
    }
}

#pragma mark -- UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -- TouchEvent

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {

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
