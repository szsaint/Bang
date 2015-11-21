//
//  NewOrderDetailController.m
//  iBang
//
//  Created by yyx on 15/10/2.
//  Copyright © 2015年 kiwi. All rights reserved.
//

#import "NewOrderDetailController.h"
#import "DriveInfoCell.h"
#import "AppointTimeCell.h"
#import "RouteCell.h"
#import "MoneyCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "LoadOrderDetail.h"
#import "GetUserInfoApi.h"
#import "AcceptOrder.h"
#import "StartWaitingApi.h"
#import "StartWorkingApi.h"
#import "SurePayApi.h"
#import "OperationApi.h"
#import "APService.h"
#import "Utils.h"
#import <SVProgressHUD/SVProgressHUD.h>

//#import "LineViewController.h"
//#import "PayViewController.h"

@interface NewOrderDetailController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@end

@implementation NewOrderDetailController{
    UITableView *_mainTableView;
    NSMutableArray *_resultArray;
    UIButton *_operaBtn;
    NSString *_userAvatar;
    UserBeen *_user;
    OrderBeen *_order;
    NSInteger _ststus;
    BOOL _isMine;
    BOOL _isToMe;
    NSString *_jinge;
    NSString *_distance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initViews];
    [self updateData];
}

-(void)viewWillAppear:(BOOL)animated{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
}


#pragma mark - JPush自定义消息

- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    NSString *content = [userInfo valueForKey:@"content"];
    NSLog(@"content:%@",content);
    NSDictionary *dic = [Utils dictionaryWithJsonString:content];
    if (dic != nil) {
        if ([dic valueForKey:@"event"]) {
            if ([[dic valueForKey:@"event"] isEqualToString:@"order-updated"]) {
                NSString *orderid = [dic valueForKey:@"order_id"];
                _orderId = orderid;
                [self updateData];
            }
        }
    }
}


-(void)updateData{
    [self loadData];
    
}

-(void)loadUserInfo:(NSString *) userId{
    GetUserInfoApi *api = [[GetUserInfoApi alloc] initWithUserId:userId];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        if (request) {
            //json如下
            id result = [request responseJSONObject];
            float s = [result[@"rst"] floatValue];
            if (s == 0.0f) {
                NSMutableArray *tempApp = result[@"data"];
                _user.avater = [tempApp cy_stringKey:@"avatar"];
                _mainTableView.delegate = self;
                _mainTableView.dataSource = self;
                [_mainTableView reloadData];
            }
            [SVProgressHUD dismiss];
        }
    } failure:^(YTKBaseRequest *request) {
        [SVProgressHUD dismiss];
        id result = [request responseJSONObject];
        NSLog(@"加载失败 -- %@",request);
    }];
}

-(void)initViews{
    UILabel *topicLabel = [[UILabel alloc] init];
    topicLabel.frame = CGRectMake( (SCREEN_WIDTH - 120)/2, 32, 120, 20);
    topicLabel.text = @"订单详情";
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
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-70) style:UITableViewStyleGrouped];
    _mainTableView.showsHorizontalScrollIndicator = NO;
    _mainTableView.showsVerticalScrollIndicator = NO;
    [_mainTableView setBackgroundColor:[UIColor whiteColor]];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_mainTableView];
    
    
    
}

