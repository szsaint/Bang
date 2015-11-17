//
//  MoneyCell.h
//  iBang
//
//  Created by yyx on 15/11/9.
//  Copyright © 2015年 kiwi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoneyCell : UITableViewCell

@property (nonatomic,strong) UILabel *jine;
@property (nonatomic,strong) UILabel *distance;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
