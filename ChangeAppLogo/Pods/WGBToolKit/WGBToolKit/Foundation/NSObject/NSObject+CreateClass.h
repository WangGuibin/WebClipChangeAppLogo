//
//  NSObject+CreateClass.h
//  JJYSPlusPlus
//
//  Created by Wangguibin on 2017/8/22.
//  Copyright © 2017年 王贵彬. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (CreateClass)

+ (instancetype)wgb_create:(void(^)(id make))block;
- (instancetype)wgb_create:(void(^)(id make))block;



@end
