//
//  SaintAnnotationView.m
//  Bang
//
//  Created by yyx on 15/11/12.
//  Copyright © 2015年 saint. All rights reserved.
//

#import "SaintAnnotationView.h"
#import "SaintAnnotation.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation SaintAnnotationView
{
    UIImageView *_headerImageView;
    UILabel *_nameLabel;
    UIImageView *_pfImageView;
}

@synthesize driverId = _driverId;
@synthesize type = _type;

- (id) initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        SaintAnnotation *customPoint = (SaintAnnotation *)annotation;
        NSDictionary *info = (NSDictionary *)customPoint.tag;
        [self setBounds:CGRectMake(0, 0, 120, 52)];
        UIImageView *backview = [[UIImageView alloc] initWithFrame:self.bounds];
        [backview setImage:[UIImage imageNamed:@"泡泡"]];
        [self addSubview:backview];
        _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8,5 , 30,30 )];
        
        if (info != nil && info[@"avatar"] != [NSNull null]) {
            NSString *url = [kServiceUrl stringByAppendingString:info[@"avatar"]];
            [_headerImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"用户"]];
        }else{
            [_headerImageView setImage:[UIImage imageNamed:@"用户"]];
        }
        _headerImageView.frame = CGRectMake(8, 5, 30, 30);
        _headerImageView.layer.masksToBounds = YES;
        _headerImageView.layer.cornerRadius = 15;
        
        [self addSubview:_headerImageView];
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, 68, 15)];
        [_nameLabel setText:info[@"name"]];
        [self addSubview:_nameLabel];
        _pfImageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 20, 68, 15)];
        //        [_pfImageView setImage:[UIImage imageNamed:@"5"]];
        float score = [info[@"score"] floatValue];
        if (score == 1) {
            [_pfImageView setImage:[UIImage imageNamed:@"1"]];
        }else if (score >1 && score<1.5){
            [_pfImageView setImage:[UIImage imageNamed:@"1-1.5"]];
        }else if (score == 1.5){
            [_pfImageView setImage:[UIImage imageNamed:@"1.5"]];
        }else if (score >1.5 && score <2){
            [_pfImageView setImage:[UIImage imageNamed:@"1.5-2"]];
        }else if (score == 2){
            [_pfImageView setImage:[UIImage imageNamed:@"2"]];
        }else if (score>2 && score<2.5){
            [_pfImageView setImage:[UIImage imageNamed:@"2-2.5"]];
        }else if (score == 2.5){
            [_pfImageView setImage:[UIImage imageNamed:@"2.5"]];
        }else if (score >2.5 && score <3){
            [_pfImageView setImage:[UIImage imageNamed:@"2.5-3"]];
        }else if (score == 3){
            [_pfImageView setImage:[UIImage imageNamed:@"3"]];
        }else if (score >3 && score <3.5){
            [_pfImageView setImage:[UIImage imageNamed:@"3-3.5"]];
        }else if (score == 3.5){
            [_pfImageView setImage:[UIImage imageNamed:@"3.5"]];
        }else if (score >3.5 && score <4){
            [_pfImageView setImage:[UIImage imageNamed:@"3.5-4"]];
        }else if (score == 4){
            [_pfImageView setImage:[UIImage imageNamed:@"4"]];
        }else if (score >4 && score <4.5){
            [_pfImageView setImage:[UIImage imageNamed:@"4-4.5"]];
        }else if (score == 4.5){
            [_pfImageView setImage:[UIImage imageNamed:@"4.5"]];
        }else if (score == 5){
            [_pfImageView setImage:[UIImage imageNamed:@"5"]];
        }
        
        [self addSubview:_pfImageView];
        _driverId = info[@"id"];
        _type = 1;
    }
    return self;
}

@end