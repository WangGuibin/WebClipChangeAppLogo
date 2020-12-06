//
//  SymbolDetailsViewController.m
//  SFSymbolsPreview
//
//  Created by YICAI YANG on 2020/5/30.
//  Copyright © 2020 YICAI YANG. All rights reserved.
//

#import "SymbolDetailsViewController.h"
#import "SFSymbolDatasource.h"


@interface SymbolDetailsViewController()<UITableViewDelegate, UITableViewDataSource>

@property( nonatomic, strong ) SFSymbol                     *symbol;

@property( nonatomic, strong ) UIImageView                  *imageView;
@property( nonatomic, strong ) UITableView                  *tableView;

@end

@implementation SymbolDetailsViewController

- (instancetype)initWithSymbol:(SFSymbol *)symbol
{
    if( [super init] )
    {
        [self setSymbol:symbol];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:NSLocalizedString(@"Details", nil)];
    [self.view setBackgroundColor:UIColor.systemBackgroundColor];
    [self.navigationController.navigationBar setPrefersLargeTitles:YES];
    
    [self.navigationItem setLargeTitleDisplayMode:UINavigationItemLargeTitleDisplayModeNever];
    [self.navigationItem setRightBarButtonItem:[UIBarButtonItem.alloc initWithTitle:@"Regular"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(changePreferredImageSymbolWeight)]];
    [self updateRightBarButtonItemTitle];
    
    [self setTableView:({
        UITableView *f = [UITableView.alloc initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self setImageView:UIImageView.new];
        [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [self.imageView setTintColor:UIColor.labelColor];
        [f setTableHeaderView:self.imageView];
        [f setDelegate:self];
        [f setDataSource:self];
        [f setRowHeight:UITableViewAutomaticDimension];
        [f setTableFooterView:UIView.new];
        [self.view addSubview:f];
        [f setTranslatesAutoresizingMaskIntoConstraints:NO];
        [f.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
        [f.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
        [f.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
        [f.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
        [f registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
        f;
    })];
    
    [self updatePreviewSymbolImage];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.imageView setFrame:CGRectMake(0, 0, 0, CGRectGetWidth(self.tableView.bounds))];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class)];
 
    if( indexPath.row == 0 )
    {
        [cell.textLabel setText:[[NSLocalizedString(@"Copy", nil) stringByAppendingString:@" "] stringByAppendingString:self.symbol.name]];
        [cell.textLabel setNumberOfLines:0];
        [cell.textLabel setTextColor:self.view.tintColor];
        [cell.textLabel setFont:[UIFont systemFontOfSize:20 weight:UIFontWeightRegular]];
        [cell.imageView setImage:[UIImage systemImageNamed:@"doc.on.doc"]];
        [cell.imageView setTintColor:self.view.tintColor];
    }
    else
    {
        [cell.textLabel setText:NSLocalizedString(@"Share", nil)];
        [cell.textLabel setTextColor:self.view.tintColor];
        [cell.textLabel setFont:[UIFont systemFontOfSize:20 weight:UIFontWeightRegular]];
        [cell.imageView setImage:[UIImage systemImageNamed:@"square.and.arrow.up"]];
        [cell.imageView setTintColor:self.view.tintColor];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( indexPath.row == 0 )
    {
        UIPasteboard.generalPasteboard.string = self.symbol.name;
    }
    else if( indexPath.row == 1 )
    {
        UIActivityViewController *activityVC = [UIActivityViewController.alloc initWithActivityItems:@[ self.symbol.name, self.imageView.image ]
                                                                               applicationActivities:nil];
        if( UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad )
        {
            activityVC.popoverPresentationController.sourceView = [tableView cellForRowAtIndexPath:indexPath];
            activityVC.popoverPresentationController.sourceRect = activityVC.popoverPresentationController.sourceView.bounds;
        }
        [self presentViewController:activityVC animated:YES completion:nil];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)changePreferredImageSymbolWeight
{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil
                                                                    message:nil
                                                             preferredStyle:UIAlertControllerStyleActionSheet];
    [alertC addAction:[UIAlertAction actionWithTitle:@"Ultralight" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self updatePreferredImageSymbolWeight:UIImageSymbolWeightUltraLight];
    }]];
    [alertC addAction:[UIAlertAction actionWithTitle:@"Thin" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self updatePreferredImageSymbolWeight:UIImageSymbolWeightThin];
    }]];
    [alertC addAction:[UIAlertAction actionWithTitle:@"Light" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self updatePreferredImageSymbolWeight:UIImageSymbolWeightLight];
    }]];
    [alertC addAction:[UIAlertAction actionWithTitle:@"Regular" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self updatePreferredImageSymbolWeight:UIImageSymbolWeightRegular];
    }]];
    [alertC addAction:[UIAlertAction actionWithTitle:@"Medium" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self updatePreferredImageSymbolWeight:UIImageSymbolWeightMedium];
    }]];
    [alertC addAction:[UIAlertAction actionWithTitle:@"Semibold" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self updatePreferredImageSymbolWeight:UIImageSymbolWeightSemibold];
    }]];
    [alertC addAction:[UIAlertAction actionWithTitle:@"Bold" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self updatePreferredImageSymbolWeight:UIImageSymbolWeightBold];
    }]];
    [alertC addAction:[UIAlertAction actionWithTitle:@"Heavy" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self updatePreferredImageSymbolWeight:UIImageSymbolWeightHeavy];
    }]];
    [alertC addAction:[UIAlertAction actionWithTitle:@"Black" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self updatePreferredImageSymbolWeight:UIImageSymbolWeightBlack];
    }]];
    [alertC addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil]];
    if( UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad )
    {
        alertC.popoverPresentationController.barButtonItem = self.navigationItem.rightBarButtonItem;
    }
    [self presentViewController:alertC animated:YES completion:nil];
}

