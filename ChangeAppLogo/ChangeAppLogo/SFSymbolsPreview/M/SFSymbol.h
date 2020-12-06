//
//  SFSymbol.h
//  SFSymbolsPreview
//
//  Created by YICAI YANG on 2020/5/28.
//  Copyright © 2020 YICAI YANG. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SFSymbol : NSObject

@property( nonatomic, copy, readonly ) NSString                       *name;
@property( nonatomic, copy, readonly ) NSAttributedString             *attributedName;
@property( nonatomic, strong, readonly ) UIImage                      *image;

+ (instancetype)symbolWithName:(NSString *)name;
+ (instancetype)symbolWithAttributedName:(NSAttributedString *)attributedName;

@end
