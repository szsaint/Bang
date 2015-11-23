//
//  MyOrdersViewController.m
//  iBang
//
//  Created by yyx on 15/8/29.
//  Copyright (c) 2015年 kiwi. All rights reserved.
//

#import "MyOrdersViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "LoadMyOrders.h"
#import "NewOrderListCell.h"
#import "NewOrderDetailController.h"
#import "Utils.h"

@interface MyOrdersViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray *resultArray;


@end

@implementation MyOrdersViewController{
    UITableView *_mainTableView;
    NSString *nextUrl;
    BOOL _all;
    NSMutableArray *ra;
}

-(NSMutableArray *)resultArray{
    if (!_resultArray) {
        _resultArray = [[NSMutableArray alloc] init];
    }
    return _resultArray;
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
    nextUrl = nil;
    _all = YES;
}

- (void)initUserInterface
{
    self.title=@"我的订单";
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake( 20, 20, 44, 44);
    [backBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    //_mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.tableFooterView=[[UIView alloc]init];
    [self.view addSubview:_mainTableView];
    
    __weak UITableView *tableView = _mainTableView;
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData:@"order/mine"];
        
    }];
    tableView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (nextUrl) {
            [self loadMoreData:nextUrl];
        }else{
            [tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    }];
    
    [_mainTableView.mj_header beginRefreshing];
}


- (void)loadData:(NSString *) url{
    LoadMyOrders *api = [[LoadMyOrders alloc] initWithUrl:url];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        if (request) {
            //json如下
            id result = [request responseJSONObject];
            float s = [result[@"rst"] floatValue];
            if (s == 0.0f) {
                _resultArray = result[@"data"];
                if (result[@"next_page_url"] != [NSNull null]) {
                    nextUrl =result[@"next_page_url"];
                    [_mainTableView.mj_footer resetNoMoreData];
                }else{
                    nextUrl = nil;
                }
                
                [_mainTableView.mj_header endRefreshing];
                //                [_mainTableView.footer endRefreshing];
                [_mainTableView reloadData];
                NSLog(@"7777777----%@",request);
            }
        }
    } failure:^(YTKBaseRequest *request) {
//        id result = [request responseJSONObject];
//        NSLog(@"加载失败 -- %@",request);
    }];
}



//上拉到底部加载更多数据
- (void)loadMoreData:(NSString *) url{
    LoadMyOrders *api = [[LoadMyOrders alloc] initWithUrl:url];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        if (request) {
            //json如下
            id result = [request responseJSONObject];
            float s = [result[@"rst"] floatValue];
            if (s == 0.0f) {
                NSMutableArray *moreData = result[@"data"];
                ra = [_resultArray mutableCopy];
                _resultArray = nil;
                [ra addObjectsFromArray:moreData];
                _resultArray = [ra mutableCopy];
                ra = nil;
                
                if (result[@"next_page_url"] != [NSNull null]) {
                    nextUrl =result[@"next_page_url"];
                }else{
                    nextUrl = nil;
                }
                
                [_mainTableView.mj_footer endRefreshing];
                [_mainTableView reloadData];
                NSLog(@"7777777----%@",request);
            }
        }
    } failure:^(YTKBaseRequest *request) {
        NSLog(@"加载失败 -- %@",request);
    }];
}

- (void)backButtonPressed:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_resultArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifiler = @"orderlist";
    NewOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifiler];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NewOrderListCell" owner:self options:nil] lastObject];
    }
    NSMutableArray *array = [_resultArray objectAtIndex:indexPath.row];
    NSLog(@"%@",array);
    cell.orderId = [array cy_stringKey:@"id"];
    [cell.fromLabel setText:[NSString stringWithFormat:@"出发地点：%@",[array cy_stringKey:@"address"]]];
    if ([array valueForKey:@"actual_price"] == [NSNull null]) {
        cell.priceLabel.hidden = YES;
    }else{
        [cell.priceLabel setText:[NSString stringWithFormat:@"%@元",[array cy_stringKey:@"actual_price"]]];
        // NSLog(@"vvvvvvvvv:%@",[array cy_stringKey:@"actual_price"]);
    }
    [cell.snLabel setText:[NSString stringWithFormat:@"订单号：%@",[array cy_stringKey:@"sn"]]];
    [cell.dateLabel setText:[NSString stringWithFormat:@"预约时间：%@",[array cy_stringKey:@"appointment"]]];
    NSUInteger sts = [array cy_integerKey:@"status" defaultValue:99];
    cell.status = sts;
    [cell.statusLabel setText:[Utils StatusString:sts]];
    if ([array valueForKey:@"server_id"] != [NSNull null]) {
        cell.serverId = [array cy_stringKey:@"server_id"];
    }
    cell.clientId = [array cy_stringKey:@"client_id"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewOrderListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NewOrderDetailController *detailVC =[[NewOrderDetailController alloc]init];
    detailVC.orderId = cell.orderId;
    [self.navigationController pushViewController:detailVC animated:YES];
}




@end
