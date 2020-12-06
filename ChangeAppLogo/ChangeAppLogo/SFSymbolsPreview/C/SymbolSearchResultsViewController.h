//
//  SymbolSearchResultsViewController.h
//  SFSymbolsPreview
//
//  Created by YICAI YANG on 2020/5/27.
//  Copyright © 2020 YICAI YANG. All rights reserved.
//

#import "SymbolsViewController.h"


@interface SymbolSearchResultsViewController : SymbolsViewController<UISearchResultsUpdating>

@property( nonatomic, weak ) UINavigationController                 *searchResultDisplayingNavigationController;

@end
