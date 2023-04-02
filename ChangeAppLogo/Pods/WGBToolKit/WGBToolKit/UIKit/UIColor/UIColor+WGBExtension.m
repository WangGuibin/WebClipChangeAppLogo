//
//  UIColor+WGBExtension.m
//  WGBCocoaKit
//
//  Created by CoderWGB on 2018/8/10.
//  Copyright © 2018年 CoderWGB. All rights reserved.
//

#import "UIColor+WGBExtension.h"

@implementation UIColor (WGBExtension)
+ (UIColor *)wgb_colorWithHexString:(NSString *)color alpha:(CGFloat)alpha
{
    //删除字符串中的空格
    
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    
    if ([cString length] < 6)
        
    {
        
        return [UIColor clearColor];
        
    }
    
    // strip 0X if it appears
    
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    
    if ([cString hasPrefix:@"0X"])
        
    {
        
        cString = [cString substringFromIndex:2];
        
    }
    
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    
    if ([cString hasPrefix:@"#"])
        
    {
        
        cString = [cString substringFromIndex:1];
        
    }
    
    if ([cString length] != 6)
        
    {
        
        return [UIColor clearColor];
        
    }
    
    
    
    // Separate into r, g, b substrings
    
    NSRange range;
    
    range.location = 0;
    
    range.length = 2;
    
    //r
    
    NSString *rString = [cString substringWithRange:range];
    
    //g
    
    range.location = 2;
    
    NSString *gString = [cString substringWithRange:range];
    
    //b
    
    range.location = 4;
    
    NSString *bString = [cString substringWithRange:range];
    
    
    
    // Scan values
    
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}

//默认alpha值为1
+ (UIColor *)wgb_colorWithHexString:(NSString *)color
{
    
    return [self wgb_colorWithHexString:color alpha:1.0f];
}


// 注意转换出来的字符串不带＃号
+(NSString*)wgb_toStrByUIColor:(UIColor*)color{
    CGFloat r, g, b, a;
    [color getRed:&r green:&g blue:&b alpha:&a];
    int rgb = (int) (r * 255.0f)<<16 | (int) (g * 255.0f)<<8 | (int) (b * 255.0f)<<0;
    return [NSString stringWithFormat:@"%06x", rgb];
}

// 颜色图片
- (UIImage *)wgb_colorImage{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(1, 1), NO, 0.0);
    [self set];
    UIRectFill(CGRectMake(0, 0, 1, 1));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


@end
