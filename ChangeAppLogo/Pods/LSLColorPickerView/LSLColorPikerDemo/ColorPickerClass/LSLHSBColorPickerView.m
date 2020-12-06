//
//  LSLColorPickerView.m
//  KateMcKay
//
//  Created by Bruce Li on 16/4/17.
//  Copyright © 2016年 XMind. All rights reserved.
//

#import "LSLHSBColorPickerView.h"

CGFloat const kLSLColorPickerAnimationDuration = 1.0;
CGFloat const kLSLColorPickerMenuAnimationDuration = 0.25;

#pragma mark - LSLMenuWindow Implementation

/////////////////////////////////////////////
/**            LSLMenuWindow               */
/////////////////////////////////////////////

@interface LSLMenuView : UIView
@end

@implementation LSLMenuView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGSize size = self.frame.size;
    float fw = size.width;
    float fh = size.height * 7 / 9;
    CGSize triangleSize = CGSizeMake(size.width, size.height - fh);
    
    [[UIColor clearColor] set];
    UIRectFill([self bounds]);
    
    // draw rounded rectangle
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context,   fw, fh - 10);                  // right
    CGContextAddArcToPoint(context, fw, fh, fw - 5, fh    , 10);   // right bottom
    CGContextAddArcToPoint(context, 0 , fh, 0     , fh - 5, 10);   // left bottom
    CGContextAddArcToPoint(context, 0 , 0 , fw - 5, 0     , 10);   // left top
    CGContextAddArcToPoint(context, fw, 0 , fw    , fh - 5, 10);   // right top
    CGContextClosePath(context);
    [[UIColor colorWithWhite:0.1 alpha:0.9] setFill];
    CGContextDrawPath(context, kCGPathFillStroke);
    
    // draw triangle
    CGContextBeginPath(context);
    CGContextMoveToPoint(context,    triangleSize.width * 0.35, fh);
    CGContextAddLineToPoint(context, triangleSize.width * 0.50, CGRectGetMaxY(self.frame));
    CGContextAddLineToPoint(context, triangleSize.width * 0.65, fh);
    CGContextClosePath(context);
    [[UIColor colorWithWhite:0.1 alpha:0.9] setFill];
    CGContextDrawPath(context, kCGPathFillStroke);
}

@end

@interface LSLMenuWindow : UIWindow

@property (nonatomic, strong) UILabel *titleLabel;

+ (instancetype)shareMenuWindow;

- (void)updateWithFrame:(CGRect)frame;

+ (void)animationToShowMenu;
+ (void)animationToHiddenMenu;

@end

@implementation LSLMenuWindow

+ (instancetype)shareMenuWindow
{
    static LSLMenuWindow *menuWindow;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        menuWindow = [[LSLMenuWindow alloc] initWithFrame:CGRectMake(0, 0, 70, 45)];
        menuWindow.windowLevel = UIWindowLevelAlert;
        menuWindow.hidden = YES;
        [menuWindow makeKeyAndVisible];
    });
    return menuWindow;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        UIViewController *rootVC = [[UIViewController alloc] init];
        rootVC.view.frame = self.bounds;
        rootVC.view.layer.anchorPoint = CGPointMake(0.5, 1.0);
        rootVC.view.backgroundColor = [UIColor clearColor];
        
        LSLMenuView *menuView = [[LSLMenuView alloc] initWithFrame:rootVC.view.bounds];
        [rootVC.view addSubview:menuView];
        
        CGRect titleFrame = CGRectMake(0, 0, menuView.frame.size.width, menuView.frame.size.height * 7 / 9);
        _titleLabel = [[UILabel alloc] initWithFrame:titleFrame];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor whiteColor];
        [rootVC.view addSubview:_titleLabel];
        
        self.rootViewController = rootVC;
    }
    return self;
}

#pragma mark - getter

- (CGRect)frame
{
    return self.rootViewController.view.frame;
}

#pragma mark -

- (void)updateWithFrame:(CGRect)frame
{
    self.rootViewController.view.frame = frame;
}

+ (void)animationToShowMenu
{
    [LSLMenuWindow shareMenuWindow].hidden = NO;
    
    // animation to show
    CABasicAnimation *scaleAnimation = [CABasicAnimation animation];
    scaleAnimation.keyPath = @"transform.scale";
    scaleAnimation.duration = kLSLColorPickerMenuAnimationDuration;
    scaleAnimation.fromValue = @(0.0);
    scaleAnimation.toValue = @(1.0);
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    scaleAnimation.fillMode = kCAFillModeForwards;
    scaleAnimation.removedOnCompletion = NO;
    [[LSLMenuWindow shareMenuWindow].rootViewController.view.layer addAnimation:scaleAnimation forKey:@"menuWindowScaleToShow"];
}

