//
//  JHSoundWaveView.m
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

#import "JHSoundWaveView.h"

@implementation JHSoundWaveConfig

- (instancetype)init{
    if ([super init]) {
        _count = 3;
        _width = 2;
        _color = [UIColor whiteColor];
        _leftMargin = 0;
        _space = 2;
    }
    return self;
}

@end

@interface JHSoundWaveBar : UIView
@property (nonatomic,  assign) CGFloat  duration;

@property (nonatomic,  strong) UIView *bar;
@property (nonatomic,  strong) UIColor *color;
@property (nonatomic,  strong) NSTimer *timer;
@property (nonatomic,  assign) CGFloat radius;

- (void)shouldStartAnimation:(BOOL)flag;

@end

@implementation JHSoundWaveBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    if (!newSuperview) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)setupViews
{
    UIView *view = [[UIView alloc] init];
    view.frame = self.bounds;
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
    _bar = view;
    
    self.transform = CGAffineTransformMakeRotation(M_PI);
}

- (void)animation
{
    [UIView animateWithDuration:_duration*0.5 animations:^{
        CGRect frame = self->_bar.frame;
        frame.size.height *= (0.1*(arc4random()%4+1));
        self->_bar.frame = frame;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:self->_duration*0.5 animations:^{
            CGRect frame = self->_bar.frame;
            frame.size.height = CGRectGetHeight(self.bounds)*(0.1*(arc4random()%5+6));
            self->_bar.frame = frame;
        }];
    }];
}

- (void)shouldStartAnimation:(BOOL)flag
{
    if (flag) {
        [self.timer fire];
    }else{
        [self.timer invalidate];
        _timer = nil;
    }
}

- (void)setColor:(UIColor *)color{
    _color = color;
    _bar.backgroundColor = color;
}

- (void)setRadius:(CGFloat)radius{
    _radius = radius;
    _bar.clipsToBounds = YES;
    _bar.layer.cornerRadius = radius;
}

- (NSTimer *)timer{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:_duration target:self selector:@selector(animation) userInfo:nil repeats:YES];
    }
    return _timer;
}

@end


@interface JHSoundWaveView()
@property (nonatomic,  strong) JHSoundWaveConfig *config;
@end

@implementation JHSoundWaveView

- (instancetype)init{
    return [[JHSoundWaveView alloc] initWithFrame:CGRectMake(0, 0, 10, 10) config:[[JHSoundWaveConfig alloc] init]];
}

- (instancetype)initWithFrame:(CGRect)frame{
    return [[JHSoundWaveView alloc] initWithFrame:frame config:[[JHSoundWaveConfig alloc] init]];
}

- (instancetype)initWithFrame:(CGRect)frame config:(JHSoundWaveConfig *)config{
    if (self = [super initWithFrame:frame]) {
        _config = config;
        [self setupViews];
    }
    return self;
}

- (void)setupViews
{
    for (NSInteger i = 0; i < _config.count; i++) {
        JHSoundWaveBar *bar = [[JHSoundWaveBar alloc] initWithFrame:CGRectMake(_config.leftMargin+(_config.width+_config.space)*i, 0, _config.width, CGRectGetHeight(self.bounds))];
        bar.duration = 1+0.1*(i%_config.count*0.25);
        bar.color = _config.color;
        bar.radius = _config.radius;
        [self addSubview:bar];
    }
    
    UIView *bar = [self.subviews lastObject];
    CGFloat maxWidth = CGRectGetMaxX(bar.frame);
    CGRect frame = self.frame;
    frame.size.width = maxWidth;
    self.frame = frame;
}

- (void)shouldStartAnimation:(BOOL)flag
{
    for (JHSoundWaveBar *subview in self.subviews) {
        [subview shouldStartAnimation:flag];
    }
}

- (void)startAnimation
{
    [self shouldStartAnimation:YES];
}

- (void)stopAnimation
{
    [self shouldStartAnimation:NO];
}

@end

