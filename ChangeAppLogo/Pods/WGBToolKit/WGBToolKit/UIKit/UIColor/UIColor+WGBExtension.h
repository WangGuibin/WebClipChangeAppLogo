//
//  UIColor+WGBExtension.h
//  WGBCocoaKit
//
//  Created by CoderWGB on 2018/8/10.
//  Copyright © 2018年 CoderWGB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (WGBExtension)
//从十六进制字符串获取颜色，
+ (UIColor *)wgb_colorWithHexString:(NSString *)color;
//color:支持“#123456”、 “0X123456”、 “123456”三种格式
+ (UIColor *)wgb_colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

// 注意转换出来的字符串不带＃号
+(NSString*)wgb_toStrByUIColor:(UIColor*)color ;

// 颜色图片
- (UIImage *)wgb_colorImage;

@end