+ (void)animationToHiddenMenu
{
    // animation to hidden
    CABasicAnimation *scaleAnimation = [CABasicAnimation animation];
    scaleAnimation.keyPath = @"transform.scale";
    scaleAnimation.duration = kLSLColorPickerMenuAnimationDuration;
    scaleAnimation.toValue = @(0.0);
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    scaleAnimation.fillMode = kCAFillModeForwards;
    scaleAnimation.removedOnCompletion = NO;
    [[LSLMenuWindow shareMenuWindow].rootViewController.view.layer addAnimation:scaleAnimation forKey:@"menuWindowScaleToHidden"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kLSLColorPickerMenuAnimationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [LSLMenuWindow shareMenuWindow].hidden = YES;
    });
}

@end

#pragma mark - LSLSlider Implementation

/////////////////////////////////////////////
/**               LSLSlider                */
/////////////////////////////////////////////

typedef void (^SliderValueChangeBlock)(CGFloat value, BOOL confirm);

@interface LSLSlider : UIView

@property(nonatomic) CGFloat value;
@property (nonatomic, strong) UIView *vittaView;
@property (nonatomic, strong) UIButton *indicatorButton;

- (void)changeValue:(CGFloat)value animation:(BOOL)isAnimation;
- (void)sliderValueChangeBlock:(void(^)(CGFloat value, BOOL confirm))sliderValueChangeBlock;

@end

@interface LSLSlider ()

@property (nonatomic, assign) CGFloat minX;
@property (nonatomic, assign) CGFloat maxX;

@property (nonatomic, assign) CGFloat preX;

@property (nonatomic, copy) SliderValueChangeBlock sliderValueChangeBlock;

@end

@implementation LSLSlider

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        CGSize size = frame.size;
        CGFloat indicatorBtnWidth = size.height - 1;
        CGFloat vittaViewWidth = size.width - indicatorBtnWidth;
        _minX = indicatorBtnWidth * 0.5;
        _maxX = size.width - indicatorBtnWidth * 1.5;
        
        CGRect vittaFrame = CGRectMake(_minX, 4, vittaViewWidth, size.height - 8);
        _vittaView = [[UIView alloc] initWithFrame:vittaFrame];
        _vittaView.layer.cornerRadius = vittaFrame.size.height * 0.5;
        _vittaView.layer.masksToBounds = YES;
        _vittaView.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1.0].CGColor;
        _vittaView.layer.borderWidth = 0.1;
        [self addSubview:_vittaView];
        
        _indicatorButton = [[UIButton alloc] initWithFrame:CGRectMake(_maxX, 0, indicatorBtnWidth, indicatorBtnWidth)];
        _indicatorButton.backgroundColor = [UIColor whiteColor];
        _indicatorButton.layer.cornerRadius = indicatorBtnWidth * 0.5;
        _indicatorButton.layer.borderWidth = 0.1;
        _indicatorButton.layer.borderColor = [UIColor colorWithWhite:0.80 alpha:1.0].CGColor;
        _indicatorButton.layer.shadowOffset = CGSizeMake(0, 3);
        _indicatorButton.layer.shadowRadius  = 3;
        _indicatorButton.layer.shadowOpacity = 0.2;
        
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(changedIndicatorButtonPosition:)];
        [_indicatorButton addGestureRecognizer:panRecognizer];
        
        // animation to show or hidden the menu
        [_indicatorButton addTarget:self action:@selector(showMenuByButtonClick:) forControlEvents:UIControlEventTouchDown];
        [_indicatorButton addTarget:self action:@selector(hiddenMenuByButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_indicatorButton];
    }
    return self;
}

#pragma mark -

- (void)changedIndicatorButtonPosition:(UIPanGestureRecognizer *)recognizer
{
    CGRect frame = self.indicatorButton.frame;
    self.preX = frame.origin.x;
    
    CGPoint currentPoint = [recognizer locationInView:self];
    CGFloat moveX = currentPoint.x - self.preX;
    frame.origin.x += moveX;
    if (frame.origin.x < self.minX) {
        frame.origin.x = self.minX;
    }else if (frame.origin.x > self.maxX){
        frame.origin.x = self.maxX;
    }
    self.indicatorButton.frame = frame;
    
    CGFloat actualOffsetX = frame.origin.x - self.minX;
    self.value  = actualOffsetX / (self.vittaView.frame.size.width - 2 * self.minX);
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:{
            if ([LSLMenuWindow shareMenuWindow].hidden) {
                [self changeMenuFrameAndValue];
                [LSLMenuWindow animationToShowMenu];
            }
            break;
        }
        case UIGestureRecognizerStateChanged:{
            if (frame.origin.x >= 0 && frame.origin.x <= self.vittaView.frame.size.width) {
                [self changeMenuFrameAndValue];
                if (self.sliderValueChangeBlock) {
                    self.sliderValueChangeBlock(self.value, NO);
                }
            }
            break;
        }
        case UIGestureRecognizerStateEnded: {
            if (frame.origin.x >= 0 && frame.origin.x <= self.vittaView.frame.size.width) {
                [self changeMenuFrameAndValue];
                if (self.sliderValueChangeBlock) {
                    self.sliderValueChangeBlock(self.value, YES);
                }
            }
            [LSLMenuWindow animationToHiddenMenu];
            
            break;
        }
        default: {
            break;
        }
    }
}

