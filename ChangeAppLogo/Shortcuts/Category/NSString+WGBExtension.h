//
//  NSString+WGBExtension.h
//  WGBCocoaKit
//
//  Created by CoderWGB on 2018/8/10.
//  Copyright © 2018年 CoderWGB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (WGBExtension)

- (NSString *)md5String;

/**
 *  @brief  获取随机 UUID 例如 E621E1F8-C36C-495A-93FC-0C247A3E6E5F
 *
 *  @return 随机 UUID
 */
+ (NSString *)UUID;
/**
 *
 *  @brief  毫秒时间戳 例如 1443066826371
 *
 *  @return 毫秒时间戳
 */
+ (NSString *)msTimestamp;

/**
 *
 *  @brief  秒级时间戳 例如 1443066826371
 *
 *  @return 秒时间戳
 */
+ (NSString *)secTimestamp;


///MARK:- 文本自适应高度计算
- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW;
- (CGSize)sizeWithFont:(UIFont *)font;

- (NSString *)trimString;
- (NSUInteger)countNumberOfWords;

- (BOOL)containsOnlyLetters;
- (BOOL)containsOnlyNumbers;
- (BOOL)containsOnlyNumbersAndLetters;

///正则表达式校验
- (BOOL)regularExpressionVerifyWithPattern:(NSString *)regPattern;
/// 字母数字下划线指定的特殊符号组合 8-16位
- (BOOL)isNumberAndLetterAndCharacter;
- (BOOL)isChinese;
- (BOOL)includeChinese;
- (BOOL)isValidEmail;
//数字,字母,下划线
- (BOOL)isPassword ;
- (BOOL)isQQ ;
// 正则判断手机号码格式
- (BOOL)isValidPhoneNumber;
- (BOOL)isMobileNumber;
//不是很严谨的URL判断 应该根据业务去判断
- (BOOL)isValidUrl;

#pragma mark- 过滤字符串中的HTML标签-- 不用webview或者富文本渲染就过滤掉吧
+ (NSString *)filterHTML:(NSString *)html ;

///利用系统的方法 获取识别的URLString数组
- (NSMutableArray<NSString *> *)URLStringArray;

/*!
 *  @author  WGB  , 16-05-10 10:05:28
 *
 *  @brief 根据文本内容返回自适应的尺寸
 *
 *  @param size 给定一个尺寸范围
 *  @param font 文本字体
 *
 *  @return 返回一个自适应的尺寸大小
 */
- (CGSize)boundingRectWithSize:(CGSize)size withFont:(NSInteger)font;

@end
