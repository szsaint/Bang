//
//  DDDriverManager.m
//  TripDemo
//
//  Created by yi chen on 4/3/15.
//  Copyright (c) 2015 AutoNavi. All rights reserved.
//

#import "DDDriverManager.h"
#import <AMapSearchKit/AMapSearchAPI.h>
#import "MANaviRoute.h"
#import "DDSearchManager.h"
#import "NearbyServers.h"

@interface DDDriverManager() <AMapSearchDelegate>

@property(nonatomic, strong) DDTaxiCallRequest * currentRequest;
@property(nonatomic, strong) DDDriver * selectDriver;

@property(nonatomic, strong) NSArray * driverPath;
@property(nonatomic, assign) NSUInteger subpathIdx;

@end

@implementation DDDriverManager
{
    
}

//根据mapRect取司机数据
- (void)searchDriversWithinMapRect:(CLLocationCoordinate2D)coore
{
    #define latitudinalRangeMeters 1000.0
    #define longitudinalRangeMeters 1000.0
    
    MAMapRect rect = MAMapRectForCoordinateRegion(MACoordinateRegionMakeWithDistance(coore, latitudinalRangeMeters, longitudinalRangeMeters));
    //NSLog(@"获取纬度 -- %f",_userLocation.location.coordinate.latitude);
    NearbyServers *nearbyServers = [[NearbyServers alloc] initWithLng:coore.longitude andLat:coore.latitude andRange:8000 andType:@"driver"];
    [nearbyServers startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        if (request) {
            id result = [request responseJSONObject];
            if ([request responseStatusCode] == 200 && [result[@"rst"] floatValue] == 0.f) {
                NSMutableArray *nearbyDriversArray = result[@"data"];
                DDLogDebug(@"附近的司机--%@",nearbyDriversArray);
                NSMutableArray * currDrivers = [NSMutableArray arrayWithCapacity:[nearbyDriversArray count]];
                for (int i = 0; i < [nearbyDriversArray count]; i ++) {
                    float latitude = [nearbyDriversArray[i][@"lat"] floatValue];
                    float longitude = [nearbyDriversArray[i][@"lng"] floatValue];
                    
                    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
                    DDDriver * driver = [DDDriver driverWithID:nearbyDriversArray[i][@"user"][@"id"] coordinate:coordinate tag:nearbyDriversArray[i][@"user"]];
                    [currDrivers addObject:driver];
                }
                //回调返回司机数据
                if (self.delegate && [self.delegate respondsToSelector:@selector(searchDoneInMapRect:withDriversResult:timestamp:)])
                {
                    [self.delegate searchDoneInMapRect:rect withDriversResult:currDrivers timestamp:[NSDate date].timeIntervalSinceReferenceDate];
                }

            }
        }
    } failure:^(YTKBaseRequest *request) {
        if (request) {
            NSInteger code = [request responseStatusCode];
            DDLogDebug(@"加载司机出错，代码%li",code);
        }
    }];
}

//发送用车请求：起点终点
- (BOOL)callTaxiWithRequest:(DDTaxiCallRequest *)request
{
    if (request.start == nil || request.end == nil)
    {
        return NO;
    }
    
    _currentRequest = request;

    //在起点附近随机生成司机位置
#define startAroundRangeMeters 500.0
    
    MAMapRect startAround = MAMapRectForCoordinateRegion(MACoordinateRegionMakeWithDistance(_currentRequest.start.coordinate, startAroundRangeMeters, startAroundRangeMeters));

    CLLocationCoordinate2D driverLocation = [self randomPointInMapRect:startAround];
    NSLog(@"driverLocation : %f %f", driverLocation.latitude, driverLocation.longitude);
    _selectDriver = [DDDriver driverWithID:@"京B****" coordinate:driverLocation];
    
    //延迟返回司机选择结果
    __weak __typeof(&*self) weakSelf = self;
    int64_t delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(callTaxiDoneWithRequest:Taxi:)])
        {
            [weakSelf.delegate callTaxiDoneWithRequest:_currentRequest Taxi:_selectDriver];
        }
        
        //司机位置更新
        [weakSelf startUpdateLocationForDriver:_selectDriver];

    });
    
    return YES;
}

- (void)startUpdateLocationForDriver:(DDDriver *)driver
{
    [self searchPathFrom:driver.coordinate to:_currentRequest.start.coordinate];
    
}

//找驾车到达乘客位置的路径
- (void)searchPathFrom:(CLLocationCoordinate2D)from to:(CLLocationCoordinate2D)to
{
    AMapDrivingRouteSearchRequest *navi = [[AMapDrivingRouteSearchRequest alloc] init];
    //navi.searchType       = AMapSearchType_NaviDrive;
    navi.requireExtension = YES;
    
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:from.latitude
                                           longitude:from.longitude];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:to.latitude
                                                longitude:to.longitude];

    __weak __typeof(&*self) weakSelf = self;
    [[DDSearchManager sharedInstance] searchForRequest:navi completionBlock:^(id request, id response, NSError *error) {
        
        AMapRouteSearchResponse * naviResponse = response;

        NSLog(@"%@", naviResponse);
        if (naviResponse.route == nil)
        {
            return;
        }
        
        //路径解析
        MANaviRoute * naviRoute = [MANaviRoute naviRouteForPath:naviResponse.route.paths[0]];
        
        //保存路径串
        weakSelf.driverPath = naviRoute.path;
        weakSelf.subpathIdx = 0;
        
        //开始push给乘客端
        NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:weakSelf selector:@selector(onUpdatingLocation) userInfo:nil repeats:YES];
        [timer fire];

    }];

}

- (void)onUpdatingLocation
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onUpdatingLocations:forDriver:)] && _subpathIdx < self.driverPath.count)
    {
        [self.delegate onUpdatingLocations:self.driverPath[_subpathIdx++] forDriver:self.selectDriver];
    }
}

#pragma mark - Utility
- (CLLocationCoordinate2D)randomPointInMapRect:(MAMapRect)mapRect
{
    MAMapPoint result;
    result.x = mapRect.origin.x + arc4random() % (int)(mapRect.size.width);
    result.y = mapRect.origin.y + arc4random() % (int)(mapRect.size.height);
    
    return MACoordinateForMapPoint(result);

}

@end