- (void)changeValue:(CGFloat)value animation:(BOOL)isAnimation
{
    if (isAnimation) {
        [self changePositionAnimationWithValue:value andDuration:kLSLColorPickerAnimationDuration];
    }else{
        [self changePositionAnimationWithValue:value andDuration:0.0];
    }
    self.value = value;
}

- (void)changePositionAnimationWithValue:(CGFloat)value andDuration:(CGFloat)duration
{
    CGSize size = self.indicatorButton.frame.size;
    CGFloat vittaViewWidth = self.vittaView.frame.size.width;
    CGFloat toX = value * vittaViewWidth;
    if (toX < self.minX) {
        toX = self.minX;
    }
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:duration animations:^{
        [weakSelf.indicatorButton setCenter:CGPointMake(toX, size.width * 0.5)];
    }];
}

#pragma mark - menu

- (void)hiddenMenuByButtonClick:(UIButton *)button
{
    [LSLMenuWindow animationToHiddenMenu];
}

- (void)showMenuByButtonClick:(UIButton *)button
{
    [self changeMenuFrameAndValue];
    [LSLMenuWindow animationToShowMenu];
}

- (void)changeMenuFrameAndValue
{
    CGRect frame = self.indicatorButton.frame;
    CGRect menuFrame = [LSLMenuWindow shareMenuWindow].frame;
    CGPoint origin = [[LSLMenuWindow shareMenuWindow] convertPoint:self.indicatorButton.center fromView:self.indicatorButton.superview];
    menuFrame.origin.x = origin.x - frame.size.width - 10;
    menuFrame.origin.y = origin.y - frame.size.height - 33;
    
    [[LSLMenuWindow shareMenuWindow] updateWithFrame:menuFrame];
    [LSLMenuWindow shareMenuWindow].titleLabel.text = [NSString stringWithFormat:@"%.1f%@",self.value * 100, @"%"];
}

#pragma mark - setter

- (void)setValue:(CGFloat)value
{
    if (value > 1.0) {
        value = 1.0;
    }else if (value < 0.0){
        value = 0.0;
    }
    _value = value;
}

#pragma mark - block

- (void)sliderValueChangeBlock:(void (^)(CGFloat, BOOL))sliderValueChangeBlock
{
    if (sliderValueChangeBlock) {
        self.sliderValueChangeBlock = sliderValueChangeBlock;
    }
}

@end

#pragma mark - LSLSemiCircleView Implementation

/////////////////////////////////////////////
/**        LSLSemiCircleView           */
/////////////////////////////////////////////

@interface LSLSemiCircleView : UIView

@property (nonatomic) BOOL onRight;

@property (nonatomic, strong) UIColor *semiCircleColor;

@end

@implementation LSLSemiCircleView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _semiCircleColor = [UIColor redColor];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setSemiCircleColor:(UIColor *)semiCircleColor
{
    _semiCircleColor = semiCircleColor;
    [self setNeedsDisplay];
}

- (void)setOnRight:(BOOL)onRight
{
    _onRight = onRight;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGFloat width = self.frame.size.height * 0.5 - 1;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, self.semiCircleColor.CGColor);
    CGContextSetLineWidth(context, 0.0);
    if (self.onRight) {
        CGContextAddArc(context, width + 1, width + 1, width, 0 , M_PI * 2, 1);
    } else {
        CGContextAddArc(context, 0, width + 1, width, 0 , M_PI * 2, 0);
    }
    CGContextDrawPath(context, kCGPathFillStroke);
}
@end

#pragma mark - LSLColorCicle Implementation

///////////////////////////////////////
/**           LSLColorCicle          */
///////////////////////////////////////

@interface LSLColorCicle : UIView
@end
 
@implementation LSLColorCicle

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.layer.cornerRadius = frame.size.width * 0.5;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGPoint center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    CGFloat radiur = self.frame.size.width;
    for (int hue = 0; hue <= 360; hue++) {
        CGFloat secA = (hue) / 180.0 * M_PI + M_PI;
        CGFloat a = radiur * sin(secA);
        CGFloat b = radiur * cos(secA);
        CGPoint toPoint = CGPointMake(b + center.x, a + center.y);
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        path.lineWidth = 3;
        [path moveToPoint:center];
        [path addLineToPoint:toPoint];
        [path stroke];
        [[UIColor colorWithHue:(1.0 * hue / 360) saturation:1.0 brightness:1.0 alpha:1.0] set];
    }
}
@end

#pragma mark - LSLCenterCircleView Implementation

///////////////////////////////////////
/**       LSLCenterCircleView        */
///////////////////////////////////////

@interface LSLCenterCircleView : UIView

@property (nonatomic, strong) LSLSemiCircleView *favoriteColorView;
@property (nonatomic, strong) LSLSemiCircleView *colorView;

@end

@interface LSLCenterCircleView ()
@end

