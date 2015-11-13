//
//  MainLeftView.h
//  BangDriver
//
//  Created by wl on 15/11/12.
//  Copyright © 2015年 saint. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MainLeftView;
@class LeftHeaderView;
@protocol MainLeftViewDelegate <NSObject>

-(void)leftView:(MainLeftView *)lefteView didSelectedHeader:(LeftHeaderView *)header;

-(void)leftView:(MainLeftView *)leftView didSelectedItemAtIndex:(NSInteger)index;


@end
@interface MainLeftView : UITableView


@property (nonatomic,weak)id<MainLeftViewDelegate>leftViewDelegate;


+(MainLeftView *)shareInstance;
-(void)showInSide;//隐藏在边部

-(void)showInVisble;//可见状态

@end


#pragma mark tableViewCell

@interface leftViewCell : UITableViewCell
@property (nonatomic,strong)UIImageView *imageV;//标题图
@property (nonatomic,strong)UILabel *titleLabel;//标题

+(instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier;
@end


#pragma mark  leftViewHeader
@interface LeftHeaderView : UIView
@property (nonatomic,strong)UIImageView *userIcon;//用户头像
@property (nonatomic,strong)UILabel *userPhoneNumber;//用户手机号

@property (nonatomic,strong)UILabel *userBanlance;//用户余额

@end

#pragma mark  cover
@class Cover;
@protocol CoverDelegate <NSObject>

-(void)coverOnClick:(UIView *)cover;

@end
@interface Cover : UIView
@property (nonatomic,weak)id<CoverDelegate>delegate;
+(instancetype)creatHideCover;//创建方法

+(Cover *)shareInstance;//拿到它
-(void) showInSide;

-(void)coverShowAnimated;
-(void)coverHideAnimated;
@end