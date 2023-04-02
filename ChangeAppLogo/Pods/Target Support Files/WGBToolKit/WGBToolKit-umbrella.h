#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "WGBToolKit.h"
#import "WGBDebugTool.h"
#import "InjectionIIIHelper.h"
#import "FoundationModule.h"
#import "NSArray+WGBExtension.h"
#import "NSDictionary+WGBExtension.h"
#import "NSObject+CreateClass.h"
#import "UIKitModule.h"
#import "JHSoundWaveView.h"
#import "UILabel+YBAttributeTextTapAction.h"
#import "UIButton+WGBExtension.h"
#import "UIColor+WGBExtension.h"

FOUNDATION_EXPORT double WGBToolKitVersionNumber;
FOUNDATION_EXPORT const unsigned char WGBToolKitVersionString[];

