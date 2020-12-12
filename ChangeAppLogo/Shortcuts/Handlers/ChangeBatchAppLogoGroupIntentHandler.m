//
//  ChangeBatchAppLogoGroupIntentHandler.m
//  ChangeAppLogo
//
//  Created by 王贵彬 on 2020/12/12.
//

#import "ChangeBatchAppLogoGroupIntentHandler.h"
#import "ChageLogoMobileconfig.h"

@implementation ChangeBatchAppLogoGroupIntentHandler

///MARK:- 一次生成更换应用图标的描述文件配置2
- (void)handleChangeBatchAppLogoGroup:(ChangeBatchAppLogoGroupIntent *)intent completion:(void (^)(ChangeBatchAppLogoGroupIntentResponse *response))completion {
    NSString *fileString = [ChageLogoMobileconfig addConfigIntoGroupWithConfigs:intent.appConfigs appSetName:intent.name uuid:[NSUUID UUID].UUIDString];
    ChangeBatchAppLogoGroupIntentResponse *success = [ChangeBatchAppLogoGroupIntentResponse successIntentResponseWithResult:fileString];
    completion(success);
}

@end
