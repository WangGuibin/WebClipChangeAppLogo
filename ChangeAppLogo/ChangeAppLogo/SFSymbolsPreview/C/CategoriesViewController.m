//
//  CategoriesViewController.m
//  SFSymbolsPreview
//
//  Created by YICAI YANG on 2020/5/28.
//  Copyright © 2020 YICAI YANG. All rights reserved.
//

#import "CategoriesViewController.h"
#import "SymbolsViewController.h"
#import "SFSymbolDatasource.h"


@interface CategoryCell : UITableViewCell

@end

@implementation CategoryCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    [self.textLabel setTextColor:selected ? UIColor.whiteColor : UIColor.labelColor];
    [self.detailTextLabel setTextColor:selected ? UIColor.whiteColor : UIColor.secondaryLabelColor];
    [self.accessoryView setTintColor:self.detailTextLabel.textColor];
    [self.imageView setTintColor:self.textLabel.textColor];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    [self.textLabel setTextColor:highlighted ? UIColor.whiteColor : UIColor.labelColor];
    [self.detailTextLabel setTextColor:highlighted ? UIColor.whiteColor : UIColor.secondaryLabelColor];
    [self.accessoryView setTintColor:self.detailTextLabel.textColor];
    [self.imageView setTintColor:self.textLabel.textColor];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    return [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
}

@end


@interface CategoriesViewController()<UITableViewDelegate, UITableViewDataSource>

@property( nonatomic, strong ) UITableView                          *tableView;

@end

@implementation CategoriesViewController

- (void)dealloc{
    [SFSymbolDatasource setSelectMode:NO];
}

- (SFSymbolCategory *)categoryForIndexPath:(NSIndexPath *)indexPath
{
    return SFSymbolDatasource.datasource.categories[indexPath.row];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:NSLocalizedString(@"Categories", nil)];
    [self.view setBackgroundColor:UIColor.systemBackgroundColor];
    [self.navigationController.navigationBar setPrefersLargeTitles:YES];
    
    [self setTableView:({
        UITableView *f = [UITableView.alloc initWithFrame:CGRectZero style:UITableViewStylePlain];
        [f setDelegate:self];
        [f setDataSource:self];
        [f setTableFooterView:UIView.new];
        [self.view addSubview:f];
        [f setTranslatesAutoresizingMaskIntoConstraints:NO];
        [f.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
        [f.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
        [f.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
        [f.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
        [f registerClass:CategoryCell.class forCellReuseIdentifier:NSStringFromClass(CategoryCell.class)];
        f;
    })];
    
//    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return SFSymbolDatasource.datasource.categories.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(CategoryCell.class)];
    
    cell.selectedBackgroundView = UIView.new;
    cell.selectedBackgroundView.backgroundColor = self.view.tintColor;
    
    SFSymbolCategory *category = [self categoryForIndexPath:indexPath];
    
    [cell.textLabel setText:category.name];
    [cell.textLabel setFont:[UIFont systemFontOfSize:20 weight:UIFontWeightRegular]];
    [cell.detailTextLabel setText:@(category.symbols.count).stringValue];
    [cell.imageView setImage:[UIImage systemImageNamed:category.imageNamed]];
    [cell.imageView setTintColor:cell.textLabel.textColor];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SymbolsViewController *symbolVC = [SymbolsViewController.alloc initWithCategory:[self categoryForIndexPath:indexPath]];
    [self.navigationController pushViewController:symbolVC animated:YES];
}

@end
