//
//  DataStoreIntentHandler.m
//  ChangeAppLogo
//
//  Created by 王贵彬 on 2020/12/12.
//

#import "DataStoreIntentHandler.h"

@implementation DataStoreIntentHandler

///MARK:- <DataStoreIntentHandling> 数据存储
- (void)handleDataStore:(DataStoreIntent *)intent completion:(void (^)(DataStoreIntentResponse *response))completion{
    NSString *value = intent.inputValue;
    NSString *key = intent.storeKey;
    if (!value || !key) {
        DataStoreIntentResponse *errorCode = [[DataStoreIntentResponse alloc] initWithCode:DataStoreIntentResponseCodeFailure userActivity:nil];
        completion(errorCode);
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    DataStoreIntentResponse *success = [DataStoreIntentResponse successIntentResponseWithResult:value];
    completion(success);
}

@end
