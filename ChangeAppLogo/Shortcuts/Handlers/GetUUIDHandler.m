//
//  GetUUIDHandler.m
//  ChangeAppLogo
//
//  Created by 王贵彬 on 2020/12/12.
//

#import "GetUUIDHandler.h"
#import "NSString+WGBExtension.h"

@implementation GetUUIDHandler

///MARK:- 生成UUID
- (void)handleUUIDGenerate:(UUIDGenerateIntent *)intent completion:(void (^)(UUIDGenerateIntentResponse *response))completion {
    UUIDGenerateIntentResponse *success = [UUIDGenerateIntentResponse successIntentResponseWithUuid:[NSString UUID]];
    completion(success);
}

@end
