//
//  JHSoundWaveView.h
//  JHKit
//
//  Created by HaoCold on 2018/11/20.
//  Copyright © 2018 HaoCold. All rights reserved.
//
//  MIT License
//
//  Copyright (c) 2018 xjh093
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#import <UIKit/UIKit.h>

// 类似网抑云的那个音浪效果 类似高低不平的台阶上上下下那种动效

NS_ASSUME_NONNULL_BEGIN

@interface JHSoundWaveConfig : NSObject
/// 个数,默认3
@property (nonatomic,  assign) NSUInteger  count;
/// 宽度,默认2
@property (nonatomic,  assign) CGFloat  width;
/// 颜色,whiteColor
@property (nonatomic,  strong) UIColor *color;
/// 左边距,默认0
@property (nonatomic,  assign) CGFloat  leftMargin;
/// 间距,默认2
@property (nonatomic,  assign) CGFloat  space;
/// 圆角
@property (nonatomic,  assign) CGFloat radius;
@end

@interface JHSoundWaveView : UIView

- (instancetype)initWithFrame:(CGRect)frame config:(JHSoundWaveConfig *)config;

- (void)startAnimation;
- (void)stopAnimation;

@end

NS_ASSUME_NONNULL_END