@implementation LSLCenterCircleView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        CGFloat radius = frame.size.width;
        _favoriteColorView = [[LSLSemiCircleView alloc] initWithFrame:CGRectMake(0, 0, radius * 0.5, radius)];
        _favoriteColorView.semiCircleColor = [UIColor redColor];
        [_favoriteColorView setOnRight:NO];
        [self addSubview:_favoriteColorView];
        
        _colorView = [[LSLSemiCircleView alloc] initWithFrame:CGRectMake(radius * 0.5, 0, radius * 0.5, radius)];
        _colorView.semiCircleColor = [UIColor redColor];
        [_favoriteColorView setOnRight:YES];
        [self addSubview:_colorView];
    }
    return self;
}

@end

#pragma mark - LSLDripView Implementation

///////////////////////////////////////
/**           LSLDripView            */
///////////////////////////////////////

@interface LSLDripView : UIView
@end

@implementation LSLDripView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [[UIColor clearColor] set];
    UIRectFill([self bounds]);
    
    CGSize size = self.frame.size;
    CGPoint startPoint = CGPointMake(size.width * 0.5, size.height);
    CGPoint leftControllPoint = CGPointMake(- size.width * 0.73, - size.height * 0.23);
    CGPoint rightControllPoint = CGPointMake(size.width * 1.73,  - size.height * 0.23);
    
    // border
    UIBezierPath* bordeLSLth = [UIBezierPath bezierPath];
    bordeLSLth.lineWidth = 0.5;
    bordeLSLth.lineCapStyle = kCGLineCapRound;
    bordeLSLth.lineJoinStyle = kCGLineCapRound;
    [bordeLSLth moveToPoint:CGPointMake(startPoint.x , startPoint.y)];
    [bordeLSLth addCurveToPoint:CGPointMake(startPoint.x , startPoint.y)
                 controlPoint1:CGPointMake(leftControllPoint.x,  leftControllPoint.y)
                 controlPoint2:CGPointMake(rightControllPoint.x, rightControllPoint.y)];
    [[UIColor colorWithWhite:0.5 alpha:1.0] set];
    [bordeLSLth fill];
    
    // drip
    UIBezierPath* dripPath = [UIBezierPath bezierPath];
    dripPath.lineWidth = 0.0;
    dripPath.lineCapStyle = kCGLineCapRound;
    dripPath.lineJoinStyle = kCGLineCapRound;
    [dripPath moveToPoint:CGPointMake(startPoint.x , startPoint.y)];
    [dripPath addCurveToPoint:CGPointMake(startPoint.x , startPoint.y)
                controlPoint1:CGPointMake(leftControllPoint.x,  leftControllPoint.y)
                controlPoint2:CGPointMake(rightControllPoint.x, rightControllPoint.y)];
    [[UIColor whiteColor] set];
    [dripPath fill];
}

@end

#pragma mark - LSLFavoriteColorView Implementation

/////////////////////////////////////////////
/**         LSLFavoriteColorView        */
/////////////////////////////////////////////

typedef void (^PreSelectColorBlock)(UIColor *);

@interface LSLFavoriteColorView : UIView

@property (nonatomic, strong) NSMutableArray<UIColor *> *preSelectColorArray;

- (void)updateSelectedColor;
- (void)preSelectColorBlock:(void(^)(UIColor *))preSelectColorBlock;

@end

@interface LSLFavoriteColorView ()

@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) NSMutableArray *dotteLineArray;

@property (nonatomic, strong) UIView *topLineVeiw;
@property (nonatomic, strong) UIView *bottomLineVeiw;

@property (nonatomic, copy) PreSelectColorBlock preSelectColorBlock;

@end

NSInteger const kButtonNumber = 5;

@implementation LSLFavoriteColorView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _preSelectColorArray = [NSMutableArray array];
        _buttonArray = [NSMutableArray array];
        _dotteLineArray = [NSMutableArray array];
        
        for (int i = 0; i < kButtonNumber; i++) {
            UIButton *colorButton = [[UIButton alloc] init];
            colorButton.userInteractionEnabled = NO;
            [colorButton addTarget:self action:@selector(preColor:) forControlEvents:UIControlEventTouchDown];
            [_buttonArray addObject:colorButton];
            [self addSubview:colorButton];
            
            CAShapeLayer *dotteLine =  [CAShapeLayer layer];
            [colorButton.layer addSublayer:dotteLine];
            [_dotteLineArray addObject:dotteLine];
        }
        
        // line View
        _topLineVeiw = [[UIView alloc] init];
        _topLineVeiw.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1];
        [self addSubview:_topLineVeiw];
        
        _bottomLineVeiw = [[UIView alloc] init];
        _bottomLineVeiw.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1];
        [self addSubview:_bottomLineVeiw];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat maginY = 2;
    CGRect  frame = self.frame;
    CGFloat buttonHeight = frame.size.height - maginY * 2;
    CGFloat buttonWidht = buttonHeight;
    CGFloat magin = (frame.size.width - kButtonNumber * buttonWidht) / (kButtonNumber + 1) ;
    
    for (int i = 0; i < self.buttonArray.count; i++) {
        UIButton *colorButton = self.buttonArray[i];
        colorButton.frame = CGRectMake(i * (buttonWidht + magin) + magin, maginY, buttonWidht, buttonHeight);
        colorButton.layer.cornerRadius = buttonWidht * 0.5;
        colorButton.layer.masksToBounds = YES;
        
        CAShapeLayer *dotteLine =  self.dotteLineArray[i];
        CGMutablePathRef dottePath =  CGPathCreateMutable();
        dotteLine.lineWidth = 0.5;
        dotteLine.strokeColor = [UIColor colorWithWhite:0.7 alpha:1].CGColor;
        dotteLine.fillColor = [UIColor clearColor].CGColor;
        CGPathAddEllipseInRect(dottePath, nil, CGRectMake(0, 0, buttonWidht, buttonHeight));
        dotteLine.path = dottePath;
        NSArray *arr = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:3],[NSNumber numberWithInt:3], nil];
        dotteLine.lineDashPattern = arr;
        dotteLine.lineDashPhase = 1.0;
        CGPathRelease(dottePath);
    }
    
    _topLineVeiw.frame    = CGRectMake(0, 0, frame.size.width, 0.5);
    _bottomLineVeiw.frame = CGRectMake(0, frame.size.height, frame.size.width, 0.5);
}

