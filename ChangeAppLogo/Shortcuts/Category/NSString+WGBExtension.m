
//
//  NSString+WGBExtension.m
//  WGBCocoaKit
//
//  Created by CoderWGB on 2018/8/10.
//  Copyright © 2018年 CoderWGB. All rights reserved.
//

#import "NSString+WGBExtension.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (WGBExtension)

- (NSString *)md5String{
    const char* input = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02x", result[i]];
    }
    return [digest copy];
}

/**
 *  @brief  获取随机 UUID 例如 E621E1F8-C36C-495A-93FC-0C247A3E6E5F
 *
 *  @return 随机 UUID
 */
+ (NSString *)UUID{
    if([[[UIDevice currentDevice] systemVersion] floatValue] > 6.0)
    {
        return  [[NSUUID UUID] UUIDString];
    }
    else
    {
        CFUUIDRef uuidRef = CFUUIDCreate(NULL);
        CFStringRef uuid = CFUUIDCreateString(NULL, uuidRef);
        CFRelease(uuidRef);
        return (__bridge_transfer NSString *)uuid;
    }
}
/**
 *
 *  @brief  毫秒时间戳 例如 1443066826371
 *
 *  @return 毫秒时间戳
 */
+ (NSString *)msTimestamp
{
    return  [[NSNumber numberWithLongLong:[[NSDate date] timeIntervalSince1970]*1000] stringValue];
}

/**
 *
 *  @brief  秒级时间戳 例如 1443066826371
 *
 *  @return 秒时间戳
 */
+ (NSString *)secTimestamp{
    return  [[NSNumber numberWithLongLong:[[NSDate date] timeIntervalSince1970]*1000000] stringValue];
}


- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    return [self boundingRectWithSize:maxSize options: NSStringDrawingTruncatesLastVisibleLine |
            NSStringDrawingUsesLineFragmentOrigin |
            NSStringDrawingUsesFontLeading
                           attributes: attrs context:nil].size;
}

- (CGSize)sizeWithFont:(UIFont *)font
{
    return [self sizeWithFont:font maxW:MAXFLOAT];
}


