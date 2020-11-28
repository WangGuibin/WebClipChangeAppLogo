//
//  NSString+WordsSegmentExtension.h
//  ChangeAppLogo
//
//  Created by 王贵彬 on 2020/11/28.
//
// pin作者开源代码 https://github.com/cyanzhong/segmentation

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSInteger, PINSegmentationOptions) {
    PINSegmentationOptionsNone              = 0,
    PINSegmentationOptionsDeduplication     = 1 << 0,//去重
    PINSegmentationOptionsKeepEnglish       = 1 << 1,//保留英文
    PINSegmentationOptionsKeepSymbols       = 1 << 2,//保留符号
};

NS_ASSUME_NONNULL_BEGIN

@interface NSString (WordsSegmentExtension)

- (NSArray<NSString *> *)segment:(PINSegmentationOptions)options;

@end

NS_ASSUME_NONNULL_END
