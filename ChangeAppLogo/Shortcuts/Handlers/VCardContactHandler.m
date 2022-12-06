//
//  VCardContactHandler.m
//  Shortcuts
//
//  Created by 王贵彬 on 2022/11/19.
//

#import "VCardContactHandler.h"

@implementation VCardContactHandler

- (void)handleVCardContact:(nonnull VCardContactIntent *)intent completion:(nonnull void (^)(VCardContactIntentResponse * _Nonnull))completion {
    // https://github.com/metowolf/vCards
        
    //BEGIN:VCARD
    //VERSION:3.0
    //FN;CHARSET=UTF-8:
    //N;CHARSET=UTF-8:;;;;
    //PHOTO;ENCODING=b;TYPE=PNG:Base64xxxx
    //TEL;TYPE=CELL:400-0682-666
    //ORG;CHARSET=UTF-8:飞书
    //URL;CHARSET=UTF-8:https://www.feishu.cn/
    //REV:2022-11-18T01:57:57.720Z
    //X-ABShowAs:COMPANY
    //END:VCARD

        NSDate *date = [NSDate date];
        NSDateFormatter *formatter  = [NSDateFormatter new];
        formatter.dateFormat = @"YYYY-MM-dd'T'HH:mm:ss.sss'Z'";
        NSString *dateStr = [formatter stringFromDate:date];
        NSString *org = intent.org;
        NSString *image = intent.image;
        NSString *url = intent.url;
        NSString *phone = intent.phone;
        NSString *vCard = [NSString stringWithFormat:@"BEGIN:VCARD\nVERSION:3.0\nFN;CHARSET=UTF-8:\nN;CHARSET=UTF-8:;;;;\nORG:%@;\nPHOTO;ENCODING=b;TYPE=PNG:%@;\nTEL;TYPE=CELL:%@\nURL:%@;\nREV:%@\nX-ABShowAs:COMPANY\nEND:VCARD",org,image,phone,url,dateStr];
    VCardContactIntentResponse *success = [VCardContactIntentResponse successIntentResponseWithResult:vCard];
        completion(success);

}

@end
