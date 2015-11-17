//
//  ExperienceViewController.m
//  iBang
//
//  Created by 龙斐 on 15/6/29.
//  Copyright (c) 2015年 kiwi. All rights reserved.
//

#import "ExperienceViewController.h"
#import "TickCell.h"
#import "LoadTickets.h"
#import "GetTickViewController.h"

@interface ExperienceViewController ()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>

- (void)initUserDataSource;
- (void)initUserInterface;

@end

@implementation ExperienceViewController{
    UITableView *_mainTableView;
    NSArray *_resultArray;
    UIButton *_getTickBtn;
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
    [self loadTicksData];
}

- (void)initUserInterface
{
//    UIView *topView = [[UIView alloc] init];
//    topView.frame = CGRectMake( 0, 0, SCREEN_WIDTH, 64);
//    topView.backgroundColor = [UIColor whiteColor];
//    topView.alpha = 0.975f;
//    [self.view addSubview:topView];
    
    UILabel *topicLabel = [[UILabel alloc] init];
    topicLabel.frame = CGRectMake( (SCREEN_WIDTH - 150)/2, 32, 150, 20);
    topicLabel.text = @"优惠代驾体验";
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
    
    _getTickBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-64, 27, 30, 30)];
    [_getTickBtn setBackgroundColor: [UIColor blackColor]];
    [_getTickBtn setTitle:@"领" forState:UIControlStateNormal];
    _getTickBtn.layer.masksToBounds = YES;
    _getTickBtn.layer.cornerRadius = 15;
    [_getTickBtn addTarget:self action:@selector(getTick) forControlEvents:UIControlEventTouchUpInside];
//    [topView addSubview:_getTickBtn];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_getTickBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.showsHorizontalScrollIndicator = NO;
    _mainTableView.showsVerticalScrollIndicator = NO;
    _mainTableView.backgroundColor = RGB(19, 20, 37, 1);
    [self.view addSubview:_mainTableView];
}

-(void)getTick{
    GetTickViewController *vc = [[GetTickViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    NSLog(@"领");
}


-(void)loadTicksData{
    LoadTickets *api = [[LoadTickets alloc] init];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        if (request) {
            //json如下
            id result = [request responseJSONObject];
            float s = [result[@"rst"] floatValue];
            if (s == 0.0f) {
                _resultArray = result[@"data"];
               [_mainTableView reloadData];
            }else{
                
            }
        }
    } failure:^(YTKBaseRequest *request) {
        NSLog(@"加载失败 -- ");
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    return [_resultArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"tickcell";
    NSArray *tempArray = _resultArray[indexPath.row][@"coupon"];
    TickCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[TickCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    cell.tickId = _resultArray[indexPath.row][@"id"];
    cell.type = [tempArray valueForKey:@"type"];
    cell.name.text = [tempArray valueForKey:@"title"];
    NSString *tt = [self formateDate:_resultArray[indexPath.row][@"expire_at"]];
    NSString *t = @"有效期至\n";
    cell.time.text =[t stringByAppendingString:tt];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = RGB(19, 20, 37, 1);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)backButtonPressed:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (NSString *)formateDate:(NSString *)dateString
{
    
    @try {
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSDate * nowDate = [NSDate date];
        
        /////  将需要转换的时间转换成 NSDate 对象
        NSDate * needFormatDate = [dateFormatter dateFromString:dateString];
        /////  取当前时间和转换时间两个日期对象的时间间隔
        /////  这里的NSTimeInterval 并不是对象，是基本型，其实是double类型，是由c定义的:  typedef double NSTimeInterval;
        NSTimeInterval time = [nowDate timeIntervalSinceDate:needFormatDate];
        
        //// 再然后，把间隔的秒数折算成天数和小时数：
        
        NSString *dateStr = @"";
        if(time<=0){
        if(time>=-60*60){  ////  一个小时以内的
            dateStr = @"即将过期";
            
        }else {
            dateStr = [dateString substringToIndex:9];
        }
        }else{
            dateStr = @"已过期";
        }
        
        return dateStr;
    }
    @catch (NSException *exception) {
        return @"";
    }
    
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
