//
//  DetectQRCodeTool.h
//  ChangeAppLogo
//
//  Created by 王贵彬 on 2020/11/29.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DetectQRCodeTool : NSObject
///MARK:- 识别二维码
+ (NSString *)detectQrCodeWithImage:(UIImage *)image;
@end

NS_ASSUME_NONNULL_END
