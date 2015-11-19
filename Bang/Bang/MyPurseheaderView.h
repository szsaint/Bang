//
//  MyPurseheaderView.h
//  BangDriver
//
//  Created by wl on 15/11/11.
//  Copyright © 2015年 saint. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyPurseheaderView : UIView
@property (nonatomic,strong)UILabel *totalMoney;//总金额
//@property (nonatomic,strong)UILabel *cashMoney;//可提现金额
+(instancetype)purseHeaderWithTotalMoney:(NSString *)tottalMoney cashMoney:(NSString *)cashMoney;
@end
