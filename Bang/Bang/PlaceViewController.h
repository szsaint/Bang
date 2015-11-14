//
//  ViewController.h
//  AMapPlaceChooseDemo
//
//  Created by PC on 15/9/28.
//  Copyright © 2015年 FENGSHENG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@class DDLocation;
@class PlaceViewController;

@protocol PlaceViewControllerDelegate <NSObject>
@optional

- (void)searchViewController:(PlaceViewController *)searchViewController didSelectLocation:(DDLocation *)location;

@end

@interface PlaceViewController : UIViewController<MainViewControllerDelegate>

@property(nonatomic,assign)id<PlaceViewControllerDelegate> searchDelegate;

@property (nonatomic,assign) BOOL isFrom;

@end