- (void)setPreSelectColorArray:(NSMutableArray *)preSelectColorArray
{
    _preSelectColorArray = preSelectColorArray;
    [self updateSelectedColor];
}

- (void)updateSelectedColor
{
    for (int i = 0; i < self.preSelectColorArray.count; i++) {
        UIColor *color = self.preSelectColorArray[i];
        UIButton *button = self.buttonArray[i];
        button.backgroundColor = color;
        button.userInteractionEnabled = YES;
        button.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
        button.layer.borderWidth = 0.1;
        
        CAShapeLayer *dotteLine = self.dotteLineArray[i];
        [dotteLine removeFromSuperlayer];
    }
}

#pragma mark - click

- (void)preColor:(UIButton *)button {
    if (self.preSelectColorBlock) {
        self.preSelectColorBlock(button.backgroundColor);
    }
}

#pragma mark - block

- (void)preSelectColorBlock:(void (^)(UIColor *))preSelectColorBlock {
    if (preSelectColorBlock) {
        self.preSelectColorBlock = preSelectColorBlock;
    }
}

@end

#pragma mark - LSLHSBColorPickerView Implementation

//////////////////////////////////////////////////
/**             LSLHSBColorPickerView              */
//////////////////////////////////////////////////

typedef void(^ColorSelectedBlock)(UIColor *, BOOL);

@interface LSLHSBColorPickerView ()

@property (nonatomic, strong) UIColor *color;

@property (nonatomic, getter=isConfirm) BOOL confirm;

@property (nonatomic, assign) CGFloat hue;
@property (nonatomic, assign) CGFloat saturation;
@property (nonatomic, assign) CGFloat brightness;
@property (nonatomic, assign) CGFloat alpha;

@property (nonatomic, strong) UIView *colorCircleView;
@property (nonatomic, strong) LSLCenterCircleView *centerCircleView;
@property (nonatomic, strong) LSLColorCicle *colorView;
@property (nonatomic, strong) LSLDripView *dripView;

@property (nonatomic, strong) LSLSlider *saturationSlider;
@property (nonatomic, strong) LSLSlider *brightnessSlider;
@property (nonatomic, strong) CAGradientLayer *saturationGradientLayer;
@property (nonatomic, strong) CAGradientLayer *brightnessGradientLayer;

@property (nonatomic, strong) LSLFavoriteColorView *favoriteColorView;

@property (nonatomic, copy)   ColorSelectedBlock colorSelectedBlock;

@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) CGFloat dripViewX;

@property (nonatomic, assign) CGFloat preAngle;
@property (nonatomic, assign) CGFloat preTransformAngle;

@end

