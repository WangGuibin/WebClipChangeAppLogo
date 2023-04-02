//
//  NSObject+CreateClass.m
//  JJYSPlusPlus
//
//  Created by Wangguibin on 2017/8/22.
//  Copyright © 2017年 王贵彬. All rights reserved.
//

#import "NSObject+CreateClass.h"

@implementation NSObject (CreateClass)
+ (instancetype)wgb_create:(void(^)(id make))block{
	id  instance = [[self alloc] init];
	block(instance);
	return instance;
}

- (instancetype)wgb_create:(void(^)(id make))block{
	block(self);
	return self;
}

@end
