//
//  StarViewController.m
//  iBang
//
//  Created by yyx on 15/8/30.
//  Copyright (c) 2015年 kiwi. All rights reserved.
//

#import "StarViewController.h"
#import "CWStarRateView.h"
#import <DeformationButton/DeformationButton.h>
#import "StarApi.h"

@interface StarViewController ()<UITextViewDelegate,KIWIAlertViewDelegate>

@end

@implementation StarViewController{
    CWStarRateView *_starView;
    DeformationButton *_submit;
    UITextView *_msg;
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
    
    UILabel *topicLabel = [[UILabel alloc] init];
    topicLabel.frame = CGRectMake( (SCREEN_WIDTH - 120)/2, 32, 120, 20);
    topicLabel.text = @"评价司机";
    topicLabel.textAlignment = NSTextAlignmentCenter;
    topicLabel.textColor = [UIColor blackColor];
    topicLabel.font = [UIFont systemFontOfSize:22.0f];
    //    [topView addSubview:topicLabel];
    self.navigationItem.titleView = topicLabel;
    
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake( 20, 20, 44, 44);
    [backBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    _msg = [[UITextView alloc] initWithFrame:CGRectMake(20, 80, SCREEN_WIDTH-40, 80)];
    _msg.font = [UIFont fontWithName:@"Arial" size:18];
    _msg.layer.borderColor = RGB(41, 140, 88, 1).CGColor;
    _msg.layer.borderWidth = 1.0f;
    _msg.layer.cornerRadius = 5.0f;
    _msg.delegate = self;
    [self.view addSubview:_msg];
    
    _starView = [[CWStarRateView alloc] initWithFrame:CGRectMake(20, 180, SCREEN_WIDTH-40, 40) numberOfStars:5];
    _starView.scorePercent = 1;
    _starView.allowIncompleteStar = YES;
    _starView.hasAnimation = YES;
    [self.view addSubview:_starView];
    
    _submit =[[DeformationButton alloc]initWithFrame:CGRectMake(20, SCREEN_HEIGHT - 70, SCREEN_WIDTH-40, 60) withColor:RGB(41, 140, 88, 1)];
    [_submit.forDisplayButton setTitle:@"立即评价" forState:UIControlStateNormal];
    [_submit.forDisplayButton.titleLabel setFont:[UIFont systemFontOfSize:28.0f]];
    [_submit.forDisplayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_submit.forDisplayButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 6, 0, 0)];
    [_submit addTarget:self action:@selector(pingjia) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_submit];

    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}


- (void) textViewDidChange:(UITextView *)textView{
//    if (textView.text.length >= 50) {
//        textView.text = [textView.text substringToIndex:49];
//    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (textView.text.length>=50) {
        textView.text = [textView.text substringToIndex:49];
        return NO;
    }
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
        if (textView.text.length >= 50) {
            textView.text = [textView.text substringToIndex:49];
        }

}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [_msg resignFirstResponder];
}

- (void)backButtonPressed:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)pingjia{
    StarApi *api = [[StarApi alloc] initWithOrderId:_orderId andComment:[_msg text] withScore:_starView.scorePercent];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        if (request) {
            //json如下
            id result = [request responseJSONObject];
            _submit.isLoading=NO;
            float s = [result[@"rst"] floatValue];
            if (s == 0.0f) {
                KIWIAlertView *alert =[[KIWIAlertView alloc]initWithTitle:@"提示" icon:nil message:@"感谢您对我们的服务的评价" delegate:self buttonTitles:@"确定", nil];
                [alert show];
            }
        }
    } failure:^(YTKBaseRequest *request) {
//        id result = [request responseJSONObject];
//        NSLog(@"%@",result);
        _submit.isLoading=NO;

    }];
}
-(void)success{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)alertView:(KIWIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        [self performSelector:@selector(success) withObject:nil];
    }
}
@end