@implementation LSLHSBColorPickerView

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    _confirm = NO;
    _hue = 0.0;
    _saturation = 1.0;
    _brightness = 1.0;
    _alpha = 1.0;
    
    _preAngle = 0.0;
    _preTransformAngle = 0.0;
    
    CGFloat magin = 10;
    CGRect frame = self.frame;
    CGFloat square = fmin(frame.size.height, frame.size.width);
    frame.size = CGSizeMake(square * 0.75, square * 0.75);
    CGFloat x = (self.frame.size.width - frame.size.width) * 0.5;
    _radius = frame.size.width * 0.5;
    CGFloat radiusCenter = (frame.size.width - 24) * 0.5;
    
    // colour circle view
    _colorCircleView = [[UIView alloc] initWithFrame:CGRectMake(x, 3, frame.size.width, frame.size.height)];
    _colorCircleView.backgroundColor = [UIColor clearColor];
    
    _colorView = [[LSLColorCicle alloc] initWithFrame:CGRectMake(12, 12, frame.size.width - 24, frame.size.height - 24)];
    [_colorCircleView addSubview:_colorView];
    
    _centerCircleView = [[LSLCenterCircleView alloc] initWithFrame:CGRectMake(0, 0, radiusCenter - 10, radiusCenter - 10)];
    _centerCircleView.center = CGPointMake(_radius, _radius);
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changePreColor:)];
    [_centerCircleView addGestureRecognizer:tapRecognizer];
    [_colorCircleView addSubview:_centerCircleView];
    
    CGFloat dripViewWithAndHeight = 38;
    _dripViewX = _radius - dripViewWithAndHeight * 0.5;
    _dripView = [[LSLDripView alloc] initWithFrame:CGRectMake(_dripViewX, 0, dripViewWithAndHeight, dripViewWithAndHeight)];
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(changedPositionAndColor:)];
    [_dripView addGestureRecognizer:panRecognizer];
    [_colorCircleView addSubview:_dripView];
    
    // animation to show or hidden the menu
    UIButton *dripBtn = [[UIButton alloc] initWithFrame:_dripView.bounds];
    [dripBtn addTarget:self action:@selector(showMenuByButtonClick:) forControlEvents:UIControlEventTouchDown];
    [dripBtn addTarget:self action:@selector(hiddenMenuByButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_dripView addSubview:dripBtn];
    [_dripView bringSubviewToFront:dripBtn];
    
    [self addSubview:_colorCircleView];
    
    // top line View
    UIView *lineViewTop = [[UIView alloc] initWithFrame:CGRectMake(magin * 2,
                                                                   CGRectGetMaxY(_colorCircleView.frame) + 3,
                                                                   self.frame.size.width - 4 * magin,
                                                                   0.5)];
    lineViewTop.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.2];
    [self addSubview:lineViewTop];
    
    // saturation slider
    _saturationSlider = [[LSLSlider alloc] initWithFrame:CGRectMake(magin * 0.5,
                                                                   CGRectGetMaxY(lineViewTop.frame) + 5,
                                                                   self.frame.size.width - magin ,
                                                                   28)];
    [self setupSliderWithSliderName:@"saturationSlider"];
    [self addSubview:_saturationSlider];
    
    UIView *lineViewBottom = [[UIView alloc] initWithFrame:CGRectMake(magin * 2,
                                                                      CGRectGetMaxY(_saturationSlider.frame) + 5,
                                                                      self.frame.size.width - 4 * magin,
                                                                      0.5)];
    lineViewBottom.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.2];
    [self addSubview:lineViewBottom];
    
    _brightnessSlider = [[LSLSlider alloc] initWithFrame:CGRectMake(magin * 0.5,
                                                                   CGRectGetMaxY(lineViewBottom.frame) + 5,
                                                                   self.frame.size.width - magin,
                                                                   28)];
    [self setupSliderWithSliderName:@"brightnessSlider"];
    [self addSubview:_brightnessSlider];
    
    
    // pre selected color view
    _favoriteColorView = [[LSLFavoriteColorView alloc] initWithFrame:CGRectMake(0,
                                                                     CGRectGetMaxY(_brightnessSlider.frame) + 8,
                                                                     self.frame.size.width,
                                                                     35)];
    _favoriteColorView.backgroundColor = [UIColor whiteColor];
    
    NSMutableArray *colorArray = [self getSelectedColorFromeArchiver];
    _favoriteColorView.preSelectColorArray = [colorArray mutableCopy];
    if (colorArray.count > 0) {
        [self setPreColor:colorArray.firstObject];
    }
    
    __weak typeof(self) weakSelf = self;
    [_favoriteColorView preSelectColorBlock:^(UIColor *color) {
        weakSelf.color = color;
        [weakSelf updateColorAndViewPositionWithAnimation:YES];
        
        // return selected color
        [weakSelf revertSelectedColorByBlock];
    }];
    [self addSubview:_favoriteColorView];
}

- (void)setupSliderWithSliderName:(NSString *)sliderName
{
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
    gradientLayer.startPoint = CGPointMake(0.0, 0.0);
    gradientLayer.endPoint   = CGPointMake(1.0, 0.0);
    
    __weak typeof(self)  weakSelf = self;
    if ([sliderName isEqualToString:@"saturationSlider"]) {
        gradientLayer.frame = _saturationSlider.layer.bounds;
        [gradientLayer setColors:[self getMultiSaturationColorWithHue:_hue brightness:_brightness]];
        _saturationGradientLayer = gradientLayer;
        
        [_saturationSlider.vittaView.layer addSublayer:gradientLayer];
        [_saturationSlider sliderValueChangeBlock:^(CGFloat value, BOOL confirm) {
            _confirm = confirm;
            [weakSelf changeColorBySaturation:_saturationSlider];
        }];
        
    }else if ([sliderName isEqualToString:@"brightnessSlider"]){
        gradientLayer.frame = _brightnessSlider.layer.bounds;
        [gradientLayer setColors:[self getMultiBrightnessColorWithHue:_hue saturation:_saturation]];
        _brightnessGradientLayer = gradientLayer;
        
        [_brightnessSlider.vittaView.layer addSublayer:gradientLayer];
        [_brightnessSlider sliderValueChangeBlock:^(CGFloat value, BOOL confirm) {
            _confirm = confirm;
            [weakSelf changeColorByBrightness:_brightnessSlider];
        }];
    }
}

