//
//  ViewController.m
//  TripDemo
//
//  Created by xiaoming han on 15/4/2.
//  Copyright (c) 2015年 AutoNavi. All rights reserved.
//

#import "MainViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import "DDLocation.h"
#import "DDSearchManager.h"
#import "PlaceViewController.h"
#import "DDDriverManager.h"
#import "DDLocationView.h"
#import "SaintAnnotation.h"
#import "SaintAnnotationView.h"
#import "ExperienceViewController.h"
#import "ServicePriceViewController.h"
#import "AboutViewController.h"
#import "MyOrdersViewController.h"

#import "Toast+UIView.h"
#import "MovingAnnotationView.h"

#import "MainLeftView.h"
#import "BangPersonController.h"
#import "LoginViewController.h"

#import "GetUserInfoApi.h"
#import "UserLoginApi.h"
#import "CreateOrder.h"
#import <SDWebImage/UIImageView+WebCache.h>

typedef NS_ENUM(NSUInteger, DDState) {
    DDState_Init = 0,  //初始状态，显示选择终点
    DDState_Confirm_Destination, //选定起始点和目的地，显示马上叫车
    DDState_Call_Taxi, //正在叫车，显示我已上车
    DDState_On_Taxi, //正在车上状态，显示支付
    DDState_Finish_pay //到达终点，显示评价
};

#define kLocationViewMargin     20
#define kButtonMargin           20
#define kButtonHeight           40
#define kAppName                @"i帮"

@interface MainViewController ()<MAMapViewDelegate,PlaceViewControllerDelegate, DDDriverManagerDelegate, DDLocationViewDelegate,UIGestureRecognizerDelegate,MainLeftViewDelegate,KIWIAlertViewDelegate,AMapSearchDelegate>
{
    MAMapView *_mapView;
    UIView * _messageView;
    UIImageView *_centerView;
    DDDriverManager * _driverManager;
    NSArray * _drivers;
    MAPointAnnotation * _selectedDriver;
    AMapSearchAPI *_search;
    UIButton *_buttonAction;
    UIButton *_buttonCancel;
    UIButton *_buttonLocating;
    
    int _currentSearchLocation; //0 start, 1 end
    BOOL _needsFirstLocating;
}

@property (nonatomic, strong) DDLocation * currentLocation;
@property (nonatomic, strong) DDLocation * destinationLocation;

@property (nonatomic, assign) DDState state;

@property (nonatomic, strong) DDLocationView *locationView;
@property (nonatomic, assign) BOOL isLocating;

@property (nonatomic,strong)MainLeftView *leftView;
@property (nonatomic,strong)Cover *cover;

@end

@implementation MainViewController

#pragma mark - search
- (void)searchReGeocodeWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    
    regeo.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    regeo.requireExtension = YES;
    
    __weak __typeof(&*self) weakSelf = self;
    [[DDSearchManager sharedInstance] searchForRequest:regeo completionBlock:^(id request, id response, NSError *error) {
        if (error)
        {
            NSLog(@"error :%@", error);
        }
        else
        {
            AMapReGeocodeSearchResponse * regeoResponse = response;
            if (regeoResponse.regeocode != nil)
            {
                if (regeoResponse.regeocode.pois.count > 0)
                {
                    AMapPOI *poi = regeoResponse.regeocode.pois[0];
                    
                    weakSelf.currentLocation.coordinate = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
                    weakSelf.currentLocation.name = poi.name;
                    
                    weakSelf.currentLocation.address = poi.address;
                }
                else
                {
                    weakSelf.currentLocation.coordinate = CLLocationCoordinate2DMake(regeoResponse.regeocode.addressComponent.streetNumber.location.latitude, regeoResponse.regeocode.addressComponent.streetNumber.location.longitude);
                    weakSelf.currentLocation.name = [NSString stringWithFormat:@"%@%@%@%@%@", regeoResponse.regeocode.addressComponent.township, regeoResponse.regeocode.addressComponent.neighborhood, regeoResponse.regeocode.addressComponent.streetNumber.street, regeoResponse.regeocode.addressComponent.streetNumber.number, regeoResponse.regeocode.addressComponent.building];
                    
                    weakSelf.currentLocation.address = regeoResponse.regeocode.formattedAddress;
                }
                
                weakSelf.currentLocation.cityCode = regeoResponse.regeocode.addressComponent.citycode;
                weakSelf.isLocating = NO;
                NSLog(@"currentLocation:%@", weakSelf.currentLocation);
            }
        }
    }];
}

