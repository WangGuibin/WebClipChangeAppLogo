//
//  DeleteDataStoreIntentHandler.m
//  ChangeAppLogo
//
//  Created by 王贵彬 on 2020/12/12.
//

#import "DeleteDataStoreIntentHandler.h"

@implementation DeleteDataStoreIntentHandler
///MARK:- <DeleteDataStoreIntentHandling> 删除数据
- (void)handleDeleteDataStore:(DeleteDataStoreIntent *)intent completion:(void (^)(DeleteDataStoreIntentResponse *response))completion {
    NSString *key = intent.storeKey;
    if (!key) {
        completion([DeleteDataStoreIntentResponse failureIntentResponseWithResult:@(0)]);
        return;
    }
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    completion([DeleteDataStoreIntentResponse successIntentResponseWithResult:@(1)]);
}

@end
