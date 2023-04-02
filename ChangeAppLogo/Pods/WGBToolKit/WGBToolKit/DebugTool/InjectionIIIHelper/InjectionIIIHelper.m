//
//  InjectionIIIHelper.m
//  SYLibDemo
//
//  Created by zhangshuangyi on 2019/4/13.
//  Copyright © 2019 ZHSY. All rights reserved.
//

#import "InjectionIIIHelper.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <UIKit/UIKit.h>

@implementation InjectionIIIHelper


/**
 InjectionIII 热部署会调用的一个方法，
 runtime给VC绑定上之后，每次部署完就重新viewDidLoad
 */
void injected (id self, SEL _cmd) {
    //vc 刷新
    if ([self isKindOfClass:[UIViewController class]]) {
        //[self loadView];
        [self viewDidLoad];
        [self viewWillLayoutSubviews];
        [self viewWillAppear:NO];
    }
    //view 刷新
    else if ([self isKindOfClass:[UIView class]]){
        UIViewController *vc = [InjectionIIIHelper viewControllerSupportView:self];
        if (vc && [vc isKindOfClass:[UIViewController class]]) {
            //[vc loadView];
            [vc viewDidLoad];
            [vc viewWillLayoutSubviews];
            [vc viewWillAppear:NO];
        }
    }
}

/**
 获取view 所属的vc，失败为nil
 */
+ (UIViewController *)viewControllerSupportView:(UIView *)view {
    for (UIView* next = [view superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

+ (void)load
{
#if DEBUG
    //注册项目启动监听
    __block id observer =
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {

        //更改bundlePath
        [[NSBundle bundleWithPath:@"/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle"] load];

        [[NSNotificationCenter defaultCenter] removeObserver:observer];
    }];
    
//    //给UIViewController 注册injected 方法
//    class_addMethod([UIViewController class], NSSelectorFromString(@"injected"), (IMP)injected, "v@:");
//    //给uiview 注册injected 方法
//    class_addMethod([UIView class], NSSelectorFromString(@"injected"), (IMP)injected, "v@:");
//    //统一添加 injected 方法
    class_addMethod([NSObject class], NSSelectorFromString(@"injected"), (IMP)injected, "v@:");
    
#endif
}

@end