-(void)initCenterView{
    UIImage *image = [UIImage imageNamed:@"中心"];
    _centerView = [[UIImageView alloc] initWithImage:image];
    
    _centerView.frame = CGRectMake(self.view.bounds.size.width/2-image.size.width/2, _mapView.bounds.size.height/2-image.size.height, image.size.width, image.size.height);
    
    _centerView.center = CGPointMake(CGRectGetWidth(self.view.bounds) / 2, CGRectGetHeight(_mapView.bounds) / 2 - CGRectGetHeight(_centerView.bounds) / 2);
    
    [self.view addSubview:_centerView];
}

#pragma mark - mapView delegate

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if (_needsFirstLocating && updatingLocation)
    {
        [self actionLocating:nil];
        _needsFirstLocating = NO;
    }
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[SaintAnnotation class]]){
        NSString * identifier = @"saintannotation";
        SaintAnnotationView *saintAnnotationView = nil;
        if (saintAnnotationView == nil) {
            saintAnnotationView = [[SaintAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        }
        else{
            DDLogDebug(@"%@",[annotation class]);
        }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPaoPao:)];
        [saintAnnotationView addGestureRecognizer:tap];
        return saintAnnotationView;
    }
    
    return nil;
}

//点击司机气泡
- (void)tapPaoPao:(UIGestureRecognizer *)gesture{
    DDLogError(@"点击了");
}

/**
 *  初始化导航栏
 *
 *  @return void
 */
