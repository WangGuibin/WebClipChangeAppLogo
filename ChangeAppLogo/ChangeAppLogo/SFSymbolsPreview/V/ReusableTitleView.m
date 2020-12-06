//
//  ReusableTitleView.m
//  SFSymbolsPreview
//
//  Created by YICAI YANG on 2020/5/27.
//  Copyright © 2020 YICAI YANG. All rights reserved.
//

#import "SFSymbolDatasource.h"
#import "ReusableTitleView.h"


@interface ReusableTitleView()

@property( nonatomic, strong ) UILabel                  *titleLabel;

@end

@implementation ReusableTitleView

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if( [super initWithFrame:frame] )
    {
        [self setTitleLabel:({
            UILabel *f = UILabel.new;
            [f setTextColor:UIColor.secondaryLabelColor];
            [f setFont:[UIFont systemFontOfSize:13 weight:UIFontWeightRegular]];
            [self addSubview:f];
            [f setTranslatesAutoresizingMaskIntoConstraints:NO];
            [f.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:16].active = YES;
            [f.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
            f;
        })];
    }
    return self;
}

@end


@interface ReusableSegmentedControlView()

@end

@implementation ReusableSegmentedControlView

- (instancetype)initWithFrame:(CGRect)frame
{
    if( [super initWithFrame:frame] )
    {
        [self setSegmentedControl:({
            NSArray<NSString *> *items = IS_IPAD() ? @[ @"One", @"Four", @"Six", @"Eight" ] : @[ @"One", @"Two", @"Three", @"Four" ];
            UISegmentedControl *f = [UISegmentedControl.alloc initWithItems:items];
            [self addSubview:f];
            [f setTranslatesAutoresizingMaskIntoConstraints:NO];
            [f.widthAnchor constraintEqualToAnchor:self.widthAnchor constant:-32.0f].active = YES;
            [f.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
            [f.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
            f;
        })];
        
        UILabel *textLabel = UILabel.new;
        [textLabel setTextColor:UIColor.labelColor];
        [textLabel setText:NSLocalizedString(@"Number of items in column...", nil)];
        [textLabel setFont:[UIFont systemFontOfSize:15 weight:UIFontWeightRegular]];
        [self addSubview:textLabel];
        [textLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [textLabel.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
        [textLabel.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:16.0f].active = YES;
        [textLabel.bottomAnchor constraintEqualToAnchor:self.segmentedControl.topAnchor].active = YES;
    }
    return self;
}

@end
