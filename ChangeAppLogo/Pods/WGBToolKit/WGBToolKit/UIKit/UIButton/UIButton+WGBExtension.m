//
//  UIButton+WGBExtension.m
//  WGBCocoaKit
//
//  Created by CoderWGB on 2018/8/10.
//  Copyright © 2018年 CoderWGB. All rights reserved.
//

#import "UIButton+WGBExtension.h"
#import <objc/runtime.h>

@implementation UIButton (WGBExtension)
- (void)wgb_verticalCenterImageAndTitle:(CGFloat)spacing
{
    // get the size of the elements here for readability
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    
    // lower the text and push it left to center it
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (imageSize.height + spacing/2), 0.0);
    
    // the text width might have changed (in case it was shortened before due to
    // lack of space and isn't anymore now), so we get the frame size again
    titleSize = self.titleLabel.frame.size;
    
    // raise the image and push it right to center it
    self.imageEdgeInsets = UIEdgeInsetsMake(- (titleSize.height + spacing/2), 0.0, 0.0, - titleSize.width);
}

- (void)wgb_verticalCenterImageAndTitle
{
    const int DEFAULT_SPACING = 6.0f;
    [self wgb_verticalCenterImageAndTitle:DEFAULT_SPACING];
}


- (void)wgb_horizontalCenterTitleAndImage:(CGFloat)spacing
{
    // get the size of the elements here for readability
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    
    // lower the text and push it left to center it
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, 0.0, imageSize.width + spacing/2);
    
    // the text width might have changed (in case it was shortened before due to
    // lack of space and isn't anymore now), so we get the frame size again
    titleSize = self.titleLabel.frame.size;
    
    // raise the image and push it right to center it
    self.imageEdgeInsets = UIEdgeInsetsMake(0.0, titleSize.width + spacing/2, 0.0, - titleSize.width);
}

- (void)wgb_horizontalCenterTitleAndImage
{
    const int DEFAULT_SPACING = 6.0f;
    [self wgb_horizontalCenterTitleAndImage:DEFAULT_SPACING];
}


- (void)wgb_horizontalCenterImageAndTitle:(CGFloat)spacing;
{
    // get the size of the elements here for readability
    //    CGSize imageSize = self.imageView.frame.size;
    //    CGSize titleSize = self.titleLabel.frame.size;
    
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0,  0.0, 0.0,  - spacing/2);
    self.imageEdgeInsets = UIEdgeInsetsMake(0.0, - spacing/2, 0.0, 0.0);
}

- (void)wgb_horizontalCenterImageAndTitle;
{
    const int DEFAULT_SPACING = 6.0f;
    [self wgb_horizontalCenterImageAndTitle:DEFAULT_SPACING];
}


- (void)wgb_horizontalCenterTitleAndImageLeft:(CGFloat)spacing
{
    // get the size of the elements here for readability
    //    CGSize imageSize = self.imageView.frame.size;
    //    CGSize titleSize = self.titleLabel.frame.size;
    
    self.imageEdgeInsets = UIEdgeInsetsMake(0.0, - spacing, 0.0, 0.0);
}

- (void)wgb_horizontalCenterTitleAndImageLeft
{
    const int DEFAULT_SPACING = 6.0f;
    [self wgb_horizontalCenterTitleAndImageLeft:DEFAULT_SPACING];
}


- (void)wgb_horizontalCenterTitleAndImageRight:(CGFloat)spacing
{
    // get the size of the elements here for readability
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    
    // lower the text and push it left to center it
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, 0.0, 0.0);
    
    // the text width might have changed (in case it was shortened before due to
    // lack of space and isn't anymore now), so we get the frame size again
    titleSize = self.titleLabel.frame.size;
    
    // raise the image and push it right to center it
    self.imageEdgeInsets = UIEdgeInsetsMake(0.0, titleSize.width + imageSize.width + spacing, 0.0, - titleSize.width);
}

- (void)wgb_horizontalCenterTitleAndImageRight
{
    const int DEFAULT_SPACING = 6.0f;
    [self wgb_horizontalCenterTitleAndImageRight:DEFAULT_SPACING];
}


#pragma mark- 设置按钮额外点击区域
/**
 *  @brief  设置按钮额外点击区域
 */
- (UIEdgeInsets)wgb_touchAreaInsets
{
    return [objc_getAssociatedObject(self, @selector(wgb_touchAreaInsets)) UIEdgeInsetsValue];
}

- (void)setWgb_touchAreaInsets:(UIEdgeInsets)wgb_touchAreaInsets{
    NSValue *value = [NSValue valueWithUIEdgeInsets:wgb_touchAreaInsets];
    objc_setAssociatedObject(self, @selector(wgb_touchAreaInsets), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    UIEdgeInsets touchAreaInsets = self.wgb_touchAreaInsets;
    CGRect bounds = self.bounds;
    bounds = CGRectMake(bounds.origin.x - touchAreaInsets.left,
                        bounds.origin.y - touchAreaInsets.top,
                        bounds.size.width + touchAreaInsets.left + touchAreaInsets.right,
                        bounds.size.height + touchAreaInsets.top + touchAreaInsets.bottom);
    return CGRectContainsPoint(bounds, point);
}

- (UIView*) hitTest:(CGPoint) point withEvent:(UIEvent*) event
{
    UIEdgeInsets touchAreaInsets = self.wgb_touchAreaInsets;
    CGRect bounds = self.bounds;
    bounds = CGRectMake(bounds.origin.x - touchAreaInsets.left,
                        bounds.origin.y - touchAreaInsets.top,
                        bounds.size.width + touchAreaInsets.left + touchAreaInsets.right,
                        bounds.size.height + touchAreaInsets.top + touchAreaInsets.bottom);
    CGRect rect = bounds;
    if (CGRectEqualToRect(rect, self.bounds))
    {
        return [super hitTest:point withEvent:event];
    }
    return CGRectContainsPoint(rect, point) ? self : nil;
}



@end