-(void)initNavigaBar{
    self.title = kAppName;
    
    UIButton *personBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    personBtn.frame = CGRectMake(0, 0, 30, 30);
    [personBtn setImage:[UIImage imageNamed:@"用户"] forState:UIControlStateNormal];
    [personBtn addTarget:self action:@selector(openMenu) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:personBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
}

-(void)openMenu{
    [_leftView showInVisble];
    [_cover coverShowAnimated];
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //self.title = kAppName;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    _needsFirstLocating = YES;
    _isLocating = NO;
    _currentSearchLocation = -1;
    
    _mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    [_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
    [_mapView setZoomLevel:16.1 animated:YES];
    _mapView.showsCompass = NO;
    _mapView.showsScale = NO;
    [self.view addSubview:_mapView];
    
    UIScreenEdgePanGestureRecognizer *edgePan =[[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(edgePan:)];
    edgePan.edges=UIRectEdgeLeft;
    edgePan.delegate=self;
    [_mapView addGestureRecognizer:edgePan];
    
    _driverManager = [[DDDriverManager alloc] init];
    _driverManager.delegate = self;
    
    // controls
    _buttonAction = [UIButton buttonWithType:UIButtonTypeCustom];
    _buttonAction.backgroundColor = SYSTEM_COLOR_GREEN;
    _buttonAction.layer.cornerRadius = 6;
    _buttonAction.layer.shadowColor = [UIColor blackColor].CGColor;
    _buttonAction.layer.shadowOffset = CGSizeMake(1, 1);
    _buttonAction.layer.shadowOpacity = 0.5;
    
    [self.view addSubview:_buttonAction];
    
    _buttonCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    _buttonCancel.backgroundColor = [UIColor colorWithWhite:0.25 alpha:1.0];
    _buttonCancel.layer.cornerRadius = 6;
    _buttonCancel.layer.shadowColor = [UIColor blackColor].CGColor;
    _buttonCancel.layer.shadowOffset = CGSizeMake(1, 1);
    _buttonCancel.layer.shadowOpacity = 0.5;
    [_buttonCancel setTitle:@"取  消" forState:UIControlStateNormal];

    [_buttonCancel addTarget:self action:@selector(actionCancel:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_buttonCancel];
    
   
    _buttonLocating = [UIButton buttonWithType:UIButtonTypeCustom];
    [_buttonLocating setImage:[UIImage imageNamed:@"定位"] forState:UIControlStateNormal];
    _buttonLocating.backgroundColor = [UIColor whiteColor];
    _buttonLocating.layer.cornerRadius = 6;
    _buttonLocating.layer.shadowColor = [UIColor blackColor].CGColor;
    _buttonLocating.layer.shadowOffset = CGSizeMake(1, 1);
    _buttonLocating.layer.shadowOpacity = 0.5;
    
    [_buttonLocating addTarget:self action:@selector(actionLocating:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_buttonLocating];
    
    _currentLocation = [[DDLocation alloc] init];
    _locationView = [[DDLocationView alloc] initWithFrame:CGRectMake(kLocationViewMargin, kLocationViewMargin, CGRectGetWidth(self.view.bounds) - kLocationViewMargin * 2, 44)];
    _locationView.delegate = self;
    _locationView.startLocation = _currentLocation;
    
    [self.view addSubview:_locationView];

    [self setState:DDState_Init];
    [self initUserLoginInformation];
    //添加监听登陆成功的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginSuccess) name:@"loginSuccess" object:nil];
    //添加退出登陆的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(exitLogin) name:@"exitLogin" object:nil];
    //重新加载用户信息的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadUserInfo) name:@"reloadUserInfo" object:nil];
    [self initNavigaBar];
}

/* 移动窗口弹一下的动画 */
- (void)myPointAnimimate
{
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         CGPoint center = _centerView.center;
                         center.y -= 20;
                         [_centerView setCenter:center];}
                     completion:nil];
    
    [UIView animateWithDuration:0.45
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         CGPoint center = _centerView.center;
                         center.y += 20;
                         [_centerView setCenter:center];
                     }
                     completion:nil];
}


-(void)viewWillAppear:(BOOL)animated{
    //[self initUserLoginInformation];
    if (!_centerView) {
        [self initCenterView];
    }
    
    if (!self.leftView) {
        self.leftView =[MainLeftView shareInstance];
        self.cover=[Cover creatHideCover];
        self.leftView.leftViewDelegate=self;
        [self.leftView showInSide];
    }
    //可以在这里发送请求更改用户的余额

}

-(void)initSearchAPI{
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    
}

- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    [self searchAddress:mapView.centerCoordinate];
    [self myPointAnimimate];
}

-(void)searchAddress:(CLLocationCoordinate2D) coordinate{
    //构造AMapReGeocodeSearchRequest对象
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    regeo.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    regeo.requireExtension = YES;
    //发起逆地理编码
    [_search AMapReGoecodeSearch: regeo];
}

//实现逆地理编码的回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if(response.regeocode != nil)
    {
        //通过AMapReGeocodeSearchResponse对象处理搜索结果
        //        NSString *result = [NSString stringWithFormat:@"ReGeocode: %@", response.regeocode];
        //        NSLog(@"ReGeo: %@", result);
        if ([response.regeocode.pois count]>0) {
            AMapPOI *poi = response.regeocode.pois[0];
           // NSString *addr = [NSString stringWithFormat:@"出发地点：%@",[poi name]];
            DDLocation *location = [[DDLocation alloc] init];
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
            location.coordinate = coordinate;
            location.name = poi.name;
            location.cityCode = poi.citycode;
            location.address = poi.address;
            _currentLocation = location;
            _locationView.startLocation = location;
        }
        
    }
}

-(void)loginSuccess{
    //登陆
    [self initUserLoginInformation];
}
-(void)exitLogin{
    //置空用户信息
    [self.leftView.headerView deleteDate];
    
}
-(void)iconChange{
    [self.leftView.headerView reloadIcon];
}

