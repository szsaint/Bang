//
//  ViewController.m
//  Bang
//
//  Created by yyx on 15/11/11.
//  Copyright © 2015年 saint. All rights reserved.
//

#import "ViewController.h"
#import "NearbyServers.h"
#import "LocationCommon.h"
#import "SaintAnnotation.h"
#import "SaintAnnotationView.h"
#import "UserLoginApi.h"
#import "GetUserInfoApi.h"
#import "LoginViewController.h"
#import <AMapSearchKit/AMapSearchAPI.h>
#import "PlaceViewController.h"
#import "MainLeftView.h"
#import "BangPersonController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ViewController ()<MAMapViewDelegate,KIWIAlertViewDelegate,AMapSearchDelegate,UIGestureRecognizerDelegate,MainLeftViewDelegate,
MainViewControllerDelegate>
{
    MAMapView *_mapView;
    NSArray * _drivers;
    MAUserLocation *_userLocation;
    UIButton *_buttonLocating;
    AMapSearchAPI *_search;
    UIImageView *_centerView;
    UIButton *_fromBtn;
    UIButton *_toBtn;
    UIButton *_nowPrice;
    UIButton *_callDriver;
    CLLocationCoordinate2D _startLocation;
    CLLocationCoordinate2D _endLocation;
    BOOL _isSetFrom;
}

@property (nonatomic,strong)MainLeftView *leftView;
@property (nonatomic,strong)Cover *cover;

@end

@implementation ViewController

typedef NS_ENUM(NSUInteger, DDState) {
    DDState_Init = 0,  //初始状态，显示选择终点
    DDState_PrePare,//选好目的地等待下单
    DDState_OrderIn,//已下单等待接单
    DDState_PreInCar,//已接单等待上车
    DDState_InCar,//已上车
    DDState_PrePay,//等待支付
    DDState_PrePF,//等待评价
};

- (void)initMAMap{
    [MAMapServices sharedServices].apiKey = kAMapKey;
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
    [_mapView setZoomLevel:16.1 animated:YES];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    [self.view addSubview:_mapView];
    
    UIScreenEdgePanGestureRecognizer *edgePan =[[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(edgePan:)];
    edgePan.edges=UIRectEdgeLeft;
    edgePan.delegate=self;
    [_mapView addGestureRecognizer:edgePan];
    
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
}

- (void)loadNearbyServers
{
    NSLog(@"获取纬度 -- %f",_userLocation.location.coordinate.latitude);
    NearbyServers *nearbyServers = [[NearbyServers alloc] initWithLng:_userLocation.location.coordinate.longitude andLat:_userLocation.location.coordinate.latitude andRange:8000 andType:@"driver"];
    [nearbyServers startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        if (request) {
                id result = [request responseJSONObject];
                if ([request responseStatusCode] == 200 && [result[@"rst"] floatValue] == 0.f) {
                    [_mapView removeAnnotations:_drivers];
                    NSMutableArray *nearbyDriversArray = result[@"data"];
                    DDLogDebug(@"附近的司机--%@",nearbyDriversArray);
                    NSMutableArray * currDrivers = [NSMutableArray arrayWithCapacity:[nearbyDriversArray count]];
                    for (int i = 0; i < [nearbyDriversArray count]; i ++) {
                        SaintAnnotation *driverAnnotation = [[SaintAnnotation alloc] init];
                        float latitude = [nearbyDriversArray[i][@"lat"] floatValue];
                        float longitude = [nearbyDriversArray[i][@"lng"] floatValue];
                        
                        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
                        driverAnnotation.coordinate = coordinate;
                        [driverAnnotation setTag:nearbyDriversArray[i][@"user"]];
                        driverAnnotation.title = @" ";
                        [currDrivers addObject:driverAnnotation];
                    }
                    [_mapView addAnnotations:currDrivers];
                    _drivers = currDrivers;
                }
            }
    } failure:^(YTKBaseRequest *request) {
        if (request) {
            NSInteger code = [request responseStatusCode];
            if (code == 401) {
                _mapView.showsUserLocation = NO;
                //[self toLogin];
            }
        }
    }];
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
                    
                    //加载用户信息
                    [self loadUserInfo];
                }
            }
        } failure:^(YTKBaseRequest *request) {
            DDLogError(@"登录失败 -- %@",request);
        }];
    }}

