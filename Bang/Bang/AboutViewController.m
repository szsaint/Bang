//
//  AboutViewControllerTableViewController.m
//  iBang
//
//  Created by yyx on 15/7/7.
//  Copyright (c) 2015年 kiwi. All rights reserved.
//

#import "AboutViewController.h"
#import "CustomTableCell.h"
#import "ServicePriceViewController.h"

@interface AboutViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation AboutViewController{
    UITableView *_tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
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
    topicLabel.frame = CGRectMake( (SCREEN_WIDTH - 120)/2, 32, 120, 20);
    topicLabel.text = @"关于";
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
    
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-40, SCREEN_WIDTH, 20)];
    [infoLabel setText:@"Copyright (c) 2015年 苏州圣斗士信息技术有限公司. All rights reserved."] ;
     infoLabel.textAlignment = NSTextAlignmentCenter;
     infoLabel.textColor = [UIColor lightGrayColor];
     infoLabel.font = [UIFont fontWithName:@"Arial" size:10.0f];
     [self.view addSubview:infoLabel];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-104) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    [_tableView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_tableView];
}

- (void)backButtonPressed:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 2;
            break;
        default:
            return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"kiwiSettingCell";
    CustomTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[CustomTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    if (indexPath.section == 0) {
        [cell.titleImg setImage:[UIImage imageNamed:@"法律条文"]];
        [cell.titleLabel setText:@"委托代驾服务协议"];
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [cell.titleImg setImage:[UIImage imageNamed:@"客服热线"]];
            [cell.titleLabel setText:@"客服热线"];
        }else if (indexPath.row == 1){
            [cell.titleImg setImage:[UIImage imageNamed:@"appstore"]];
            [cell.titleLabel setText:@"App Store评分"];
        }
    }
//    else if(indexPath.section == 2){
//        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//        [cell.titleImg setImage:[UIImage imageNamed:@"用户"]];
//        [cell.titleLabel setText:@"版本号"];
//        [cell.detailLabel setText:version];
//        [cell.detailLabel setHidden:NO];
//        [cell.goImg setHidden:YES];
//    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        ServicePriceViewController *vc = [[ServicePriceViewController alloc] init];
        vc.type = 1;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"051235008885"];
            UIWebView * callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [self.view addSubview:callWebview];
        }else if (indexPath.row == 1){
            NSString *str = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1012929503" ];
            if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)){
                str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/1012929503"];
            }
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
    }
}



@end
