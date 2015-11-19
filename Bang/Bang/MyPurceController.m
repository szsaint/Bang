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



#import "MyPurceModel.h"
#import "MyEndOrderApi.h"

@interface MyPurceController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)MyPurseheaderView *header;

@property (nonatomic,strong)NSArray *resultArray;
@property (nonatomic,strong)NSArray *cashArray;//预备提现的数据

@end

@implementation MyPurceController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self setUserDate];
    self.view.backgroundColor=[UIColor redColor];
}
-(void)setUserDate{
    //假数据
    MyPurceModel *model =[[MyPurceModel alloc]init];
    model.getMoney=@"-101";
    model.time =@"11-11 01:00";
    model.place=@"[和平饭店]";
    model.orderNumber =@"15119999456";
    
    MyPurceModel *model1 =[[MyPurceModel alloc]init];
    model1.getMoney=@"现金";
    model1.time =@"11-11 01:00";
    model1.place=@"中国农业银行(张家港支行）";
    model1.orderNumber =@"15119999457";
    
    
    MyPurceModel *model2 =[[MyPurceModel alloc]init];
    model2.getMoney=@"-101";
    model2.time =@"11-11 01:00";
    model2.place=@"张家港朝阳五官科医院";
    model2.orderNumber =@"15119999458";
    
    
    self.resultArray=@[model,model1,model2,model,model1,model2];
    
    [self loadMyEndOrder];
    self.header.totalMoney.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"myBanlance"];
}
-(void)loadMyEndOrder{
    MyEndOrderApi *api =[[MyEndOrderApi alloc]initWithInfo:nil];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        id result =[request responseJSONObject];
        NSLog(@"%@",result);
    } failure:^(YTKBaseRequest *request) {
        id result =[request responseJSONObject];
        NSLog(@"%@",result);
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
