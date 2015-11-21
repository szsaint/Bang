//
//  RouteCell.h
//  iBang
//
//  Created by yyx on 15/11/7.
//  Copyright © 2015年 kiwi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RouteCell : UITableViewCell

@property (nonatomic,strong) UIImageView *from;
@property (nonatomic,strong) UIImageView *to;
@property (nonatomic,strong) UILabel *fromTxt;
@property (nonatomic,strong) UILabel *toTxt;
//@property (nonatomic,strong) UIImageView *go;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@end
