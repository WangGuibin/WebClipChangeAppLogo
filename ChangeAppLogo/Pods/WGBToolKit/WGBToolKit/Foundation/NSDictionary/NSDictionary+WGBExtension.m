//
//  NSDictionary+WGBExtension.m
//  WGBCocoaKit
//
//  Created by CoderWGB on 2018/8/10.
//  Copyright © 2018年 CoderWGB. All rights reserved.
//

#import "NSDictionary+WGBExtension.h"

@implementation NSDictionary (WGBExtension)

- (NSString *)wgb_toJsonString{
    NSString *jsonStr = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject: self options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
    return jsonStr;
}

- (NSString *)wgb_toFlatJsonString{
    NSString *flatJsonStr = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject: self options:kNilOptions error:nil] encoding:NSUTF8StringEncoding];
    flatJsonStr = [flatJsonStr stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
    return flatJsonStr;
}

// 字典转二进制
- (NSData *)wgb_toData{
    NSData *data = [NSJSONSerialization dataWithJSONObject: self options:kNilOptions error:nil];
    return data;
}

@end