-(void)initSearchAPI{
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    
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
            NSString *addr = [NSString stringWithFormat:@"出发地点：%@",[poi name]];
            [_fromBtn setTitle:addr forState:UIControlStateNormal];
        }
        
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
        [userdefault synchronize];
    }
    [userdefault setObject:myName forKey:@"myName"];
    [userdefault synchronize];
    
    [userdefault setObject:mySex forKey:@"mySex"];
    [userdefault synchronize];
    
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
//-(void)toLogin{
//    KIWIAlertView *alertView = [[KIWIAlertView alloc] initWithTitle:@"您还没有登录哦!" icon:nil message:@"登录之后使用更畅快!" delegate:self buttonTitles:@"取消",@"去登录", nil];
//    [alertView setTag:0];
//    [alertView setMessageColor:[UIColor blackColor] fontSize:0];
//    [alertView show];
//}

- (void)alertView:(KIWIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView tag] == 0) {
        if (buttonIndex == 1) {
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            [self.navigationController pushViewController:loginVC animated:YES];
        }
    }
}

#pragma mark - search


-(void)initLocationButton{
    _buttonLocating = [UIButton buttonWithType:UIButtonTypeCustom];
    [_buttonLocating setImage:[UIImage imageNamed:@"定位"] forState:UIControlStateNormal];
    _buttonLocating.backgroundColor = [UIColor whiteColor];
    _buttonLocating.layer.cornerRadius = 6;
    _buttonLocating.layer.shadowColor = [UIColor blackColor].CGColor;
    _buttonLocating.layer.shadowOffset = CGSizeMake(1, 1);
    _buttonLocating.layer.shadowOpacity = 0.5;
    
    [_buttonLocating addTarget:self action:@selector(actionLocating:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_buttonLocating];
}

- (void)actionLocating:(UIButton *)sender
{
    NSLog(@"actionLocating");
    _mapView.centerCoordinate = _userLocation.coordinate;
    _mapView.zoomLevel = 16.1;
    // 使得userLocationView在最前。
    [_mapView selectAnnotation:_mapView.userLocation animated:YES];

}

-(void)initCenterView{
        UIImage *image = [UIImage imageNamed:@"中心"];
        _centerView = [[UIImageView alloc] initWithImage:image];
        
        _centerView.frame = CGRectMake(self.view.bounds.size.width/2-image.size.width/2, _mapView.bounds.size.height/2-image.size.height, image.size.width, image.size.height);
        
        _centerView.center = CGPointMake(CGRectGetWidth(self.view.bounds) / 2, CGRectGetHeight(_mapView.bounds) / 2 - CGRectGetHeight(_centerView.bounds) / 2);
        
        [self.view addSubview:_centerView];
}

-(void)initFromAndToBtn:(DDState) state{
    switch (state) {
        case DDState_Init:
            _fromBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _fromBtn.frame = CGRectMake(10, SCREEN_HEIGHT-130, SCREEN_WIDTH-20, 60);
            [_fromBtn setBackgroundImage:[UIImage imageNamed:@"时间按钮"] forState:UIControlStateNormal];
            [_fromBtn setBackgroundImage:[UIImage imageNamed:@"时间按钮"] forState:UIControlStateHighlighted];
            [_fromBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_fromBtn setTag:0];
            [_fromBtn addTarget:self action:@selector(goSearchPage:) forControlEvents:UIControlEventTouchUpInside];
            _toBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, SCREEN_HEIGHT-70, SCREEN_WIDTH-20, 60)];
            [_toBtn setBackgroundImage:[UIImage imageNamed:@"到达地址框"] forState:UIControlStateNormal];
            [_toBtn setBackgroundImage:[UIImage imageNamed:@"到达地址框"] forState:UIControlStateHighlighted];
            [_toBtn setTag:1];
            [_toBtn addTarget:self action:@selector(goSearchPage:) forControlEvents:UIControlEventTouchUpInside];
            _buttonLocating.frame = CGRectMake(20, SCREEN_HEIGHT-180, 40, 40);
            [self.view addSubview:_fromBtn];
            [self.view addSubview:_toBtn];
            break;
        case DDState_PrePare:
            _callDriver = [[UIButton alloc] initWithFrame:CGRectMake(10, SCREEN_HEIGHT-50, SCREEN_WIDTH-20, 40)];
            [_callDriver setBackgroundImage:[UIImage imageNamed:@"下单按钮"] forState:UIControlStateNormal];
            _callDriver.layer.cornerRadius = _callDriver.frame.size.height/10;
            _callDriver.layer.masksToBounds = YES;
            [_callDriver setTitle:@"一键下单" forState:UIControlStateNormal];
            _callDriver.titleLabel.font = [UIFont fontWithName:@"Arial-Bold" size:24.f];
            _fromBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, SCREEN_HEIGHT-240, SCREEN_WIDTH-20, 60)];
            [_fromBtn setBackgroundImage:[UIImage imageNamed:@"时间按钮"] forState:UIControlStateNormal];
            [_fromBtn setBackgroundImage:[UIImage imageNamed:@"时间按钮"] forState:UIControlStateHighlighted];
            [_fromBtn setTag:0];
            [_fromBtn addTarget:self action:@selector(goSearchPage:) forControlEvents:UIControlEventTouchUpInside];
            _toBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, SCREEN_HEIGHT-180, SCREEN_WIDTH-20, 60)];
            [_toBtn setBackgroundColor:[UIColor whiteColor]];
            [_toBtn setTag:1];
            [_toBtn addTarget:self action:@selector(goSearchPage:) forControlEvents:UIControlEventTouchUpInside];
            _nowPrice = [[UIButton alloc] initWithFrame:CGRectMake(10, SCREEN_HEIGHT-120, SCREEN_WIDTH-20, 60)];
            [_nowPrice setBackgroundImage:[UIImage imageNamed:@"到达地址框"] forState:UIControlStateNormal];
            [_nowPrice setBackgroundImage:[UIImage imageNamed:@"到达地址框"] forState:UIControlStateHighlighted];
            _buttonLocating.frame = CGRectMake(20, SCREEN_HEIGHT-290, 40, 40);
            [self.view addSubview:_fromBtn];
            [self.view addSubview:_toBtn];
            [self.view addSubview:_nowPrice];
            [self.view addSubview:_callDriver];
            break;
        case DDState_OrderIn:
            break;
        case DDState_PreInCar:
            break;
        case DDState_InCar:
            break;
        case DDState_PrePay:
            break;
        case DDState_PrePF:
            break;
        default:
            break;
    }
}

