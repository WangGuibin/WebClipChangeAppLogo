//
//  PinWordsSegmentIntentHandler.m
//  ChangeAppLogo
//
//  Created by 王贵彬 on 2020/12/12.
//

#import "PinWordsSegmentIntentHandler.h"
#import "NSString+WordsSegmentExtension.h"

@implementation PinWordsSegmentIntentHandler

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

@end
