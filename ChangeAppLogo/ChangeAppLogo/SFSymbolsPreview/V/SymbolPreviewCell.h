//
//  SymbolPreviewCell.h
//  SFSymbolsPreview
//
//  Created by YICAI YANG on 2020/5/27.
//  Copyright © 2020 YICAI YANG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFSymbol.h"


@interface SymbolPreviewCell : UICollectionViewCell

@property( nonatomic, weak ) SFSymbol               *symbol;

@end


@interface SymbolPreviewTableCell : UICollectionViewCell

@property( nonatomic, weak ) SFSymbol               *symbol;

@end
