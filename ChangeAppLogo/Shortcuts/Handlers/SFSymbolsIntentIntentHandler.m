//
//  SFSymbolsIntentIntentHandler.m
//  ChangeAppLogo
//
//  Created by 王贵彬 on 2020/12/12.
//

#import "SFSymbolsIntentIntentHandler.h"
#import <UIKit/UIKit.h>

@implementation SFSymbolsIntentIntentHandler
///MARK:- 获取系统图标
- (void)handleSFSymbolsIntent:(SFSymbolsIntentIntent *)intent completion:(void (^)(SFSymbolsIntentIntentResponse *response))completion NS_SWIFT_NAME(handle(intent:completion:)){
    UIImage *iconImg = [UIImage systemImageNamed:intent.iconName withConfiguration:[UIImageSymbolConfiguration configurationWithWeight:(UIImageSymbolWeightRegular)]];
    NSData *iconData = UIImagePNGRepresentation(iconImg);
    INFile *file = [INFile fileWithData:iconData filename:intent.iconName typeIdentifier:nil];
    SFSymbolsIntentIntentResponse *result = [SFSymbolsIntentIntentResponse successIntentResponseWithImage:file];
    completion(result);
}

@end
