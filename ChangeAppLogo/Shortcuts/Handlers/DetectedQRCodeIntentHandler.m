//
//  DetectedQRCodeIntentHandler.m
//  ChangeAppLogo
//
//  Created by 王贵彬 on 2020/12/12.
//

#import "DetectedQRCodeIntentHandler.h"
#import "DetectQRCodeTool.h"

@implementation DetectedQRCodeIntentHandler

///MARK:- 识别二维码
- (void)handleDetectedQRCode:(DetectedQRCodeIntent *)intent completion:(void (^)(DetectedQRCodeIntentResponse *response))completion NS_SWIFT_NAME(handle(intent:completion:)){
    UIImage *image = [UIImage imageWithData:intent.image.data];
    NSString *text = [DetectQRCodeTool detectQrCodeWithImage:image];
    DetectedQRCodeIntentResponse *success = [DetectedQRCodeIntentResponse successIntentResponseWithText:text];
    completion(success);
}

@end
