//
//  ServicePriceViewController.m
//  iBang
//
//  Created by 龙斐 on 15/6/29.
//  Copyright (c) 2015年 kiwi. All rights reserved.
//

#import "ServicePriceViewController.h"

@interface ServicePriceViewController ()<UIWebViewDelegate>

- (void)initUserDataSource;
- (void)initUserInterface;

@end

@implementation ServicePriceViewController{
    UIWebView *_webView;
}
@synthesize type = _type;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUserInterface];
    [self initUserDataSource];
}

- (void)initUserDataSource
{
    NSURLRequest *request;
    if (_type == 1) {
        request = [NSURLRequest requestWithURL:[NSURL URLWithString:[kServiceUrl stringByAppendingString:@"/html/service-agreement.html"]]];
    }else{
        request = [NSURLRequest requestWithURL:[NSURL URLWithString:[kServiceUrl stringByAppendingString:@"/html/price.html"]]];
    }
    
    [_webView loadRequest:request];

}

- (void)initUserInterface
{
//    UIView *topView = [[UIView alloc] init];
//    topView.frame = CGRectMake( 0, 0, SCREEN_WIDTH, 64);
//    topView.backgroundColor = [UIColor whiteColor];
//    topView.alpha = 0.975f;
//    [self.view addSubview:topView];
    
    UILabel *topicLabel = [[UILabel alloc] init];
    topicLabel.frame = CGRectMake( (SCREEN_WIDTH - 120)/2, 32, 120, 20);
    if (_type == 1) {
        topicLabel.text = @"服务协议";
    }else{
        topicLabel.text = @"服务价格";
    }
    
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
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _webView.delegate = self;
    _webView.autoresizesSubviews = YES;
    _webView.scalesPageToFit = YES;
    for (UIView *view in [_webView subviews]) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            [((UIScrollView *)view) setShowsHorizontalScrollIndicator:NO];
            [((UIScrollView *)view) setShowsVerticalScrollIndicator:NO];
            for (UIView *v in [view subviews]) {
                if ([v isKindOfClass:[UIImageView class]]) {
                    v.hidden = YES;
                }
            }
        }
    }
    [self.view addSubview:_webView];
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
