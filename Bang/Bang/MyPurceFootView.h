//
//  MyPurceFootView.h
//  BangDriver
//
//  Created by wl on 15/11/12.
//  Copyright © 2015年 saint. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyPurceFootView;
@protocol MyPurceFootViewDelegate <NSObject>

-(void)MyPurceFootView:(MyPurceFootView *)footerView didSelectedRichCashBtn:(UIButton *)richCash;

-(void)MyPurceFootView:(MyPurceFootView *)footerView didSelectedTopUp:(UIButton *)topUp;


@end

@interface MyPurceFootView : UIView
@property (nonatomic,weak)id<MyPurceFootViewDelegate>delegate;

@end