- (void)updatePreviewSymbolImage
{
    UIImage *image;
    {
        CGRect imageRect = CGRectMake(0, 0, 512, 512);
        CGRect contentRect = CGRectInset(imageRect, 88, 88);
        CGFloat scale = 3.0f;
        
        image = self.symbol.image;
        image = [image toSize:CGSizeMake(contentRect.size.width, contentRect.size.width * image.size.height / image.size.width)];

        UIGraphicsBeginImageContextWithOptions(imageRect.size, NO, scale);
        [image drawAtPoint:CGPointMake(CGRectGetMidX(imageRect) - image.size.width / 2.0f, CGRectGetMidY(imageRect) - image.size.height / 2.0f)];
        (image = UIGraphicsGetImageFromCurrentImageContext());
        UIGraphicsEndImageContext();
    }
    self.imageView.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

- (void)updateRightBarButtonItemTitle
{
    switch( preferredImageSymbolWeight() )
    {
        case UIImageSymbolWeightUltraLight: self.navigationItem.rightBarButtonItem.title = @"Ultralight"; break;
        case UIImageSymbolWeightThin: self.navigationItem.rightBarButtonItem.title = @"Thin"; break;
        case UIImageSymbolWeightLight: self.navigationItem.rightBarButtonItem.title = @"Light"; break;
        case UIImageSymbolWeightRegular: self.navigationItem.rightBarButtonItem.title = @"Regular"; break;
        case UIImageSymbolWeightMedium: self.navigationItem.rightBarButtonItem.title = @"Medium"; break;
        case UIImageSymbolWeightSemibold: self.navigationItem.rightBarButtonItem.title = @"Semibold"; break;
        case UIImageSymbolWeightBold: self.navigationItem.rightBarButtonItem.title = @"Bold"; break;
        case UIImageSymbolWeightHeavy: self.navigationItem.rightBarButtonItem.title = @"Heavy"; break;
        case UIImageSymbolWeightBlack: self.navigationItem.rightBarButtonItem.title = @"Black"; break;
        default: self.navigationItem.rightBarButtonItem.title = @"Regular"; break;
    }
}

- (void)updatePreferredImageSymbolWeight:(UIImageSymbolWeight)weight
{
    if( weight != preferredImageSymbolWeight() )
    {
        storeUserActivityPreferredImageSymbolWeight(weight);
        [NSNotificationCenter.defaultCenter postNotificationName:PreferredSymbolWeightDidChangeNotification object:nil];
        
        [self updatePreviewSymbolImage];
    }
    [self updateRightBarButtonItemTitle];
}

@end
