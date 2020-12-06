//
//  SFSymbolCategory.h
//  SFSymbolsPreview
//
//  Created by YICAI YANG on 2020/5/28.
//  Copyright © 2020 YICAI YANG. All rights reserved.
//

#import "SFSymbol.h"


@interface SFSymbolCategory : NSObject

@property( nonatomic, strong, readonly ) NSString                       *name;
@property( nonatomic, strong, readonly ) NSString                       *imageNamed;

@property( nonatomic, strong, readonly ) NSArray<SFSymbol *>            *symbols;

- (instancetype)initWithCategoryName:(NSString *)categoryName;
- (instancetype)initWithCategoryName:(NSString *)categoryName imageNamed:(NSString *)imageNamed;
- (instancetype)initWithSearchResultsCategoryWithSymbols:(NSArray<SFSymbol *> *)symbols;

@end
