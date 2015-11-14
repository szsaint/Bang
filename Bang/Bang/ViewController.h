//
//  ViewController.h
//  Bang
//
//  Created by yyx on 15/11/11.
//  Copyright © 2015年 saint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>

@protocol MainViewControllerDelegate <NSObject>

@optional

-(void) setLocation:(CLLocationCoordinate2D)location isFrom:(BOOL) isFrom;

@end

@interface ViewController : UIViewController

@property (nonatomic,assign) id<MainViewControllerDelegate> mianDelegate;

@end

