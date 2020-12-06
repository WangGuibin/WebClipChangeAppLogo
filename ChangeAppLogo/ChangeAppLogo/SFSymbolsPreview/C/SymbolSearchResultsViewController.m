//
//  SymbolSearchResultsViewController.m
//  SFSymbolsPreview
//
//  Created by YICAI YANG on 2020/5/27.
//  Copyright © 2020 YICAI YANG. All rights reserved.
//

#import "SymbolSearchResultsViewController.h"
//#import "SymbolDetailsViewController.h"
#import "ReusableTitleView.h"
#import "SFSymbolDatasource.h"


@interface SymbolSearchResultsViewController()

@property( nonatomic, strong ) SFSymbolCategory         *searchResult;

@end

@implementation SymbolSearchResultsViewController

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *text = [NSString stringWithFormat:@"%@", searchController.searchBar.text];
    UIColor *tintColor = self.view.tintColor;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        __block NSMutableArray<SFSymbol *> *searchResults = @[].mutableCopy;
        [self.category.symbols enumerateObjectsUsingBlock:^(SFSymbol *symbol, NSUInteger index, BOOL *stop){
            NSRange range = [symbol.name rangeOfString:text options:NSCaseInsensitiveSearch];
            if( range.location != NSNotFound )
            {
                NSMutableAttributedString *attributedName = [NSAttributedString.alloc initWithString:symbol.name attributes:@{
                    NSForegroundColorAttributeName: UIColor.labelColor,
                    NSFontAttributeName: [UIFont systemFontOfSize:15 weight:UIFontWeightRegular]
                }].mutableCopy;
                [attributedName setAttributes:@{
                    NSForegroundColorAttributeName: tintColor,
                    NSFontAttributeName: [UIFont systemFontOfSize:15 weight:UIFontWeightMedium]
                } range:range];
                
                [searchResults addObject:[SFSymbol symbolWithAttributedName:attributedName]];
            }
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setSearchResult:[SFSymbolCategory.alloc initWithSearchResultsCategoryWithSymbols:searchResults]];
            [self.collectionView reloadData];
        });
    });
}

- (NSArray<SFSymbol *> *)symbolsForDisplay
{
    return self.searchResult.symbols;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.view setBackgroundColor:UIColor.secondarySystemBackgroundColor];
    [self.collectionView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
    [self.collectionView registerClass:ReusableTitleView.class
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:NSStringFromClass(ReusableTitleView.class)];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.searchResult.symbols.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(CGRectGetWidth(collectionView.bounds), 36);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if( kind == UICollectionElementKindSectionHeader )
    {
        ReusableTitleView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                     withReuseIdentifier:NSStringFromClass(ReusableTitleView.class)
                                                                            forIndexPath:indexPath];
        view.title = [NSString stringWithFormat:@"%@: %ld", NSLocalizedString(@"RESULTS", nil), self.symbolsForDisplay.count];
        return view;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([SFSymbolDatasource isSelectMode]) {
        SFSymbol *model = self.symbolsForDisplay[indexPath.item];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kCallBackSymoblsResultNotification" object:model.name];
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        SymbolDetailsViewController *detailViewController = [SymbolDetailsViewController.alloc initWithSymbol:self.symbolsForDisplay[indexPath.item]];
        [self.searchResultDisplayingNavigationController pushViewController:detailViewController animated:YES];
    }
}

@end
