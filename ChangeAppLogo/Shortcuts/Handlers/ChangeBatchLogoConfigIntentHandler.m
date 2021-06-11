//
//  ChangeBatchLogoConfigIntentHandler.m
//  ChangeAppLogo
//
//  Created by 王贵彬 on 2020/12/12.
//

#import "ChangeBatchLogoConfigIntentHandler.h"
#import "ChageLogoMobileconfig.h"

@implementation ChangeBatchLogoConfigIntentHandler

///MARK:- 一次生成更换应用图标的描述文件配置1
- (void)handleChangeBatchLogoConfig:(ChangeBatchLogoConfigIntent *)intent completion:(void (^)(ChangeBatchLogoConfigIntentResponse *response))completion {
    NSString *appconfigStr = [ChageLogoMobileconfig createOneAppConfigWithIcon:intent.base64 isRemoveFromDestop:intent.isRemoveDesktop appName:intent.appName uuid:[NSUUID UUID].UUIDString bundleId:intent.bundleId URL:intent.URL];
    ChangeBatchLogoConfigIntentResponse *success = [ChangeBatchLogoConfigIntentResponse successIntentResponseWithResult:appconfigStr];
    completion(success);
}

@end
