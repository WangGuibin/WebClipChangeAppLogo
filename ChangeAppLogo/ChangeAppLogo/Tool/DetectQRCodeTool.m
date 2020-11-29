//
//  DetectQRCodeTool.m
//  ChangeAppLogo
//
//  Created by 王贵彬 on 2020/11/29.
//

#import "DetectQRCodeTool.h"
#import <CoreImage/CoreImage.h>

@implementation DetectQRCodeTool
///MARK:- 识别二维码
+ (NSString *)detectQrCodeWithImage:(UIImage *)image{
    CIImage *ciImage = [[CIImage alloc] initWithCGImage:image.CGImage options:nil];
    CIContext *ciContext = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(YES)}];
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:ciContext options:@{CIDetectorAccuracy : CIDetectorAccuracyHigh}]; //高精度
    NSArray *features = [detector featuresInImage:ciImage];
    NSString *resultText = nil;
    if (!features || features.count == 0) {
        /// 图片中没有二维码
        return resultText;
    }else {
        for (CIQRCodeFeature *feature in features) {
//            NSLog(@"qrCodeUrl = %@",feature.messageString);
            resultText = feature.messageString;
        }
    }
    return resultText;
}




@end
