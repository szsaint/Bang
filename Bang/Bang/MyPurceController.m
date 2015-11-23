//
//  MyPurceController.m
//  BangDriver
//
//  Created by wl on 15/11/11.
//  Copyright © 2015年 saint. All rights reserved.
//

#import "MyPurceController.h"
#import "RechargeController.h"//充值

#import "MyPurseheaderView.h"
#import "MyPurceCell.h"
#import "BangActionSheet.h"
#import <MJRefresh/MJRefresh.h>


#import "MyPurceModel.h"
#import "MyEndOrderApi.h"

@interface MyPurceController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)MyPurseheaderView *header;

@property (nonatomic,strong)NSArray *resultArray;
@property (nonatomic,strong)NSArray *cashArray;//预备提现的数据

@property (nonatomic,strong)UILabel *titleLab;//无消费记录的提示;

@end

@implementation MyPurceController{
    NSString *nextUrl;
    NSMutableArray *ra;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self setUserDate];
    self.view.backgroundColor=[UIColor redColor];
}
-(void)setUserDate{
    
    __weak UITableView *tableView = _tableView;
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData:@"/order/my-paid"];
        
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
    [self.tableView.mj_header beginRefreshing];
}

- (void)loadData:(NSString *) url{
    MyEndOrderApi *api = [[MyEndOrderApi alloc] initWithUrl:url];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        if (request) {
            //json如下
            id result = [request responseJSONObject];
            float s = [result[@"rst"] floatValue];
            if (s == 0.0f) {
                NSArray *arr = result[@"data"];
                if (arr==nil) {
                    [self.tableView addSubview:self.titleLab];
                }else{
                    NSMutableArray *arrM =[NSMutableArray array];
                    for (int i=0; i<arr.count; i++) {
                    MyPurceModel *model = [MyPurceModel modelInitWithDic:arr[i]];
                    [arrM addObject:model];
                    }
                    self.resultArray=arrM;
                }
                if (result[@"next_page_url"] != [NSNull null]) {
                    nextUrl =result[@"next_page_url"];
                    [self.tableView.mj_footer resetNoMoreData];
                }else{
                    nextUrl = nil;
                }
                
                [self.tableView.mj_header endRefreshing];
                [self.tableView reloadData];
                self.header.totalMoney.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"myBanlance"];
                NSLog(@"7777777----%@",request);
            }
        }
    } failure:^(YTKBaseRequest *request) {
        //id result = [request responseJSONObject];
    }];
}



//上拉到底部加载更多数据
- (void)loadMoreData:(NSString *) url{
    MyEndOrderApi *api = [[MyEndOrderApi alloc] initWithUrl:url];
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
                NSMutableArray *arrM =[NSMutableArray array];
                for (int i=0; i<ra.count; i++) {
                    MyPurceModel *model = [MyPurceModel modelInitWithDic:ra[i]];
                    [arrM addObject:model];
                }
                self.resultArray=arrM;
//                _resultArray = [ra mutableCopy];
                ra = nil;
//                
                if (result[@"next_page_url"] != [NSNull null]) {
                    nextUrl =result[@"next_page_url"];
                }else{
                    nextUrl = nil;
                }
                
                [self.tableView.mj_footer endRefreshing];
                [self.tableView reloadData];
            }
        }
    } failure:^(YTKBaseRequest *request) {
        NSLog(@"加载失败 -- %@",request);
    }];
}
-(void)setUI{
    self.title =@"我的账户";
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake( 20, 20, 44, 44);
    [backBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;

    
    UITableView *tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-44)];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.tableFooterView =[[UIView alloc]init];
    [self.view addSubview:tableView];
    self.tableView=tableView;
    
    MyPurseheaderView *header =[MyPurseheaderView purseHeaderWithTotalMoney:@"0.00" cashMoney:@"0.00"];
    self.tableView.tableHeaderView=header;
    self.header=header;
    
    
    
    //充值
    UIButton *rechargeBtn =[[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-44, SCREEN_WIDTH, 44)];
    [rechargeBtn setTitle:@"余 额 充 值" forState:UIControlStateNormal];
    [rechargeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rechargeBtn setBackgroundColor:CONTENT_COLOR];
    [rechargeBtn addTarget:self action:@selector(rechargeBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rechargeBtn];
    
}
-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab =[[UILabel alloc]initWithFrame:CGRectMake(0, 130, SCREEN_WIDTH, 35)];
        _titleLab.textColor=[UIColor grayColor];
        _titleLab.text=@"暂无您的消费记录";
        _titleLab.textAlignment=NSTextAlignmentCenter;
    }
    return _titleLab;
}
- (void)backButtonPressed:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark  tableVie delegate dataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.resultArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID =@"cell";
    MyPurceCell *cell =[MyPurceCell cellWithTableView:tableView identifier:ID];
    cell.model=self.resultArray[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark footer 
-(void)rechargeBtnOnClick:(UIButton *)sender{
    RechargeController *rechargeVC =[[RechargeController alloc]init];
    [self.navigationController pushViewController:rechargeVC animated:YES];

}












@end
