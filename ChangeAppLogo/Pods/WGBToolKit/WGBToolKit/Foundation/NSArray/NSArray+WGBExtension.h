//
//  NSArray+WGBExtension.h
//  WGBCocoaKit
//
//  Created by CoderWGB on 2018/8/10.
//  Copyright © 2018年 CoderWGB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray(WGBExtension)

- (NSArray *)wgb_removeFirstObject;
- (NSArray *)wgb_removeLastObject;

- (NSArray *)wgb_addObject:(id)obj;
- (NSArray *)wgb_insertObject:(id)obj withIndex:(NSUInteger)index;

- (NSArray *)wgb_map:(id(^)(id value))map;
- (NSArray *)wgb_filter:(id(^)(id value))filter;

@end