//取地址检索页
-(void)goSearchPage:(UIButton *) button{
    PlaceViewController *vc = [[PlaceViewController alloc] init];
    if ([button tag] == 0) {
        vc.isFrom = YES;
    }else{
        vc.isFrom = NO;
    }
    //vc.mainDelegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)setLocation:(CLLocationCoordinate2D)location isFrom:(BOOL)isFrom{
    _isSetFrom = isFrom;
    
}


-(instancetype)init{
    self = [super init];
    if (self) {
        [self.view setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMAMap];
    [self initCenterView];
    [self initSearchAPI];
    [self initLocationButton];
    [self initFromAndToBtn:DDState_Init];
    //添加监听登陆成功的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginSuccess) name:@"loginSuccess" object:nil];
    //添加退出登陆的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(exitLogin) name:@"exitLogin" object:nil];
    //重新加载用户信息的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadUserInfo) name:@"reloadUserInfo" object:nil];
    

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
-(void)viewWillAppear:(BOOL)animated{
    [self initUserLoginInformation];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    if (!self.leftView) {
        self.leftView =[MainLeftView shareInstance];
        self.cover=[Cover creatHideCover];
        self.leftView.leftViewDelegate=self;
        [self.leftView showInSide];
    }
    //可以在这里发送请求更改用户的余额
    
}

-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        //取出当前位置的坐标
        DDLogDebug(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        _userLocation = userLocation;
        [LocationCommon upLoadUserLocation:userLocation];
        [self loadNearbyServers];
        
    }else{
        //方向信息更新
    }
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[SaintAnnotation class]]) {
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

- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    MAAnnotationView *view = views[0];
    
    // 放到该方法中用以保证userlocation的annotationView已经添加到地图上了。
    if ([view.annotation isKindOfClass:[MAUserLocation class]])
    {
        MAUserLocationRepresentation *pre = nil;
        [_mapView updateUserLocationRepresentation:pre];
        
        view.calloutOffset = CGPointMake(0, 0);
    }
}

//点击司机气泡
- (void)tapPaoPao:(UIGestureRecognizer *)gesture{
    DDLogError(@"点击了");
}

#pragma mark - MapViewDelegate

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

- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    [self searchAddress:mapView.centerCoordinate];
    [self myPointAnimimate];
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
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
