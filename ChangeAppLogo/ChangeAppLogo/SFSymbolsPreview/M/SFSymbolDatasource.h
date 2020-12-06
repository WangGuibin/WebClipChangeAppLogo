//
//  SFSymbolDatasource.h
//  SFSymbolsPreview
//
//  Created by YICAI YANG on 2020/5/28.
//  Copyright © 2020 YICAI YANG. All rights reserved.
//

#import "SFSymbolCategory.h"

BOOL IS_IPAD(void);

SFSymbolCategory *lastOpenedCategeory(void);
void storeUserActivityLastOpenedCategory(SFSymbolCategory *category);

NSUInteger numberOfItemsInColumn(void);
void storeUserActivityNumberOfItemsInColumn(NSUInteger numberOfItems);

FOUNDATION_EXTERN NSNotificationName const PreferredSymbolWeightDidChangeNotification;
UIImageSymbolWeight preferredImageSymbolWeight(void);
void storeUserActivityPreferredImageSymbolWeight(UIImageSymbolWeight weight);


@interface SFSymbolDatasource : NSObject

@property( nonatomic, strong, readonly ) NSArray<SFSymbolCategory *>        *categories;

+ (instancetype)datasource;

@end


@interface UIImage( SharingImageExtension )

- (UIImage *)toSize:(CGSize)size;

@end