// 首尾移除空格或者换行符
- (NSString *)trimString
{
    NSString *trimmedString = [self stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return trimmedString;
}

// Counts number of Words in String  统计字符有效个数 （除去空格换行外）
- (NSUInteger)countNumberOfWords
{
    NSScanner *scanner = [NSScanner scannerWithString:self];
    NSCharacterSet *whiteSpace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSUInteger count = 0;
    while ([scanner scanUpToCharactersFromSet: whiteSpace  intoString: nil]) {
        count++;
    }
    return count;
}


// If my string contains ony letters  如果该字符串只包含字母
- (BOOL)containsOnlyLetters
{
    NSCharacterSet *letterCharacterset = [[NSCharacterSet letterCharacterSet] invertedSet];
    return ([self rangeOfCharacterFromSet:letterCharacterset].location == NSNotFound);
}

// If my string contains only numbers 如果该字符串只包含数字
- (BOOL)containsOnlyNumbers
{
    NSCharacterSet *numbersCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    return ([self rangeOfCharacterFromSet:numbersCharacterSet].location == NSNotFound);
}

// If my string contains letters and numbers 如果该字符串只包含字母和数字
- (BOOL)containsOnlyNumbersAndLetters
{
    NSCharacterSet *numAndLetterCharSet = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    return ([self rangeOfCharacterFromSet:numAndLetterCharSet].location == NSNotFound);
}


/**
 说明：
 
 '[]'   表示匹配其中任意一个字符,@"[abc123]" 表示必须是abc123其中任意一个
 '[^]'  表示匹配不是其中任意一个字符,@"[^abc123]" 表示必须不是是abc123其中任意一个
 '\d'   表示匹配所有的数字 相当于[0-9]
 '.'    表示匹配除换行符号以外的任意字符
 '\w'   表示匹配字母或数字或下划线或汉字
 '\s'    表示匹配任意的空白符
 
 
 '^'    表示匹配必须以什么开始， @"^[a-z]" 表示第一个必须是字母
 '$'    表示匹配必须以什么结尾, @"[123][asd]$" 表示必须以asd其中任意一个字符结尾
 
 '{n}'  表示{}前的字符(字符表达式)必须出现n次, @"[0-9][a-z]{3}"表示数字后面必须有3个字母
 '{n,m}'表示{}前的字符(字符表达式)必须出现最少n次最多m次, @"[0-9][a-z]{3,6}"表示数字后面必须有3到6个字母
 '{n,}' 表示{}前的字符(字符表达式)必须出现最少n次, @"[0-9][a-z]{3,}"表示数字后面至少3个字母
 
 '*'    表示*前面的字符（字符表达式）可以重复出现0次或更多次，@"[a-z][0-9]*" 表示字母后可以有数字
 '+'    表示+前面的字符（字符表达式）可以重复出现1次或更多次
 '?'    表示?前面的字符（字符表达式）可以重复出现0次或1次
 
 
 练习1： 匹配，abc
 练习2： 匹配，包含一个a~z，后面必须是0~9           --> [a-z][0-9] 或者[a-z]\d
 @"[a-z][0-9]"; 或者@"[a-z]\\d";
 练习3： 匹配，必须第一个是字母，第二个是数字         --> ^[a-z][0-9] 或者 ^[a-z]\d
 @"^[a-z][0-9]"; 或者 @"^[a-z]\\d";
 练习4： 匹配，必须第一个是字母，字母后面跟4~9个数字   --> ^[a-z][0-9]{4,9}或者^[a-z]\d{4,9}
 @"^[a-z][0-9]{4,9}"; 或者@"^[a-z]\\d{4,9}";
 练习5： 匹配，不能是数字4~9                      -->[^4-9]
 @"[^4-9]";
 练习6： 匹配，QQ (5-12位数字)匹配                 -->^[1-9][0-9]{4,11}$ 或者 ^[1-9]\d{4,11}$
 @"^[1-9][0-9]{4,11}$"; 或者 @"^[1-9]\d{4,11}$";
 练习7： 匹配，手机，以 13、15、17、18 打头          --> ^1[3578][0-9]{9}$
 @"^1[3578][0-9]{9}$";
 练习8: 匹配,微博数据," @zhangsan:【成都新闻】 #春熙路#宁夏街[偷笑]，@张老五：老西门，城东们[吃惊]@西门吹雪：皮读取#碧波园#白桥[好爱哦]~~~http://baidu.com.news"
 1. 匹配，@xxx：   --> @.*?:
 @"@.*?"
 2. 匹配，话题 #xxx# --> #.*?#
 @"#.*?#"
 3. 匹配表情，[好爱哦] --> [.*?]
 @"\\[.*?\\]"
 
 练习9：urL正则表达式, @"http(s)?://([\w-]+\.)+[\w-]+(/[\w-./?%&=]*)?"
 */

///正则表达式校验 https://regex101.com 在线测试
- (BOOL)regularExpressionVerifyWithPattern:(NSString *)regPattern{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", regPattern];
    return [predicate evaluateWithObject:self];
}

/// 字母数字下划线指定的特殊符号组合 8-16位
- (BOOL)isNumberAndLetterAndCharacter{
    return [self regularExpressionVerifyWithPattern:@"[0-9a-zA-Z_!@#$%^&*+-=]{8,16}"];;
}

- (BOOL)isChinese
{
    return [self regularExpressionVerifyWithPattern:@"(^[\u4e00-\u9fa5]+$)"];
}

- (BOOL)includeChinese
{
    for(int i=0; i< [self length];i++)
    {
        int a =[self characterAtIndex:i];
        if( a >0x4e00&& a <0x9fff){
            return YES;
        }
    }
    return NO;
}

// Is Valid Email  是不是E-mail
- (BOOL)isValidEmail
{
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    return [self regularExpressionVerifyWithPattern:regex];
}

//数字,字母,下划线
- (BOOL)isPassword{
    NSString *regex = @"^\\w+$";
    return [self regularExpressionVerifyWithPattern:regex];
}

- (BOOL)isQQ{
    NSString *regex = @"[1-9][0-9]{4,}";
    return [self regularExpressionVerifyWithPattern:regex];
}

// 正则判断手机号码地址格式
- (BOOL)isMobileNumber {
    //    电信号段:133/153/180/181/189/177
    //    联通号段:130/131/132/155/156/185/186/145/176
    //    移动号段:134/135/136/137/138/139/150/151/152/157/158/159/182/183/184/187/188/147/178
    //    虚拟运营商:170
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$";
    return [self regularExpressionVerifyWithPattern: MOBILE];
}

- (BOOL)isValidPhoneNumber{
    ///MARK:-因为出现有部分用户手机号码下不了单的问题,现在决定砍掉判断手机号码这个功能 留个11位判断就ok了
    return self.length == 11;
}

// Is Valid URL   是不是URL
- (BOOL)isValidUrl{
    NSString *regex =@"[a-zA-z]+://[^\\s]*";
    return [self regularExpressionVerifyWithPattern:regex];
}

#pragma mark- 过滤字符串中的HTML标签-- 不用webview或者富文本渲染就过滤掉吧
+(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    //    NSString * regEx = @"<([^>]*)>";
    //    html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
}

///利用系统的方法 获取识别的URLString数组
- (NSMutableArray<NSString *> *)URLStringArray{
//strArrWithType:(NSTextCheckingType)type{
    NSError *err = nil;
    NSDataDetector *dataDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:&err];
    if (err != nil) {
        return nil;
    }
    
    NSArray<NSTextCheckingResult *> * resultArr = [dataDetector matchesInString:self options:kNilOptions range:NSMakeRange(0, self.length)];
    
    if (resultArr.count == 0) {
        return nil;
    }
    
    NSMutableArray *strArrM = [NSMutableArray array];
    for (NSTextCheckingResult *result in resultArr) {
        [strArrM addObject:[self substringWithRange:result.range]];
    }
    return strArrM;
}


- (CGSize)boundingRectWithSize:(CGSize)size withFont:(NSInteger)font{
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:font]};
    CGSize retSize = [self boundingRectWithSize:size
                                        options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                     attributes:attribute
                                        context:nil].size;
    return retSize;
}


@end