#pragma mark - setter

- (void)setPreColor:(UIColor *)preColor {
    _preColor = preColor;
    
    [self setColor:preColor];
    [self updateColorAndViewPositionWithAnimation:NO];
}

#pragma mark - gesture recognizer action

- (void)changedPositionAndColor:(UIGestureRecognizer *)recognizer
{
    _confirm = NO;
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:{
            if ([LSLMenuWindow shareMenuWindow].hidden) {
                [self changeMenuFrameAndValue];
                [LSLMenuWindow animationToShowMenu];
            }
            break;
        }
        case UIGestureRecognizerStateChanged:{
            CGPoint point = [recognizer locationInView:_colorCircleView];
            CGFloat dx = point.x - self.radius;
            CGFloat dy = point.y - self.radius;
            CGFloat angle = atan2f(dy, dx);
            if (dy != 0) {
                angle += M_PI;
                _hue = angle / (2 * M_PI);
            } else if (dx > 0) {
                _hue = 0.5;
            }
            [self changeValue];
            [self changeMenuFrameAndValue];
            
            break;
        }
        case UIGestureRecognizerStateEnded: {
            _confirm = YES;
            [self changeValue];
            [self changeMenuFrameAndValue];
            [LSLMenuWindow animationToHiddenMenu];
            
            break;
        }
        default: {
            break;
        }
    }
}

#pragma mark -  update Color and View Position

- (void)updateColorAndViewPositionWithAnimation:(BOOL)isAnimation
{
    // update hue, saturation, brightness, alpha
    [self.color getHue:&_hue saturation:&_saturation brightness:&_brightness alpha:&_alpha];
    
    self.centerCircleView.favoriteColorView.semiCircleColor = self.color;
    self.centerCircleView.colorView.semiCircleColor = self.color;
    
    // slider position and color
    [self.saturationSlider changeValue:_saturation animation:isAnimation];
    [self.brightnessSlider changeValue:_brightness animation:isAnimation];
    
    [self.saturationGradientLayer setColors:[self getMultiSaturationColorWithHue:_hue brightness:_brightness]];
    [self.brightnessGradientLayer setColors:[self getMultiBrightnessColorWithHue:_hue saturation:_saturation]];
    
    // dripView positon
    if (isAnimation) {
        [self changeDripViewPositionWithDuration:kLSLColorPickerAnimationDuration];
    }else{
        [self changeDripViewPositionWithDuration:0.01];
    }
}

#pragma mark - slider action

- (void)changeColorBySaturation:(LSLSlider *)slider
{
    _saturation = slider.value;
    [self changeColor];
}

- (void)changeColorByBrightness:(LSLSlider *)slider
{
    _brightness = slider.value;
    [self changeColor];
}

- (void)changeColor
{
    _color = [UIColor colorWithHue:_hue saturation:_saturation brightness:_brightness alpha:_alpha];
    self.centerCircleView.colorView.semiCircleColor = _color;
    
    [self.saturationGradientLayer setColors:[self getMultiSaturationColorWithHue:_hue brightness:_brightness]];
    [self.brightnessGradientLayer setColors:[self getMultiBrightnessColorWithHue:_hue saturation:_saturation]];
    
    // return selected color
    [self revertSelectedColorByBlock];
}

- (NSArray *)getMultiSaturationColorWithHue:(CGFloat)hue brightness:(CGFloat)brightness
{
    return @[
             (id)[UIColor colorWithHue:hue saturation:0.0 brightness:brightness alpha:1.0].CGColor,
             (id)[UIColor colorWithHue:hue saturation:1.0 brightness:brightness alpha:1.0].CGColor
             ];
}

- (NSArray *)getMultiBrightnessColorWithHue:(CGFloat)hue  saturation:(CGFloat)saturation
{
    return @[
             (id)[UIColor colorWithHue:hue saturation:saturation brightness:0.0 alpha:1.0].CGColor,
             (id)[UIColor colorWithHue:hue saturation:saturation brightness:1.0 alpha:1.0].CGColor
             ];
}

#pragma mark - change value and position

- (void)changeValue
{
    [self changeDripViewPositionWithDuration:0.0];
    
    // current selected color
    [self changeColor];
    
    // slider color
    [self.saturationGradientLayer setColors:[self getMultiSaturationColorWithHue:_hue brightness:_brightness ]];
    [self.brightnessGradientLayer setColors:[self getMultiBrightnessColorWithHue:_hue saturation:_saturation]];
}