-(void)initOpButton{
    _operaBtn = ({
        UIButton *opera = [[UIButton alloc] initWithFrame:({
            CGRect frame = CGRectMake(30,SCREEN_HEIGHT-60, SCREEN_WIDTH-60, 50);
            frame;
        })];
        [opera setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [opera.titleLabel setFont:[UIFont systemFontOfSize:28.0f]];
        [opera setBackgroundColor:RGB(41, 140, 88, 1)];
        if (_isMine) {
            [opera setTitle:[Utils clinetBtnStatusString:_ststus] forState:UIControlStateNormal];
        }
        [opera addTarget:self action:@selector(operation) forControlEvents:UIControlEventTouchUpInside];
        opera.layer.cornerRadius = 10;
        opera;
    });
    
    [self.view addSubview:_operaBtn];
    
}

-(void)initRightBtn{
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    rightBtn.titleLabel.font = [UIFont fontWithName:@"Arial" size:14.0];
    [rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [rightBtn setTintColor:[UIColor blackColor]];
    if (_isMine) {
        if (_ststus<30) {
            [rightBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            [rightBtn addTarget:self action:@selector(cancelOrder) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
            self.navigationItem.rightBarButtonItem = item;
        }
    }
}


- (void)backButtonPressed:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadData{
    [SVProgressHUD showWithStatus:@"正在更新订单..."];
    LoadOrderDetail *api = [[LoadOrderDetail alloc] initWithOrderId:_orderId];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        if (request) {
            //json如下
            id result = [request responseJSONObject];
            NSLog(@"json%@",result);
            float s = [result[@"rst"] floatValue];
            if (s == 0.0f) {
                _resultArray = result[@"data"];
                _isMine = YES;
                if ( [_resultArray cy_stringKey:@"server_id"]) {
                    //已经接单才会有服务者信息
                    NSString *serverId = [_resultArray cy_stringKey:@"server_id"];
                    _user = [[UserBeen alloc] init];
                    _user.userId = serverId;
                    _user.name = [_resultArray cy_stringKey:@"server_name"];
                    _user.phone = [_resultArray cy_stringKey:@"server_phone"];
                    [self loadUserInfo:_user.userId];
                }
                
                _order = [[OrderBeen alloc] init];
                _order.appointTime = [_resultArray cy_stringKey:@"appointment"];
                _order.from = [_resultArray cy_stringKey:@"address"];
                _order.status = [_resultArray cy_intKey:@"status"];
               // _order.to 缺少到达地点
                _ststus = _order.status;
                if (_isMine) {
                    if (_ststus == 40 || _ststus == 50 || _ststus == 58 || _ststus == 60) {
                        [self initOpButton];
                    }
                }
                
                [self initRightBtn];
            }
        }
    } failure:^(YTKBaseRequest *request) {
        
    }];
}


-(void)cancelOrder{
    NSString *url = [@"/order/" stringByAppendingString:_orderId];
    url = [url stringByAppendingString:@"/cancel"];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"取消订单",@"comment", nil];
    [self operation:url params:params];
    
}

#pragma mark --- UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            return 80;
            break;
         case 1:
            return 50;
            break;
        case 2:
            return 90;
            break;
        case 3:
            return 115;
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        if (indexPath.row == 0) {
            static NSString *userInfoIdentifier = @"userInfoIdentifier";
            DriveInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:userInfoIdentifier];
            if (!cell) {
                cell = [[DriveInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:userInfoIdentifier];
            }
            if (_user.avater) {
                //已经接单
                NSString *avaterUrl = [kServiceUrl stringByAppendingString:_user.avater];
                [cell.avatar sd_setImageWithURL:[NSURL URLWithString:avaterUrl] placeholderImage:[UIImage imageNamed:@"用户"]];
                [cell.name setText:_user.name];
                [cell.call addTarget:self action:@selector(callPhone) forControlEvents:UIControlEventTouchUpInside];
            }else{
                //未接单
                cell.status=0;
            }
           
            return cell;
        }else if (indexPath.row == 1){
            static NSString *orderAppointTimeIdentifier = @"orderAppointTimeIdentifier";
            AppointTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:orderAppointTimeIdentifier];
            if (!cell) {
                cell = [[AppointTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderAppointTimeIdentifier];
            }
            NSString *at =[@"预约时间：" stringByAppendingString: _order.appointTime];
            [cell.time setText:at];
            return cell;
        }else if(indexPath.row == 2){
            static NSString *orderFromIdentifier = @"orderFromIdentifier";
            RouteCell *cell = [tableView dequeueReusableCellWithIdentifier:orderFromIdentifier];
            if (!cell) {
                cell = [[RouteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderFromIdentifier];
            }
            [cell.fromTxt setText:[@"出发地点：" stringByAppendingString:_order.from]];
            if (_order.to) {
                [cell.toTxt setText:[@"到达地点：" stringByAppendingString:_order.to]];
            }else{
                [cell.toTxt setText:_order.to];
            }
            
            return cell;
        }else if (indexPath.row == 3){
            static NSString *moneyIdentifier = @"moneyIdentifier";
            MoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:moneyIdentifier];
            if (!cell) {
                cell = [[MoneyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:moneyIdentifier];
            }
            if (_ststus<40) {
                if (_ststus<30) {
                    return cell;
                }else{
                    cell.titlelab.hidden=NO;
                }
            }else{
                [cell.jine setText: [NSString stringWithFormat:@"%@元",[_resultArray cy_stringKey:@"actual_price"]]];
                id detail = [_resultArray valueForKey:@"detail"];
                [cell.distance setText:[NSString stringWithFormat:@"%@公里",[detail cy_stringKey:@"distance"]]];
            }
            return cell;
        }
    
    return nil;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(void)callPhone{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",_user.phone];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}

-(void)operation{
//    NSString *url = [@"/order/" stringByAppendingString:_orderId];
//    NSDictionary *params;
    if (_isMine) {
        switch (_ststus) {
            case 40:
                //支付
                [self payForOrder];
                break;
            case 50:
                //支付
                [self payForOrder];
                break;
            case 58:
                //评价
                break;
            case 60:
                //评价
                break;
            default:
                break;
        }
    }
}

//操作
-(void)operation:(NSString *) url params:(NSDictionary *) params{
    [SVProgressHUD showWithStatus:@"更新订单中..."];
    OperationApi *api = [[OperationApi alloc] initWithUrl:url params:params];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        if (request) {
            //json如下
            id result = [request responseJSONObject];
            float s = [result[@"rst"] floatValue];
            if (s == 0.0f) {
                [SVProgressHUD showSuccessWithStatus:result[@"msg"]];
                
            }else{
                
                [SVProgressHUD showInfoWithStatus:result[@"msg"]];
            }
            
        }
    } failure:^(YTKBaseRequest *request) {
        id result = [request responseJSONObject];
        [SVProgressHUD showErrorWithStatus:result[@"msg"]];
        NSLog(@"通讯失败,%@",result);
    }];
}

//支付
-(void)payForOrder{
//    PayViewController *vc = [[PayViewController alloc] init];
//    vc.orderId = _orderId;
//    [self.navigationController pushViewController:vc animated:YES];
}
//评价
-(void)caculate{
    
}
#pragma mark - 操作方法


-(void)viewWillDisappear:(BOOL)animated{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    
    [defaultCenter removeObserver:self];
}


@end
