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
#import "UUIDGenerateIntent.h"
#import "MD5Intent.h"
#import "NSString+WGBExtension.h"
#import "ChangeLogoOnlyOneIntent.h"
#import "ChageLogoMobileconfig.h"
#import "ChangeBatchLogoConfigIntent.h"
#import "ChangeBatchAppLogoGroupIntent.h"
#import "WGBReachability.h"
#import "JudgeNetworkConnectIntent.h"
#import "DetectQRCodeTool.h"
#import "DetectedQRCodeIntent.h"


// As an example, this class is set up to handle Message intents.
// You will want to replace this or add other intents as appropriate.
// The intents you wish to handle must be declared in the extension's Info.plist.

// You can test your example integration by saying things to Siri like:
// "Send a message using <myApp>"
// "<myApp> John saying hello"
// "Search for messages in <myApp>"

@interface IntentHandler () <DataStoreIntentHandling,SearchDataStoreIntentHandling,DeleteDataStoreIntentHandling,PinWordsSegmentIntentHandling,VCardTemplateIntentHandling,UUIDGenerateIntentHandling,MD5IntentHandling,ChangeLogoOnlyOneIntentHandling,ChangeBatchLogoConfigIntentHandling,ChangeBatchAppLogoGroupIntentHandling,JudgeNetworkConnectIntentHandling,DetectedQRCodeIntentHandling>

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


///MARK:- 生成UUID
- (void)handleUUIDGenerate:(UUIDGenerateIntent *)intent completion:(void (^)(UUIDGenerateIntentResponse *response))completion {
    UUIDGenerateIntentResponse *success = [UUIDGenerateIntentResponse successIntentResponseWithUuid:[NSString UUID]];
    completion(success);
}

///MARK:- 生成MD5
- (void)handleMD5:(MD5Intent *)intent completion:(void (^)(MD5IntentResponse *response))completion {
    NSString *str = intent.text;
    MD5IntentResponse *success = [MD5IntentResponse successIntentResponseWithMd5:[str md5String]];
    completion(success);
}

///MARK:- 一次生成一个更换应用图标的描述文件
- (void)handleChangeLogoOnlyOne:(ChangeLogoOnlyOneIntent *)intent completion:(void (^)(ChangeLogoOnlyOneIntentResponse *response))completion {
    NSString *appconfigStr = [ChageLogoMobileconfig createOneAppConfigWithIcon:intent.iconBase64 isRemoveFromDestop:intent.isRemoveDesktop appName:intent.appName uuid:[NSUUID UUID].UUIDString bundleId:intent.bundleId];
    NSString *fileString = [ChageLogoMobileconfig addConfigIntoGroupWithConfigs:appconfigStr appSetName:intent.appName uuid:[NSUUID UUID].UUIDString];
    NSData *data = [fileString dataUsingEncoding:NSUTF8StringEncoding];
    INFile *file = [INFile fileWithData:data filename:@"result" typeIdentifier:@"mobileconfig"];
    ChangeLogoOnlyOneIntentResponse *success = [ChangeLogoOnlyOneIntentResponse successIntentResponseWithResult:file];
    completion(success);
}

///MARK:- 一次生成更换应用图标的描述文件配置1
- (void)handleChangeBatchLogoConfig:(ChangeBatchLogoConfigIntent *)intent completion:(void (^)(ChangeBatchLogoConfigIntentResponse *response))completion {
    NSString *appconfigStr = [ChageLogoMobileconfig createOneAppConfigWithIcon:intent.base64 isRemoveFromDestop:intent.isRemoveDesktop appName:intent.appName uuid:[NSUUID UUID].UUIDString bundleId:intent.bundleId];
    ChangeBatchLogoConfigIntentResponse *success = [ChangeBatchLogoConfigIntentResponse successIntentResponseWithResult:appconfigStr];
    completion(success);
}

///MARK:- 一次生成更换应用图标的描述文件配置2
- (void)handleChangeBatchAppLogoGroup:(ChangeBatchAppLogoGroupIntent *)intent completion:(void (^)(ChangeBatchAppLogoGroupIntentResponse *response))completion {
    NSString *fileString = [ChageLogoMobileconfig addConfigIntoGroupWithConfigs:intent.appConfigs appSetName:intent.name uuid:[NSUUID UUID].UUIDString];
    ChangeBatchAppLogoGroupIntentResponse *success = [ChangeBatchAppLogoGroupIntentResponse successIntentResponseWithResult:fileString];
    completion(success);
}

///MARK:- 是否联网
- (void)handleJudgeNetworkConnect:(JudgeNetworkConnectIntent *)intent completion:(void (^)(JudgeNetworkConnectIntentResponse *response))completion {
    BOOL isReachable = [WGBReachability judgeIsConnectionAvailable];
    JudgeNetworkConnectIntentResponse *success = [JudgeNetworkConnectIntentResponse successIntentResponseWithResult:@(isReachable)];
    completion(success);
}

///MARK:- 识别二维码
- (void)handleDetectedQRCode:(DetectedQRCodeIntent *)intent completion:(void (^)(DetectedQRCodeIntentResponse *response))completion NS_SWIFT_NAME(handle(intent:completion:)){
    UIImage *image = [UIImage imageWithData:intent.image.data];
    NSString *text = [DetectQRCodeTool detectQrCodeWithImage:image];
    DetectedQRCodeIntentResponse *success = [DetectedQRCodeIntentResponse successIntentResponseWithText:text];
    completion(success);
}

@end
