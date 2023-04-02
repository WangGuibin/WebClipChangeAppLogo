//
//  BaseTabBarController.m
//  ChangeAppLogo
//
//  Created by 王贵彬 on 2023/4/2.
//

#import "BaseTabBarController.h"
#import <WGBToolKit/UIColor+WGBExtension.h>

#import "AppMainViewController.h"
#import "AppListViewController.h"
#import "GenerateAppLogoConfigViewController.h"
#import "CoreValuesToolViewController.h"
#import "InstalledAppListViewController.h"

@interface BaseTabBarController ()<UITabBarControllerDelegate>

@property(nonatomic,strong)UIView *topView;
@property (nonatomic,strong) NSMutableArray *tabBarButtons;
@property (nonatomic,assign) NSInteger lastSelectIndex;

@end

@implementation BaseTabBarController

- (UIView *)topView
{
    if (!_topView) {
        _topView = [UIView new];
        _topView.backgroundColor = [UIColor wgb_colorWithHexString:@"#E5E5EA"];
    }
    return _topView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSArray *vcArray = @[
        [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([AppMainViewController class])],
        [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([AppListViewController class])],
        [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([GenerateAppLogoConfigViewController class])],
        [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([CoreValuesToolViewController class])],
        [InstalledAppListViewController new]
    ];
    
    NSArray *titleArr = @[
        @"首页",
        @"搜索应用",
        @"生成图标",
        @"价值观编码",
        @"我的应用"
    ];
    NSArray *imgPrefixs = @[
        @"house",
        @"magnifyingglass.circle",
        @"pencil.circle",
        @"gamecontroller",
        @"tray.2",
    ];

    NSMutableArray *childVCs = [NSMutableArray arrayWithCapacity:vcArray.count];
    [vcArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger index, BOOL * _Nonnull stop) {
        NSString *norImgName = [imgPrefixs[index] stringByAppendingString:@""];
        NSString *selImgName = [imgPrefixs[index] stringByAppendingString:@".fill"];
        UINavigationController *navVC = [self createChildVC:obj title:titleArr[index] normalImgName:norImgName selectImgName:selImgName normalColor:[UIColor wgb_colorWithHexString:@"#5A5B5D"] selectedColor:[UIColor wgb_colorWithHexString:@"#FF4284"]];
        [childVCs addObject:navVC];
    }];
    self.viewControllers = [childVCs copy];
    
    UIImage *tabbarImage = [self imageWithColor:[UIColor whiteColor]];
    
    self.tabBar.backgroundImage = tabbarImage;
    self.tabBar.shadowImage = tabbarImage;
    [self.tabBar addSubview:self.topView];
    self.delegate = self;
    self.topView.frame = CGRectMake(0, -1, [UIScreen mainScreen].bounds.size.width, 1);
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;

}



- (UINavigationController *)createChildVC:(UIViewController *)subVC
                                             title:(NSString *)title
                                     normalImgName:(NSString *)norImg
                                     selectImgName:(NSString *)selImg
                                          normalColor:(UIColor *)norColor
                                     selectedColor:(UIColor *)selColor{
    
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:subVC];
    navVC.tabBarItem.title = title;
    [navVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: selColor} forState:UIControlStateSelected];
    navVC.tabBarItem.selectedImage = [[[UIImage systemImageNamed:selImg] imageWithTintColor:selColor] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    navVC.tabBarItem.image = [[[UIImage systemImageNamed:norImg] imageWithTintColor:norColor] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    if (@available(iOS 10.0, *)) {
        [[UITabBar appearance] setUnselectedItemTintColor:norColor];
    } else {
        // Fallback on earlier versions

    }
    return navVC;
}


///MARK:- <UITabBarControllerDelegate>
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    UIControl *control = [self.tabBarButtons objectAtIndex: self.selectedIndex];
    UIView *animationView;
    if ([control isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
        for (UIView *subView in control.subviews) {
            if ([subView isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
                animationView = subView;
            }
        }
    }
    
    if (self.lastSelectIndex != self.selectedIndex) {
        [self addScaleAnimationOnView:animationView];
    } else {
        [self addRotateAnimationOnView:animationView];
    }
    self.lastSelectIndex = self.selectedIndex;
}

//缩放动画
- (void)addScaleAnimationOnView:(UIView *)animationView {
    //需要实现的帧动画，这里根据需求自定义
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"transform.scale";
    animation.values = @[@1.0,@1.3,@0.9,@1.15,@0.95,@1.02,@1.0];
    animation.duration = 1;
    animation.calculationMode = kCAAnimationCubic;
    [animationView.layer addAnimation:animation forKey:nil];
}

//旋转动画
- (void)addRotateAnimationOnView:(UIView *)animationView {
    [UIView animateWithDuration:0.32 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        animationView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
    } completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.70 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
            animationView.layer.transform = CATransform3DMakeRotation(2 * M_PI, 0, 1, 0);
        } completion:nil];
    });
}

- (NSMutableArray *)tabBarButtons{
    if (!_tabBarButtons) {
        _tabBarButtons = [NSMutableArray array];
        for (UIView *tabBarButton in self.tabBar.subviews) {
            if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]){
                [_tabBarButtons addObject:tabBarButton];
            }
        }
    }
    return _tabBarButtons;
}

@end
