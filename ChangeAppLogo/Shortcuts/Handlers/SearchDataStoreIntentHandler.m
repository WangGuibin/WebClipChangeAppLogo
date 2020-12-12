//
//  SearchDataStoreIntentHandler.m
//  ChangeAppLogo
//
//  Created by 王贵彬 on 2020/12/12.
//

#import "SearchDataStoreIntentHandler.h"

@implementation SearchDataStoreIntentHandler
///MARK:- <SearchDataStoreIntentHandling> 查找数据
- (void)handleSearchDataStore:(SearchDataStoreIntent *)intent completion:(void (^)(SearchDataStoreIntentResponse *response))completion {
    NSString *key = intent.storeKey;
    if (!key) {
        SearchDataStoreIntentResponse *errorCode = [[SearchDataStoreIntentResponse alloc] initWithCode:SearchDataStoreIntentResponseCodeFailure userActivity:nil];
        completion(errorCode);
        return;
    }
    NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    SearchDataStoreIntentResponse *success = [SearchDataStoreIntentResponse successIntentResponseWithResult:value];
    completion(success);
}

@end
