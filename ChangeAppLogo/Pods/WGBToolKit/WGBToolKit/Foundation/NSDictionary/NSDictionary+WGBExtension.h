//
//  NSDictionary+WGBExtension.h
//  WGBCocoaKit
//
//  Created by CoderWGB on 2018/8/10.
//  Copyright © 2018年 CoderWGB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (WGBExtension)
/// MARK:- 字典转json
- (NSString *)wgb_toJsonString;
/// 不换行的json格式
- (NSString *)wgb_toFlatJsonString ;
// 字典转二进制
- (NSData *)wgb_toData;

@end