- (void)changeDripViewPositionWithDuration:(CGFloat)duration
{
    CGFloat currentAngle = M_PI * 2 * _hue - M_PI;
    
    // prevent repeated clicks
    if (self.preAngle != 0 && currentAngle == self.preAngle) return;
    
    CGFloat cx = self.dripViewX * cos(currentAngle) + self.dripViewX;
    CGFloat cy = self.dripViewX * sin(currentAngle) + self.dripViewX;
    CGRect frame = self.dripView.frame;
    frame.origin.x = cx;
    frame.origin.y = cy;
    self.dripView.frame = frame;
    
    // dripView shadow
    CGFloat offsetX = 2 * cos(currentAngle);
    CGFloat offsetY = 2 * sin(currentAngle + M_PI);
    self.dripView.layer.shadowOffset = CGSizeMake(offsetX, offsetY);
    self.dripView.layer.shadowRadius  = 4;
    self.dripView.layer.shadowOpacity = 0.2;
     
    // dripView animation
    CAKeyframeAnimation *positionAnimation = [[CAKeyframeAnimation alloc] init];
    positionAnimation.rotationMode = kCAAnimationRotateAuto;
    
    BOOL isClockwise = YES;
    if ((currentAngle < self.preAngle && currentAngle - self.preAngle > - M_PI) || (currentAngle - self.preAngle > M_PI)) {
        isClockwise = NO;
        positionAnimation.rotationMode = kCAAnimationRotateAutoReverse;
    }
    positionAnimation.keyPath = @"position";
    positionAnimation.path = [UIBezierPath bezierPathWithArcCenter:_centerCircleView.center
                                                            radius:self.dripViewX
                                                        startAngle:self.preAngle
                                                          endAngle:currentAngle
                                                         clockwise:isClockwise].CGPath;
    positionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    positionAnimation.repeatCount = 1;
    positionAnimation.duration = duration;
    positionAnimation.fillMode = kCAFillModeBoth;
    positionAnimation.removedOnCompletion = NO;
    [self.dripView.layer addAnimation:positionAnimation forKey:@"positionAnimation"];
    
    self.preAngle = currentAngle;
}

- (void)changePreColor:(UITapGestureRecognizer *)recognizer
{
    self.color = self.centerCircleView.favoriteColorView.semiCircleColor;
    [self updateColorAndViewPositionWithAnimation:YES];
    
    // return selected color
    [self revertSelectedColorByBlock];
}

#pragma mark - menu

- (void)hiddenMenuByButtonClick:(UIButton *)button {
    [LSLMenuWindow animationToHiddenMenu];
}

- (void)showMenuByButtonClick:(UIButton *)button {
    [self changeMenuFrameAndValue];
    [LSLMenuWindow animationToShowMenu];
}

- (void)changeMenuFrameAndValue
{
    CGPoint origin = [[LSLMenuWindow shareMenuWindow] convertPoint:self.dripView.center fromView:self.dripView.superview];
    CGRect dripFrame = self.dripView.frame;
    CGRect menuFrame = [LSLMenuWindow shareMenuWindow].frame;
    menuFrame.origin.x = origin.x - dripFrame.size.width;
    menuFrame.origin.y = origin.y - menuFrame.size.height - 20;
    
    [[LSLMenuWindow shareMenuWindow] updateWithFrame:menuFrame];
    [LSLMenuWindow shareMenuWindow].titleLabel.text = [NSString stringWithFormat:@"%.0f°",_hue * 360];
}

#pragma mark - save and get selected color frome archiver

- (void)saveSelectedColorToArchiver
{
    self.color = self.centerCircleView.colorView.semiCircleColor;
    
    // remove the same color in array
    for (int i = 0; i < self.favoriteColorView.preSelectColorArray.count; i++) {
        UIColor *color = self.favoriteColorView.preSelectColorArray[i];
        if (CGColorEqualToColor(self.color.CGColor, color.CGColor)) {
            [self.favoriteColorView.preSelectColorArray removeObject:color];
        }
    }
    
    // array count max 5
    if (self.favoriteColorView.preSelectColorArray.count >= 5) {
        [self.favoriteColorView.preSelectColorArray removeLastObject];
    }
    [self.favoriteColorView.preSelectColorArray insertObject:self.color atIndex:0];
    [self.favoriteColorView updateSelectedColor];
    
    // archiver
    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [documents stringByAppendingPathComponent:@"preColor.archiver"];
    BOOL isSuccess = [NSKeyedArchiver archiveRootObject:self.favoriteColorView.preSelectColorArray toFile:path];
    if (!isSuccess) {
        NSLog(@"It's archiver selected color error");
    }
}

- (NSMutableArray *)getSelectedColorFromeArchiver
{
    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [documents stringByAppendingPathComponent:@"preColor.archiver"];
    NSMutableArray *preColor = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    if (preColor) {
        return [preColor mutableCopy];
    }
    return [NSMutableArray array];
}

+ (void)cleanSelectedColorInArchiver
{
    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [documents stringByAppendingPathComponent:@"preColor.archiver"];
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    if ([defaultManager fileExistsAtPath:path]) {
        [defaultManager removeItemAtPath:path error:nil];
    }
} 

#pragma mark - block

- (void)colorSelectedBlock:(void (^)(UIColor *, BOOL))colorSelectedBlock
{
    if (colorSelectedBlock) {
        self.colorSelectedBlock = colorSelectedBlock;
    }
}

- (void)revertSelectedColorByBlock
{
    if (self.colorSelectedBlock) {
        self.colorSelectedBlock(self.color, self.isConfirm);
    }
}

@end
