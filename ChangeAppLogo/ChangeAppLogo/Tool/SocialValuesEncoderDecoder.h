//
//  SocialValuesEncoderDecoder.h
//  ChangeAppLogo
//
//  Created by 王贵彬 on 2020/11/29.
//

#import <Foundation/Foundation.h>
//社会主义核心价值观 (开源项目地址 https://github.com/sym233/core-values-encoder)

NS_ASSUME_NONNULL_BEGIN

@interface SocialValuesEncoderDecoder : NSObject

+ (SocialValuesEncoderDecoder *)shareCoder;

@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) BOOL isEncode;//是否编码
@property (nonatomic, copy) void (^callBackResultBlock)(NSString *result);

//执行转换操作
- (void)sendCovertJS;

@end

NS_ASSUME_NONNULL_END
