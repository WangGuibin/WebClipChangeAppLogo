//
//  MD5IntentHandler.m
//  ChangeAppLogo
//
//  Created by 王贵彬 on 2020/12/12.
//

#import "MD5IntentHandler.h"
#import "NSString+WGBExtension.h"

@implementation MD5IntentHandler

///MARK:- 生成MD5
- (void)handleMD5:(MD5Intent *)intent completion:(void (^)(MD5IntentResponse *response))completion {
    NSString *str = intent.text;
    MD5IntentResponse *success = [MD5IntentResponse successIntentResponseWithMd5:[str md5String]];
    completion(success);
}

@end
