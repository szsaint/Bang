//
//  ChoseImageController.h
//  Bang
//
//  Created by wl on 15/11/14.
//  Copyright © 2015年 saint. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChoseImageController;
@protocol ChoseImageControllerDelgate <NSObject>

- (void)imageCropper:(ChoseImageController *) cropperViewController didFinished:(UIImage *)editedImage;
- (void)imageCropperDidCancel:(ChoseImageController *)cropperViewControlelr;


@end

@interface ChoseImageController : UIViewController

@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) id<ChoseImageControllerDelgate> delegate;
@property (nonatomic, assign) CGRect cropFrame;

@property (nonatomic,strong)UIImage *icon;

- (id)initWithImage:(UIImage *)originalImage cropFrame:(CGRect)cropFrame limitScaleRatio:(NSInteger)limitRatio;


@end

