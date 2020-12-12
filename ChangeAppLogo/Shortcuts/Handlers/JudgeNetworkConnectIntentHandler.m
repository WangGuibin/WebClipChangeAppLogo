//
//  JudgeNetworkConnectIntentHandler.m
//  ChangeAppLogo
//
//  Created by 王贵彬 on 2020/12/12.
//

#import "JudgeNetworkConnectIntentHandler.h"
#import "WGBReachability.h"

@implementation JudgeNetworkConnectIntentHandler
///MARK:- 是否联网
- (void)handleJudgeNetworkConnect:(JudgeNetworkConnectIntent *)intent completion:(void (^)(JudgeNetworkConnectIntentResponse *response))completion {
    BOOL isReachable = [WGBReachability judgeIsConnectionAvailable];
    JudgeNetworkConnectIntentResponse *success = [JudgeNetworkConnectIntentResponse successIntentResponseWithResult:@(isReachable)];
    completion(success);
}

@end
