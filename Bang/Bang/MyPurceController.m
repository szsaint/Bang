//
//  MyPurceController.m
//  BangDriver
//
//  Created by wl on 15/11/11.
//  Copyright © 2015年 saint. All rights reserved.
//

#import "MyPurceController.h"
#import "RichCashController.h"

#import "MyPurseheaderView.h"
#import "MyPurceFootView.h"
#import "MyPurceCell.h"
#import "BangActionSheet.h"


#import "MyPurceModel.h"

@interface MyPurceController ()<UITableViewDelegate,UITableViewDataSource,MyPurceFootViewDelegate,UIActionSheetDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSArray *resultArray;

@end

@implementation MyPurceController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    
    self.view.backgroundColor=[UIColor redColor];
    [self setUI];
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
    
    MyPurseheaderView *header =[MyPurseheaderView purseHeaderWithTotalMoney:@"800.05" cashMoney:@"600.12"];
    self.tableView.tableHeaderView=header;
    
    MyPurceFootView *footer =[[MyPurceFootView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-44, SCREEN_WIDTH, 44)];
    footer.delegate=self;
    [self.view addSubview:footer];
    
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
#pragma mark footer delegate

-(void)MyPurceFootView:(MyPurceFootView *)footerView didSelectedRichCashBtn:(UIButton *)richCash{
    RichCashController *richCashVC =[[RichCashController alloc]init];
    [self.navigationController pushViewController:richCashVC animated:YES];
}

-(void)MyPurceFootView:(MyPurceFootView *)footerView didSelectedTopUp:(UIButton *)topUp{
    BangActionSheet *sheet =[[BangActionSheet alloc]initWithTitle:@"充值方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"微信充值",@"支付宝充值", nil];
    sheet.tintColor=CONTENT_COLOR;
    [sheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%ld",(long)buttonIndex);
}









@end
