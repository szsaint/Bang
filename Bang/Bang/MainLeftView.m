//
//  MainLeftView.m
//  BangDriver
//
//  Created by wl on 15/11/12.
//  Copyright © 2015年 saint. All rights reserved.
//

#import "MainLeftView.h"
@interface MainLeftView ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>


@end

@implementation MainLeftView{
    NSArray *_imageArray;
    NSArray *_titleArray;
    BOOL _defaultStatuSbar;//记录默认状态栏
}
-(LeftHeaderView *)headerView{
    if (!_headerView) {
        _headerView =[[LeftHeaderView alloc]initWithFrame:CGRectMake(0, 0, 0.8*SCREEN_WIDTH, 200)];
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnHeader:)];
        [_headerView addGestureRecognizer:tap];
    }
    return _headerView;
}

-(void)tapOnHeader:(UITapGestureRecognizer *)sender{
    if ([self.leftViewDelegate respondsToSelector:@selector(leftView:didSelectedHeader:)]) {
        [self.leftViewDelegate leftView:self didSelectedHeader:self.headerView];
    }
}


-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.delegate=self;
        self.dataSource=self;
        self.separatorStyle=UITableViewCellSelectionStyleNone;
        self.showsVerticalScrollIndicator=NO;
        self.showsHorizontalScrollIndicator=NO;
        self.tableHeaderView =self.headerView;
        self.backgroundColor =[UIColor colorWithRed:19/255.0f green:20/255.0f blue:38/255.0f alpha:1];
        _defaultStatuSbar =YES;
        _imageArray =@[@"我的订单",@"优惠代驾",@"服务价格",@"分享",@"关于"];
        _titleArray=@[@"我的订单",@"优惠代驾体验",@"服务价格",@"分享",@"关于"];
        [self addObserver:self forKeyPath:@"transform" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    CGAffineTransform transform =[[change valueForKey:@"new"] CGAffineTransformValue];
    if (transform.tx>5&&_defaultStatuSbar) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        _defaultStatuSbar =NO;
    }else if (transform.tx<5&&!_defaultStatuSbar){
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        _defaultStatuSbar=YES;

    }
    
    //DDLogDebug(@"%f",transform.tx);
}
+(MainLeftView *)shareInstance{
    static MainLeftView *shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] initWithFrame:CGRectMake(-0.8*SCREEN_WIDTH, 0, 0.8*SCREEN_WIDTH, SCREEN_HEIGHT)];
    });
    
    return shared;

}
-(void)showInSide{
//    DDLogDebug(@"wwwwww%@",[[[UIApplication sharedApplication] delegate] window]);
    MainLeftView *leftView = [MainLeftView shareInstance];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:leftView];
    
}

-(void)showInVisble{
    [UIView animateWithDuration:0.5 animations:^{
        self.transform=CGAffineTransformMakeTranslation(0.8*SCREEN_WIDTH, 0);
    }];
}
//触发优先级
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    BOOL result = NO;
    
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        result = YES;
    }
    
    return result;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID =@"cell";
    leftViewCell *cell =[leftViewCell cellWithTableView:tableView identifier:ID];
    cell.imageV.image =[UIImage imageNamed:_imageArray[indexPath.row]];
    cell.titleLabel.text=_titleArray[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.leftViewDelegate respondsToSelector:@selector(leftView:didSelectedItemAtIndex:)]) {
        [self.leftViewDelegate leftView:self didSelectedItemAtIndex:indexPath.row];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(void)dealloc{
    [self removeObserver:self forKeyPath:@"transform"];
}
@end



@interface leftViewCell ()
@property (nonatomic,strong)UIView *line;

@end

@implementation leftViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier{
    leftViewCell *cell =[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell =[[leftViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor=[UIColor clearColor];
        cell.contentView.backgroundColor=[UIColor clearColor];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.imageV];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.line];
        self.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return  self;
}
-(UIImageView *)imageV{
    if (!_imageV) {
        _imageV =[[UIImageView alloc]initWithFrame:CGRectMake(35, 22, 16, 16)];
    }
    return _imageV;
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel =[[UILabel alloc]initWithFrame:CGRectMake(35+16+10, 0, 0.8*SCREEN_WIDTH-65-35, 60)];
        _titleLabel.font =[UIFont systemFontOfSize:17];
        _titleLabel.textColor =[UIColor whiteColor];
    }
    return _titleLabel;
}
-(UIView *)line{
    if (!_line) {
        _line =[[UIView alloc]initWithFrame:CGRectMake(15, 0, 0.8*SCREEN_WIDTH-15, 0.5)];
        _line.backgroundColor =[UIColor grayColor];
    }
    return _line;
}
@end





@interface LeftHeaderView ()


@end

@implementation LeftHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor=[UIColor colorWithRed:19/255.0f green:20/255.0f blue:38/255.0f alpha:1];
        [self setUpSubViews];
    }
    return self;
}
-(void)setUpSubViews{
    UIImageView *imageV =[[UIImageView alloc]init];
    imageV.backgroundColor=[UIColor clearColor];
    [self addSubview:imageV];
    self.userIcon=imageV;
    
    UILabel *userPhoneNumber =[[UILabel alloc]init];
    userPhoneNumber.font=[UIFont systemFontOfSize:14];
    userPhoneNumber.textAlignment=NSTextAlignmentCenter;
    userPhoneNumber.textColor=[UIColor whiteColor];
    [self addSubview:userPhoneNumber];
    self.userPhoneNumber =userPhoneNumber;
    
    UILabel *userBanlance =[[UILabel alloc]init];
    userBanlance.font =[UIFont systemFontOfSize:13];
    userBanlance.textAlignment=NSTextAlignmentCenter;
    userBanlance.textColor=[UIColor whiteColor];
    self.userBanlance =userBanlance;
    [self addSubview:userBanlance];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGPoint center =self.center;
    self.userIcon.frame=CGRectMake(center.x-35, 50, 80, 80);
    self.userIcon.layer.cornerRadius=self.userIcon.frame.size.width/2;
    self.userIcon.layer.masksToBounds=YES;
    [self.userIcon.layer setBorderWidth:1];
    [self.userIcon.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    
    self.userPhoneNumber.frame =CGRectMake(30, 50+80+5, 0.8*SCREEN_WIDTH-60, 30);
    
    self.userBanlance.frame=CGRectMake(30, 50+80+5+30+5, 0.8*SCREEN_WIDTH-60, 20);
    [self reloadIcon];
    NSString *userName =[[NSUserDefaults standardUserDefaults]objectForKey:kUserName];
    if (userName) {
        self.userPhoneNumber.text=userName;
    }else{
        self.userPhoneNumber.text=@"未登录";
    }
    NSString *banlance =[[NSUserDefaults standardUserDefaults]objectForKey:@"myBalance"];
    if (banlance) {
        self.userBanlance.text=[NSString stringWithFormat:@"余额:%@",banlance];
    }else{
        self.userBanlance.text=[NSString stringWithFormat:@"余额:0.00"];

    }

}
-(void)reloadIcon{
    //获取图片
    //拿到图片
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths lastObject];
    //设置一个图片的存储路径
    NSString *imagePath = [path stringByAppendingPathComponent:@"icon.png"];
    
    UIImage *img = [UIImage imageWithContentsOfFile:imagePath];
    if (img) {
        self.userIcon.image=img;
    }
}
-(void)setPhoneNumber:(NSString *)phoneNumber{
    _phoneNumber=phoneNumber;
    self.userPhoneNumber.text=phoneNumber;
}
-(void)setBanlance:(NSString *)banlance{
    _banlance =banlance;
    self.userBanlance.text=[NSString stringWithFormat:@"余额:%@",banlance];
}
-(void)deleteDate{
    self.userPhoneNumber.text=@"未登录";
    self.userBanlance.text=@"余额:0.00";
    self.userIcon.image=nil;
}
@end







