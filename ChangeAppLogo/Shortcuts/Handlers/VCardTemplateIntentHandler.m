//
//  VCardTemplateIntentHandler.m
//  ChangeAppLogo
//
//  Created by 王贵彬 on 2020/12/12.
//

#import "VCardTemplateIntentHandler.h"

@implementation VCardTemplateIntentHandler
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
