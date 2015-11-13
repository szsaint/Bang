//
//  BangActionSheet.m
//  Bang
//
//  Created by wl on 15/11/14.
//  Copyright © 2015年 saint. All rights reserved.
//

#import "BangActionSheet.h"

@implementation BangActionSheet

-(void)layoutSubviews{
    [super layoutSubviews];
    for (UIView *subViwe in self.subviews) {
        if ([subViwe isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton*)subViwe;
            [button setTitleColor:CONTENT_COLOR forState:UIControlStateNormal];
            
        }
    }
    
}

@end
