//
//  IntentHandler.m
//  Shortcuts
//
//  Created by 王贵彬 on 2020/11/28.
//

#import "IntentHandler.h"
#import "DataStoreIntent.h"
#import "SearchDataStoreIntent.h"
#import "DeleteDataStoreIntent.h"
#import "PinWordsSegmentIntent.h"
#import "NSString+WordsSegmentExtension.h"
#import "VCardTemplateIntent.h"

// As an example, this class is set up to handle Message intents.
// You will want to replace this or add other intents as appropriate.
// The intents you wish to handle must be declared in the extension's Info.plist.

// You can test your example integration by saying things to Siri like:
// "Send a message using <myApp>"
// "<myApp> John saying hello"
// "Search for messages in <myApp>"

@interface IntentHandler () <DataStoreIntentHandling,SearchDataStoreIntentHandling,DeleteDataStoreIntentHandling,PinWordsSegmentIntentHandling,VCardTemplateIntentHandling>

@end

@implementation IntentHandler

- (id)handlerForIntent:(INIntent *)intent {
    // This is the default implementation.  If you want different objects to handle different intents,
    // you can override this and return the handler you want for that particular intent.
    
    return self;
}

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

///MARK:- <PinWordsSegmentIntentHandling> 分词功能
- (void)handlePinWordsSegment:(PinWordsSegmentIntent *)intent completion:(void (^)(PinWordsSegmentIntentResponse *response))completion {
    NSString *text = intent.text;
    NSString *symbol = intent.symbol;
    PinWordsSegmentModeEnum mode = intent.mode;
    PINSegmentationOptions option = PINSegmentationOptionsNone;
    if (mode == PinWordsSegmentModeEnumDeduplication) {
        option = PINSegmentationOptionsDeduplication;
    }else if(mode == PinWordsSegmentModeEnumKeepEnglish){
        option = PINSegmentationOptionsKeepEnglish;
    }else if(mode == PinWordsSegmentModeEnumKeepSymbols){
        option = PINSegmentationOptionsKeepSymbols;
    }else{
        option = PINSegmentationOptionsNone;
    }
    
    NSArray<NSString *> *textArray = [text segment:option];
    if (textArray.count <= 1) {
        PinWordsSegmentIntentResponse *error = [[PinWordsSegmentIntentResponse alloc] initWithCode:(PinWordsSegmentIntentResponseCodeFailure) userActivity:nil];
        completion(error);
    }else{
        NSString *result = [textArray componentsJoinedByString:symbol];
        PinWordsSegmentIntentResponse *success = [PinWordsSegmentIntentResponse successIntentResponseWithResults:result];
        completion(success);
    }
}

///MARK:- <VCardTemplateIntentHandling> vCard模板生成
- (void)handleVCardTemplate:(VCardTemplateIntent *)intent completion:(void (^)(VCardTemplateIntentResponse *response))completion {
//BEGIN:VCARD
//VERSION:3.0
//N:;词典 (name);;;
//ORG:词典 (org);
//PHOTO;ENCODING=b:词典 (image);
//URL:词典 (url);
//END:VCARD
    
    NSString *name = intent.name;
    NSString *org = intent.org;
    NSString *image = intent.image;
    NSString *url = intent.url;
    if (!name) {
        completion([[VCardTemplateIntentResponse alloc] initWithCode:(VCardTemplateIntentResponseCodeFailure) userActivity:nil]);
        return;
    }
    NSString *vCard = [NSString stringWithFormat:@"BEGIN:VCARD\nVERSION:3.0\nN:;%@;;;\nORG:%@;\nPHOTO;ENCODING=b:%@;\nURL:%@;\nEND:VCARD",name,org,image,url];
    VCardTemplateIntentResponse *success = [VCardTemplateIntentResponse successIntentResponseWithResult:vCard];
    completion(success);
}


@end
