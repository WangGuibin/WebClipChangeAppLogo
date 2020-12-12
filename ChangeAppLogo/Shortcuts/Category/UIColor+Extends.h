//
//  UIColor+Extends.h
//  AppSupport
//
//  Created by Ben on 15/7/21.
//  Copyright (c) 2015年 NY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extends)

/**
 *  Creates and returns a color object using the specific hex value.
 *
 *  @param hex The hex value that will decide the color.
 *
 *  @return The `UIColor` object.
 */
+ (UIColor *)colorWithHex:(int32_t)hex;

/**
 *  Creates and returns a color object using the specific hex value.
 *
 *  @param hex   The hex value that will decide the color.
 *  @param alpha The opacity of the color.
 *
 *  @return The `UIColor` object.
 */
+ (UIColor *)colorWithHex:(int32_t)hex alpha:(CGFloat)alpha;

/**
 *  Creates and returns a color object using the specific hex value.
 *
 *  @param hexString The hex value that will decide the color.
 *
 *  @return The `UIColor` object.
 */
+ (UIColor *)colorFromHexCode:(NSString *)hexString;

/**
 *  Creates and returns a color object with a random color value. The alpha property is 1.0.
 *
 *  @return The `UIColor` object.
 */
+ (UIColor *)randomColor;

/**
 *  Creates and returns a color object with a random color value.
 *
 *  @param alpha The alpha of the color.
 *
 *  @return The `UIColor` object.
 */
+ (UIColor*)randomColorWithAlpha:(CGFloat)alpha;

/**
 *  Initialize color from 32bit color component.
 *
 *  @param red   Value from 0 to 255
 *  @param green Value from 0 to 255
 *  @param blue  Value from 0 to 255
 *  @param alpha Value from 0 to 255
 *
 *  @return The `UIColor` object.
 */
+ (UIColor *)initWith8bitRed:(UInt8)red green:(UInt8)green blue:(UInt8)blue alpha:(UInt8)alpha;

@end
