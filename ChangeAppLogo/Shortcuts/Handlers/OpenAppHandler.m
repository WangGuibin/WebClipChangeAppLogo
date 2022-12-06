//
//  OpenAppHandler.m
//  Shortcuts
//
//  Created by 王贵彬 on 2022/11/3.
//

#import "OpenAppHandler.h"

@implementation OpenAppHandler

- (void)handleOpenAppIntent:(OpenAppIntentIntent *)intent completion:(void (^)(OpenAppIntentIntentResponse * _Nonnull))completion{
    Class LSApplicationWorkspace  = NSClassFromString(@"LSApplicationWorkspace");
    NSObject * workspace = [LSApplicationWorkspace performSelector:@selector(defaultWorkspace)];
    BOOL isopen = [workspace performSelector:@selector(openApplicationWithBundleID:) withObject:intent.bundleId];
    OpenAppIntentIntentResponse *appRes = [[OpenAppIntentIntentResponse alloc] initWithCode:(isopen? OpenAppIntentIntentResponseCodeSuccess : OpenAppIntentIntentResponseCodeFailure) userActivity:nil];
    completion(appRes);
}

@end