#pragma mark  Cover

@interface Cover ()
@property (nonatomic,strong)MainLeftView *leftView;

@end

@implementation Cover
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor=[UIColor blackColor];
        self.alpha=0.0;
        
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tap];
        
        UIPanGestureRecognizer *pan =[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
        [self addGestureRecognizer:pan];
        self.leftView =[MainLeftView shareInstance];
    }
    return self;
}
-(void)tap:(UITapGestureRecognizer *)sender{
    if ([self.delegate respondsToSelector:@selector(coverOnClick:)]) {
        [self.delegate coverOnClick:self];
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.leftView.transform =CGAffineTransformIdentity;
    }];
    [self coverHideAnimated];
}
+(instancetype)creatHideCover{
    Cover *cover =[self shareInstance];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:cover];
    cover.hidden=YES;
    return cover;
}
+(Cover *)shareInstance{
        static Cover *shared;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            shared = [[self alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        });
        
        return shared;
    
}

-(void)showInSide{
    
}
-(void)pan:(UIPanGestureRecognizer *)sender{
    //if(self.hidden)return;
     CGPoint translation = [sender translationInView:self];//移动距离
    if (translation.x>0)return;
    if (translation.x<-0.8*SCREEN_WIDTH) {
//        if (self.hidden==YES) {
//            return;
//        }else{
//        self.leftView.transform=CGAffineTransformIdentity;
//            [self coverHideAnimated];
//        }
        translation.x=-0.8*SCREEN_WIDTH;
    }
    self.leftView.transform=CGAffineTransformMakeTranslation(0.8*SCREEN_WIDTH+translation.x, 0);
        if (sender.state==UIGestureRecognizerStateCancelled||sender.state==UIGestureRecognizerStateEnded||sender.state==UIGestureRecognizerStateFailed) {
            //0.2 会感觉有清扫效果
            if (-translation.x<0.2*SCREEN_WIDTH) {
                CGFloat duration =0.25;//1/(0.8*SCREEN_WIDTH/-translation.x)*0.35;
                [UIView animateWithDuration:duration animations:^{
                    self.leftView.transform=CGAffineTransformMakeTranslation(0.8*SCREEN_WIDTH, 0);
                }];
            }else{
                CGFloat duration =1/(0.8*SCREEN_WIDTH/-translation.x)*0.5;
                [UIView animateWithDuration:duration animations:^{
                    self.leftView.transform=CGAffineTransformIdentity;
                }];
                [self coverHideAnimated];
            }
        }
    
}

-(void)coverHideAnimated{
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha=0.0;
    } completion:^(BOOL finished) {
        self.hidden=YES;
    }];
}

-(void)coverShowAnimated{
    self.hidden=NO;
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha=0.3;
    } completion:^(BOOL finished) {
    }];
}
-(void)hideWhenPush{
    [UIView animateWithDuration:0.4 animations:^{
        self.leftView.transform =CGAffineTransformIdentity;
    }];
    [self coverHideAnimated];
}
@end