-(void)edgePan:(UIScreenEdgePanGestureRecognizer *)sender{
    //获取偏移量
    CGPoint offsetP =[sender translationInView:_mapView];
    //获取x轴的偏移量
    CGFloat offsetX =offsetP.x;
    //最新位置
    if (offsetX>=0.8*SCREEN_WIDTH) {
        offsetX=0.8*SCREEN_WIDTH;
    }
    self.leftView.transform=CGAffineTransformMakeTranslation(offsetX, 0);
    if (sender.state==UIGestureRecognizerStateCancelled||sender.state==UIGestureRecognizerStateEnded||sender.state==UIGestureRecognizerStateFailed) {
        if (offsetX<0.3*SCREEN_WIDTH) {
            [UIView animateWithDuration:0.25 animations:^{
                self.leftView.transform=CGAffineTransformIdentity;
            }];
        }else{
            CGFloat duration =1/(0.8*SCREEN_WIDTH/offsetX)*0.5;
            [UIView animateWithDuration:duration animations:^{
                self.leftView.transform=CGAffineTransformMakeTranslation(0.8*SCREEN_WIDTH, 0);
            }];
            
            [self.cover coverShowAnimated];
        }
    }
}

//触发优先级
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    BOOL result = NO;
    
    if ([gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
        result = YES;
    }
    return result;
}

#pragma mark  leftViewdelegate

-(void)leftView:(MainLeftView *)lefteView didSelectedHeader:(LeftHeaderView *)header{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:kUserName]) {
        //说明已经登陆成功
        BangPersonController *personVC =[[BangPersonController alloc]init];
        [self.cover hideWhenPush];
        [self.navigationController pushViewController:personVC animated:YES];
        
    }else{
        //说明时未登录状态
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self.cover hideWhenPush];
        [self.navigationController pushViewController:loginVC animated:YES];
        
    }
}

