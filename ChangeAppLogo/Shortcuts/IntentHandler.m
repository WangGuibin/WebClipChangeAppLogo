//
//  IntentHandler.m
//  Shortcuts
//
//  Created by 王贵彬 on 2020/11/28.
//

#import "IntentHandler.h"

//数据存储
#import "DataStoreIntentHandler.h"
#import "SearchDataStoreIntentHandler.h"
#import "DeleteDataStoreIntentHandler.h"

//生成唯一标识
#import "GetUUIDHandler.h"
#import "MD5IntentHandler.h"

//分词
#import "PinWordsSegmentIntentHandler.h"
//vCard
#import "VCardTemplateIntentHandler.h"

//更换图标
#import "ChangeLogoOnlyOneIntentHandler.h"
#import "ChangeBatchLogoConfigIntentHandler.h"
#import "ChangeBatchAppLogoGroupIntentHandler.h"

//联网判断
#import "JudgeNetworkConnectIntentHandler.h"
//识别二维码
#import "DetectedQRCodeIntentHandler.h"
//SF Symbols
#import "SFSymbolsIntentIntentHandler.h"

// As an example, this class is set up to handle Message intents.
// You will want to replace this or add other intents as appropriate.
// The intents you wish to handle must be declared in the extension's Info.plist.

// You can test your example integration by saying things to Siri like:
// "Send a message using <myApp>"
// "<myApp> John saying hello"
// "Search for messages in <myApp>"

@interface IntentHandler ()

@end

@implementation IntentHandler

- (id)handlerForIntent:(INIntent *)intent {
    // This is the default implementation.  If you want different objects to handle different intents,
    // you can override this and return the handler you want for that particular intent.
    if ([intent isKindOfClass:[UUIDGenerateIntent class]]) {
        return [GetUUIDHandler new];
    }
    
    if ([intent isKindOfClass:[MD5Intent class]]) {
        return [MD5IntentHandler new];
    }
    
    if ([intent isKindOfClass:[DataStoreIntent class]]) {
        return [DataStoreIntentHandler new];
    }

    if ([intent isKindOfClass:[SearchDataStoreIntent class]]) {
        return [SearchDataStoreIntentHandler new];
    }

    if ([intent isKindOfClass:[DeleteDataStoreIntent class]]) {
        return [DeleteDataStoreIntentHandler new];
    }

    if ([intent isKindOfClass:[PinWordsSegmentIntent class]]) {
        return [PinWordsSegmentIntentHandler new];
    }

    if ([intent isKindOfClass:[VCardTemplateIntent class]]) {
        return [VCardTemplateIntentHandler new];
    }

    if ([intent isKindOfClass:[ChangeLogoOnlyOneIntent class]]) {
        return [ChangeLogoOnlyOneIntentHandler new];
    }

    if ([intent isKindOfClass:[ChangeBatchLogoConfigIntent class]]) {
        return [ChangeBatchLogoConfigIntentHandler new];
    }

    if ([intent isKindOfClass:[ChangeBatchAppLogoGroupIntent class]]) {
        return [ChangeBatchAppLogoGroupIntentHandler new];
    }

    if ([intent isKindOfClass:[JudgeNetworkConnectIntent class]]) {
        return [JudgeNetworkConnectIntentHandler new];
    }
    
    if ([intent isKindOfClass:[DetectedQRCodeIntent class]]) {
        return [DetectedQRCodeIntentHandler new];
    }

    if ([intent isKindOfClass:[SFSymbolsIntentIntent class]]) {
        return [SFSymbolsIntentIntentHandler new];
    }

    return self;
}
 
@end

