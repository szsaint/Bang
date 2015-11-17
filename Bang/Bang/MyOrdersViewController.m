//
//  MyOrdersViewController.m
//  iBang
//
//  Created by yyx on 15/8/29.
//  Copyright (c) 2015年 kiwi. All rights reserved.
//

#import "MyOrdersViewController.h"
#import "NYSegmentedControl.h"
#import <MJRefresh/MJRefresh.h>
#import "LoadMyOrders.h"
#import "NewOrderListCell.h"
#import "Utils.h"

@interface MyOrdersViewController ()<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate>

@property NYSegmentedControl *segmentedControl;
@property (nonatomic,strong) NSMutableArray *resultArray;


@end

@implementation MyOrdersViewController{
    UITableView *_mainTableView;
    NSUInteger _pageSize;
    NSUInteger _pageIndex;
    //    NSMutableArray *_resultArray;
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
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    [self initUserDataSource];
    [self initUserInterface];
}

- (void)initUserDataSource
{
    _pageSize = 20;
    _pageIndex = 1;
    nextUrl = nil;
    _all = YES;
}

- (void)initUserInterface
{
    //    UIView *topView = [[UIView alloc] init];
    //    topView.frame = CGRectMake( 0, 0, SCREEN_WIDTH, 64);
    //    topView.backgroundColor = [UIColor whiteColor];
    //    topView.alpha = 0.975f;
    //    [self.view addSubview:topView];
    
    self.segmentedControl = [[NYSegmentedControl alloc] initWithItems:@[@"我的订单",@"我服务的订单"]];
    self.segmentedControl.frame = CGRectMake( (SCREEN_WIDTH - 120)/2, 30, 200, 20);
    [self.segmentedControl addTarget:self action:@selector(segmentSelected:) forControlEvents:UIControlEventValueChanged];
    self.segmentedControl.backgroundColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
    self.segmentedControl.segmentIndicatorBackgroundColor = [UIColor whiteColor];
    self.segmentedControl.segmentIndicatorInset = 0.0f;
    self.segmentedControl.titleTextColor = [UIColor lightGrayColor];
    self.segmentedControl.selectedTitleTextColor = [UIColor darkGrayColor];
    [self.segmentedControl sizeToFit];
    //    [topView addSubview:self.segmentedControl];
    self.navigationItem.titleView = self.segmentedControl;
    
    //    UIView *bottomLine = [[UIView alloc] init];
    //    bottomLine.frame = CGRectMake( 0, 63.5, SCREEN_WIDTH, 1);
    //    bottomLine.backgroundColor = [UIColor lightGrayColor];
    //    [topView addSubview:bottomLine];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake( 20, 20, 44, 44);
    [backBtn setImage:[UIImage imageNamed:@"返回按钮"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    //    [topView addSubview:backBtn];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    //_mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.showsHorizontalScrollIndicator = NO;
    _mainTableView.showsVerticalScrollIndicator = NO;
    //_mainTableView.backgroundColor = RGB(19, 20, 37, 1);
    [self.view addSubview:_mainTableView];
    
    __weak UITableView *tableView = _mainTableView;
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (_all) {
            [self loadData:@"order/mine"];
        }else{
            [self loadMyOrders:@"order/yours"];
        }
        
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
    
    //    _mainTableView.footer.hidden = NO;
    //    NSLog(@"header%@",_mainTableView.header);
    //    NSLog(@"footer%@",_mainTableView.footer);
    
    [_mainTableView.mj_header beginRefreshing];
    //    [_mainTableView.footer beginRefreshing];
}

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    if (scrollView.contentOffset.y == scrollView.contentSize.height - scrollView.frame.size.height) {
//        //滑到底部加载更多
//        NSLog(@"滑到底部加载更多");
//        if (nextUrl) {
//            [self loadMoreData:nextUrl];
//            }
//    }
//}

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
        id result = [request responseJSONObject];
        NSLog(@"加载失败 -- %@",request);
    }];
}

/**
 *  加载定向给我的单子
 **/
- (void)loadMyOrders:(NSString *) url{
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
                }else{
                    nextUrl = nil;
                }
                
                [_mainTableView.header endRefreshing];
                //                [_mainTableView.footer endRefreshing];
                [_mainTableView reloadData];
                NSLog(@"7777777----%@",request);
            }
        }
    } failure:^(YTKBaseRequest *request) {
        id result = [request responseJSONObject];
        NSLog(@"加载失败 -- %@",request);
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
                
                [_mainTableView.footer endRefreshing];
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

- (void)segmentSelected:(NYSegmentedControl *)segmentedControl{
    if(segmentedControl.selectedSegmentIndex == 0){
        _all = YES;
    }else{
        _all = NO;
    }
    [_mainTableView.header beginRefreshing];
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

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 50;
//}
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UILabel *footVoew = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
//    footVoew.font = [UIFont fontWithName:@"Arial" size:18.0f];
//    [footVoew setTextColor:[UIColor whiteColor]];
//    footVoew.textAlignment = NSTextAlignmentCenter;
//    [footVoew setText:@"正在加载更多"];
//    return footVoew;
//}


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