-(void)leftView:(MainLeftView *)leftView didSelectedItemAtIndex:(NSInteger)index{
    NSLog(@"%ld",(long)index);
    [UIView animateWithDuration:0.5 animations:^{
        _leftView.transform =CGAffineTransformIdentity;
    }];
    [_cover coverHideAnimated];
    switch (index) {
        case 0:
        {
            MyOrdersViewController *vc = [[MyOrdersViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            ExperienceViewController *vc = [[ExperienceViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            ServicePriceViewController *vc = [[ServicePriceViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {
            
        }
            break;
        case 4:
        {
            AboutViewController *vc = [[AboutViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}


//加载用户信息
- (void)loadUserInfo {
    GetUserInfoApi *getUserInfoApi = [[GetUserInfoApi alloc] initWithUserId:@"0"];
    [getUserInfoApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        if (request) {
            //json如下
            id result = [request responseJSONObject];
            if ([request responseStatusCode] == 200 && [result[@"rst"] floatValue] == 0.f) {
                NSMutableArray *userInfoArray = result[@"data"];
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                [userDefault setValue:[userInfoArray cy_stringKey:@"id"] forKey:kUserID];
                [userDefault synchronize];
                NSString *username =[userInfoArray valueForKey:@"username"];
                self.leftView.headerView.phoneNumber=username;
                NSString *banlance =[userInfoArray valueForKey:@"recharge"];
                self.leftView.headerView.banlance=banlance;
                
                [self saveUserInfo:userInfoArray];
                
                if ([userInfoArray valueForKey:@"avatar"] != [NSNull null]) {
                    NSString *url = [kServiceUrl stringByAppendingString:[userInfoArray valueForKey:@"avatar"]];
                    
                    [self.leftView.headerView.userIcon sd_setImageWithURL:[NSURL URLWithString:url]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        [self saveImage:image];
                    }];
                    
                }
            }
        }
    } failure:^(YTKBaseRequest *request) {
        NSLog(@"加载失败 -- %@",request);
    }];
}
-(void)saveUserInfo:(NSArray *)userinfoArray{
    NSUserDefaults *userdefault =[NSUserDefaults standardUserDefaults];
    NSString *myName =[userinfoArray valueForKey:@"name"];//昵称
    NSString *mySex;//性别
    if ([userinfoArray valueForKey:@"sex"]!=[NSNull null]) {
        mySex =[userinfoArray valueForKey:@"sex"];
    }
    NSString *myBalance =[userinfoArray valueForKey:@"recharge"];//余额
    if ([userinfoArray valueForKey:@"birthday"]!=[NSNull null]) {
        NSString *birthday =[userinfoArray valueForKey:@"birthday"];
        [userdefault setObject:birthday forKey:@"myBirthDay"];
        //[userdefault synchronize];
    }
    [userdefault setObject:myName forKey:@"myName"];
    //[userdefault synchronize];
    
    [userdefault setObject:mySex forKey:@"mySex"];
    //[userdefault synchronize];
    
    [userdefault setObject:myBalance forKey:@"myBalance"];
    [userdefault synchronize];
    
    
}
-(void)saveImage:(UIImage *)editImage{
    //拿到图片
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths lastObject];
    //设置一个图片的存储路径
    NSString *imagePath = [path stringByAppendingPathComponent:@"icon.png"];
    //把图片直接保存到指定的路径（同时应该把图片的路径imagePath存起来，下次就可以直接用来取）
    [UIImagePNGRepresentation(editImage) writeToFile:imagePath atomically:YES];
    
}

- (void)alertView:(KIWIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView tag] == 0) {
        if (buttonIndex == 1) {
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            [self.navigationController pushViewController:loginVC animated:YES];
        }
    }
}

- (void)initUserLoginInformation
{
    NSUserDefaults *iBangKey = [NSUserDefaults standardUserDefaults];
    NSString *passWordStr = (NSString *)[iBangKey valueForKey:kPassword];
    NSString *userNameStr = (NSString *)[iBangKey valueForKey:kUserName];
    if (userNameStr && passWordStr) {
        UserLoginApi *userLoginApi = [[UserLoginApi alloc] initWithUsername:userNameStr password:passWordStr];
        [userLoginApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            if (request) {
                id result = [request responseJSONObject];
                if ([request responseStatusCode] == 200 && [result[@"rst"] floatValue] == 0.f) {
                    //delegate.isLogin = YES;
                    DDLogDebug(@"登录成功-- %@",request);
                    [self updatingDrivers];
                    //加载用户信息
                    [self loadUserInfo];
                }else{
                    
                }
            }
        } failure:^(YTKBaseRequest *request) {
            id result = [request responseJSONObject];
            DDLogError(@"登录失败 -- %@",request);
        }];
    }}


- (void)viewDidAppear:(BOOL)animated
{
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    [self initSearchAPI];
}

- (void)viewWillDisappear:(BOOL)animated
{
    _mapView.showsUserLocation = NO;
    _mapView.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    _mapView.frame = self.view.bounds;
    
    _buttonCancel.frame = CGRectMake(kButtonMargin, CGRectGetHeight(self.view.bounds) - kButtonMargin - kButtonHeight, CGRectGetMaxX(self.view.bounds) - kButtonMargin * 2, kButtonHeight);
    
    _buttonAction.frame = CGRectMake(kButtonMargin, CGRectGetMinY(_buttonCancel.frame) - kButtonMargin / 2.0 - kButtonHeight, CGRectGetMaxX(self.view.bounds) - kButtonMargin * 2, kButtonHeight);
    
    _buttonLocating.frame = CGRectMake(kButtonMargin, CGRectGetMinY(_buttonAction.frame) - kButtonMargin - kButtonHeight, kButtonHeight, kButtonHeight);
}

#pragma mark - Action

- (void)actionAddEnd:(UIButton *)sender
{
    NSLog(@"actionAddEnd");
    
//    if (_currentLocation.cityCode.length == 0)
//    {
//        NSLog(@"the city have not been located");
//        return;
//    }
//    
    _currentSearchLocation = 1;
    PlaceViewController *choosePlace = [[PlaceViewController alloc] init];
    choosePlace.searchDelegate = self;
    
    [self.navigationController pushViewController:choosePlace animated:YES];
}

- (void)actionCancel:(UIButton *)sender
{
    NSLog(@"actionCancel");
    [self setState:DDState_Init];
}

- (void)actionCallTaxi:(UIButton *)sender
{
    NSLog(@"actionCallTaxi");
    if (self.currentLocation && self.destinationLocation)
    {
//        DDTaxiCallRequest * request = [[DDTaxiCallRequest alloc] initWithStart:self.currentLocation to:self.destinationLocation];
//        [_driverManager callTaxiWithRequest:request];
//        
//        _messageView = [_mapView viewForMessage:@"正在呼叫司机..." title:nil image:nil];
//        _messageView.center = [_mapView centerPointForPosition:@"center" withToast:_messageView];
//        [_mapView addSubview:_messageView];
        [self createOrder:nil];
        
    }
}

- (void) createOrder:(NSString *)serveId{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *d = [[NSMutableDictionary alloc] init];
    [d setObject:[NSString stringWithFormat:@"%.6f",_currentLocation.coordinate.latitude] forKey:@"lat"];
    [d setObject:[NSString stringWithFormat:@"%.6f",_currentLocation.coordinate.longitude] forKey:@"lng"];
    if (serveId) {
        [dic setObject:serveId forKey:@"server_id"];
    }
    [dic setObject:@"driver" forKey:@"type"];
    [dic setObject:_currentLocation.name forKey:@"address"];
    [dic setObject:d forKey:@"detail"];
    [dic setObject:[self getCurrentTime] forKey:@"appointment"];
    [dic setObject:@"ios" forKey:@"client_device"];
    NSLog(@"%@",dic);
    CreateOrder *api = [[CreateOrder alloc] initWithOrder:dic];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        if (request) {
            id json = [request responseJSONObject];
            float s = [json[@"rst"] floatValue];
            if (s == 0.0f) {
                
            }
            NSLog(@"ok");
        }
    } failure:^(YTKBaseRequest *request) {
        id json = [request responseJSONObject];
        NSLog(@"%@",json);
    }];
}

    /**
     *  获取当前时间
     *
     *  @return NSString
     */
-(NSString *)getCurrentTime{
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *locationString=[dateformatter stringFromDate:[NSDate date]];
    return locationString;
}

- (void)actionLocating:(UIButton *)sender
{
    NSLog(@"actionLocating");
    
    // 只有初始状态下才可以进行定位。
    if (_state != DDState_Init)
    {
        [self.view makeToast:@"请先取消呼叫代驾" duration:2.0 position:@"center"];
        return;
    }
    
    if (!_isLocating)
    {
        _isLocating = YES;
        
        [self resetMapToCenter:_mapView.userLocation.location.coordinate];
        [self searchReGeocodeWithCoordinate:_mapView.userLocation.location.coordinate];
        
    }
}

- (void)actionOnTaxi:(UIButton *)sender
{
    NSLog(@"actionOnTaxi");
    [self setState:DDState_On_Taxi];
}

- (void)actionOnPay:(UIButton *)sender
{
    NSLog(@"actionOnPay");
    [self setState:DDState_Finish_pay];
}

- (void)actionOnEvaluate:(UIButton *)sender
{
    NSLog(@"actionOnEvaluate");
    [self setState:DDState_Init];
}

#pragma mark - drivers
- (void)updatingDrivers
{
//#define latitudinalRangeMeters 1000.0
//#define longitudinalRangeMeters 1000.0
//    
//    MAMapRect rect = MAMapRectForCoordinateRegion(MACoordinateRegionMakeWithDistance(_mapView.centerCoordinate, latitudinalRangeMeters, longitudinalRangeMeters));
    
    [_driverManager searchDriversWithinMapRect:_mapView.userLocation.location.coordinate];
}

#pragma mark - driversManager delegate

- (void)searchDoneInMapRect:(MAMapRect)mapRect withDriversResult:(NSArray *)drivers timestamp:(NSTimeInterval)timestamp
{
    [_mapView removeAnnotations:_drivers];
    
    NSMutableArray * currDrivers = [NSMutableArray arrayWithCapacity:[drivers count]];
    [drivers enumerateObjectsUsingBlock:^(DDDriver * obj, NSUInteger idx, BOOL *stop) {
        SaintAnnotation *driverAnnotation = [[SaintAnnotation alloc] init];
        driverAnnotation.coordinate = obj.coordinate;
        [driverAnnotation setTag:obj.tag];
        driverAnnotation.title = @" ";
        [currDrivers addObject:driverAnnotation];
    }];

    [_mapView addAnnotations:currDrivers];
    
    _drivers = currDrivers;
}

- (void)callTaxiDoneWithRequest:(DDTaxiCallRequest *)request Taxi:(DDDriver *)driver
{
    [_mapView removeAnnotations:_drivers];
    
    _selectedDriver = [[MAPointAnnotation alloc] init];
    _selectedDriver.coordinate = driver.coordinate;
    _selectedDriver.title = driver.idInfo;
    [_mapView addAnnotation:_selectedDriver];
    
    [_messageView removeFromSuperview];
    [_mapView makeToast:[NSString stringWithFormat:@"已选择司机%@",driver.idInfo, nil] duration:0.5 position:@"center"];
    
    [self setState:DDState_Call_Taxi];
}

- (void)onUpdatingLocations:(NSArray *)locations forDriver:(DDDriver *)driver
{
    if ([locations count] > 0) {

        [_mapView selectAnnotation:_selectedDriver animated:NO];
        _selectedDriver.coordinate = ((CLLocation*) [locations lastObject]).coordinate;
        
        CLLocationCoordinate2D * locs = (CLLocationCoordinate2D *)malloc(sizeof(CLLocationCoordinate2D) * [locations count]);
        [locations enumerateObjectsUsingBlock:^(CLLocation * obj, NSUInteger idx, BOOL *stop) {
            locs[idx] = obj.coordinate;
        }];
        
        MovingAnnotationView * driverView = (MovingAnnotationView *)[_mapView viewForAnnotation:_selectedDriver];
        
        [driverView addTrackingAnimationForCoordinates:locs count:[locations count] duration:2.0];
        
        free(locs);
    }
}

#pragma mark - DDSearchViewControllerDelegate

- (void)searchViewController:(PlaceViewController *)searchViewController didSelectLocation:(DDLocation *)location
{
    NSLog(@"location: %@", location);
    [self.navigationController popViewControllerAnimated:YES];
    if (_currentSearchLocation == 0)
    {
        _currentLocation = location;
        _locationView.startLocation = location;
    }
    else if (_currentSearchLocation == 1)
    {
        _destinationLocation = location;
        _locationView.endLocation = location;
    }
    _currentSearchLocation = -1;
    
    // 起点终点都确认
    if (_currentLocation && _destinationLocation)
    {
        [self setState:DDState_Confirm_Destination];
    }
}

#pragma mark - Utility

- (void)requestPathInfo
{
    //检索所需费用
    AMapDrivingRouteSearchRequest *navi = [[AMapDrivingRouteSearchRequest alloc] init];
    //navi.searchType       = AMapNearbySearchTypeDriving;
    navi.requireExtension = YES;
    
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:_currentLocation.coordinate.latitude
                                           longitude:_currentLocation.coordinate.longitude];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:_destinationLocation.coordinate.latitude
                                                longitude:_destinationLocation.coordinate.longitude];
    navi.strategy = 2;//距离优先
    navi.requireExtension = YES;
    
    //发起路径搜索
    [_search AMapDrivingRouteSearch: navi];
    
//    [[DDSearchManager sharedInstance] searchForRequest:navi completionBlock:^(id request, id response, NSError *error) {
//        
//        
//    }];
}

- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response{
    __weak __typeof(&*self) weakSelf = self;
    AMapRouteSearchResponse * naviResponse = response;
    
    if (naviResponse.route == nil)
    {
        [weakSelf.locationView setInfo:@"获取路径失败"];
        return;
    }
    AMapPath * path = [naviResponse.route.paths firstObject];
    [weakSelf.locationView setInfo:[NSString stringWithFormat:@"%@  距离%.1f km  时间%.1f分钟", [self getMoneynum:path.distance], path.distance / 1000.f, path.duration / 60.f, nil]];
}

-(NSString *)getMoneynum:(NSInteger) distance{
    CGFloat m = 0;
    if (distance<=3000) {
        m = 39;
    }else{
        int dis = [[NSString stringWithFormat:@"%li",(long)distance] intValue]-3000;
        int i = 1;
        if (dis>3000) {
            i = (dis-((dis/3000)*3000))>0 ? dis/3000+1 : dis/3000;
        }
        m = 39+20*i;
    }
    NSString *text = [NSString stringWithFormat:@"预估费用%.2f元",m];
    return text;
}

- (void)setState:(DDState)state
{
    _state = state;
    
    switch (state)
    {
        case DDState_Init:
            [self reset];
            
            [_buttonAction setTitle:@"选择终点" forState:UIControlStateNormal];
            [_buttonAction removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
            [_buttonAction addTarget:self action:@selector(actionAddEnd:) forControlEvents:UIControlEventTouchUpInside];
            break;
            
        case DDState_Confirm_Destination:
            [self requestPathInfo];
            
            [_buttonAction setTitle:@"呼叫代驾" forState:UIControlStateNormal];
            [_buttonAction removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
            [_buttonAction addTarget:self action:@selector(actionCallTaxi:) forControlEvents:UIControlEventTouchUpInside];

            break;
        case DDState_Call_Taxi:
            [_buttonAction setTitle:@"我已上车" forState:UIControlStateNormal];
            [_buttonAction removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];

            [_buttonAction addTarget:self action:@selector(actionOnTaxi:) forControlEvents:UIControlEventTouchUpInside];

            break;
        case DDState_On_Taxi:
            [_buttonAction setTitle:@"支付" forState:UIControlStateNormal];
            [_buttonAction removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];

            [_buttonAction addTarget:self action:@selector(actionOnPay:) forControlEvents:UIControlEventTouchUpInside];
            break;
            
        case DDState_Finish_pay:
            [_buttonAction setTitle:@"评价" forState:UIControlStateNormal];
            [_buttonAction removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];

            [_buttonAction addTarget:self action:@selector(actionOnEvaluate:) forControlEvents:UIControlEventTouchUpInside];
            break;

        default:
            break;
    }
    
    // 设置locationView是否响应交互。
    _locationView.userInteractionEnabled = state < DDState_Call_Taxi;
    _buttonCancel.hidden = state == DDState_Init;
}

- (void)reset
{
    [_mapView removeAnnotations:_drivers];
    [_mapView removeAnnotation:_selectedDriver];
    
    _needsFirstLocating = YES;
    _destinationLocation = nil;
    _locationView.endLocation = nil;
    _locationView.info = nil;
}

- (void)resetMapToCenter:(CLLocationCoordinate2D)coordinate
{
    _mapView.centerCoordinate = coordinate;
    _mapView.zoomLevel = 15.1;
    
    // 使得userLocationView在最前。
    [_mapView selectAnnotation:_mapView.userLocation animated:YES];
}

#pragma mark - DDLocationViewDelegate

- (void)didClickStartLocation:(DDLocationView *)locationView
{
    _currentSearchLocation = 0;
    PlaceViewController *choosePlace = [[PlaceViewController alloc] init];
    choosePlace.searchDelegate = self;
    
    [self.navigationController pushViewController:choosePlace animated:YES];
}

- (void)didClickEndLocation:(DDLocationView *)locationView
{
    _currentSearchLocation = 1;
    PlaceViewController *choosePlace = [[PlaceViewController alloc] init];
    choosePlace.searchDelegate = self;
    [self.navigationController pushViewController:choosePlace animated:YES];
}


@end
