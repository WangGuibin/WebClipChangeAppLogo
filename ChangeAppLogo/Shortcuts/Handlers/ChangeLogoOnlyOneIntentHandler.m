//
//  ChangeLogoOnlyOneIntentHandler.m
//  ChangeAppLogo
//
//  Created by 王贵彬 on 2020/12/12.
//

#import "ChangeLogoOnlyOneIntentHandler.h"
#import "ChageLogoMobileconfig.h"

@implementation ChangeLogoOnlyOneIntentHandler
///MARK:- 一次生成一个更换应用图标的描述文件
- (void)handleChangeLogoOnlyOne:(ChangeLogoOnlyOneIntent *)intent completion:(void (^)(ChangeLogoOnlyOneIntentResponse *response))completion {
    NSString *appconfigStr = [ChageLogoMobileconfig createOneAppConfigWithIcon:intent.iconBase64 isRemoveFromDestop:intent.isRemoveDesktop appName:intent.appName uuid:[NSUUID UUID].UUIDString bundleId:intent.bundleId URL:intent.URL];
    NSString *fileString = [ChageLogoMobileconfig addConfigIntoGroupWithConfigs:appconfigStr appSetName:intent.appName uuid:[NSUUID UUID].UUIDString];
    NSData *data = [fileString dataUsingEncoding:NSUTF8StringEncoding];
    INFile *file = [INFile fileWithData:data filename:@"result" typeIdentifier:@"mobileconfig"];
    ChangeLogoOnlyOneIntentResponse *success = [ChangeLogoOnlyOneIntentResponse successIntentResponseWithResult:file];
    completion(success);
}

@end
