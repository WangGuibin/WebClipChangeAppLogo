//
//  UIButton+WGBExtension.h
//  WGBCocoaKit
//
//  Created by CoderWGB on 2018/8/10.
//  Copyright © 2018年 CoderWGB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (WGBExtension)
//上下居中，图片在上，文字在下
- (void)wgb_verticalCenterImageAndTitle:(CGFloat)spacing;
- (void)wgb_verticalCenterImageAndTitle; //默认6.0

//左右居中，文字在左，图片在右
- (void)wgb_horizontalCenterTitleAndImage:(CGFloat)spacing;
- (void)wgb_horizontalCenterTitleAndImage; //默认6.0

//左右居中，图片在左，文字在右
- (void)wgb_horizontalCenterImageAndTitle:(CGFloat)spacing;
- (void)wgb_horizontalCenterImageAndTitle; //默认6.0

//文字居中，图片在左边
- (void)wgb_horizontalCenterTitleAndImageLeft:(CGFloat)spacing;
- (void)wgb_horizontalCenterTitleAndImageLeft; //默认6.0

//文字居中，图片在右边
- (void)wgb_horizontalCenterTitleAndImageRight:(CGFloat)spacing;
- (void)wgb_horizontalCenterTitleAndImageRight; //默认6.0


///额外点击区域
@property (nonatomic,assign) UIEdgeInsets wgb_touchAreaInsets;


@end
