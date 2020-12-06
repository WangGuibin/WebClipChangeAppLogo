//
//  SymbolPreviewCell.m
//  SFSymbolsPreview
//
//  Created by YICAI YANG on 2020/5/27.
//  Copyright © 2020 YICAI YANG. All rights reserved.
//

#import "SymbolPreviewCell.h"


@interface SymbolPreviewCell()

@property( nonatomic, strong ) UIImageView                      *imageView;
@property( nonatomic, strong ) UILabel                          *textLabel;

@property( nonatomic, strong ) UIView                           *selectedHighlightView;

@end

@implementation SymbolPreviewCell

- (void)setSymbol:(SFSymbol *)symbol
{
    _symbol = symbol;
    
    self.imageView.image = symbol.image;
    if( symbol.attributedName )
    {
        self.textLabel.attributedText = symbol.attributedName;
    }
    else
    {
        self.textLabel.text = symbol.name;
    }
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    [self.selectedHighlightView setBackgroundColor:selected ? self.tintColor : UIColor.clearColor];
    [self.imageView setTintColor:selected ? UIColor.whiteColor : UIColor.labelColor];
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    [self.selectedHighlightView setBackgroundColor:highlighted ? self.tintColor : UIColor.clearColor];
    [self.imageView setTintColor:highlighted ? UIColor.whiteColor : UIColor.labelColor];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if( [super initWithFrame:frame] )
    {
        [self setSelectedHighlightView:({
            UIView *f = UIView.new;
            [f.layer setCornerRadius:4.0f];
            [f.layer setBorderWidth:1.0f];
            [f.layer setBorderColor:UIColor.separatorColor.CGColor];
            [self.contentView addSubview:f];
            [f setTranslatesAutoresizingMaskIntoConstraints:NO];
            [f.topAnchor constraintEqualToAnchor:self.contentView.topAnchor].active = YES;
            [f.widthAnchor constraintEqualToAnchor:self.contentView.widthAnchor].active = YES;
            [f.heightAnchor constraintEqualToAnchor:self.contentView.widthAnchor multiplier:.68f].active = YES;
            [f.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor].active = YES;
            f;
        })];
        
        [self setImageView:({
            UIImageView *f = [UIImageView.alloc initWithImage:[UIImage systemImageNamed:@"paperplane.fill"]];
            [f setContentMode:UIViewContentModeScaleAspectFit];
            [f setTintColor:UIColor.labelColor];
            [self.selectedHighlightView addSubview:f];
            [f setTranslatesAutoresizingMaskIntoConstraints:NO];
            [f.heightAnchor constraintEqualToAnchor:self.selectedHighlightView.heightAnchor multiplier:.68f].active = YES;
            [f.widthAnchor constraintEqualToAnchor:f.heightAnchor].active = YES;
            [f.centerXAnchor constraintEqualToAnchor:self.selectedHighlightView.centerXAnchor].active = YES;
            [f.centerYAnchor constraintEqualToAnchor:self.selectedHighlightView.centerYAnchor].active = YES;
            f;
        })];
        [self setTextLabel:({
            UILabel *f = UILabel.new;
            [f setNumberOfLines:2];
            [f setTextAlignment:NSTextAlignmentCenter];
            [f setFont:[UIFont systemFontOfSize:15 weight:UIFontWeightRegular]];
            [self.contentView addSubview:f];
            [f setTranslatesAutoresizingMaskIntoConstraints:NO];
            [f.topAnchor constraintEqualToAnchor:self.selectedHighlightView.bottomAnchor constant:8.0f].active = YES;
            [f.widthAnchor constraintEqualToAnchor:self.contentView.widthAnchor constant:-8.0f].active = YES;
            [f.centerXAnchor constraintEqualToAnchor:self.imageView.centerXAnchor].active = YES;
            f;
        })];
    }
    return self;
}

@end


@interface SymbolPreviewTableCell()

@property( nonatomic, strong ) UIImageView                      *imageView;
@property( nonatomic, strong ) UILabel                          *textLabel;

@end

@implementation SymbolPreviewTableCell

- (void)setSymbol:(SFSymbol *)symbol
{
    _symbol = symbol;
    
    self.imageView.image = symbol.image;
    if( symbol.attributedName )
    {
        self.textLabel.attributedText = symbol.attributedName;
    }
    else
    {
        self.textLabel.text = symbol.name;
    }
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    [self.contentView setBackgroundColor:selected ? self.tintColor : UIColor.clearColor];
    [self.imageView setTintColor:selected ? UIColor.whiteColor : UIColor.labelColor];
    [self.textLabel setTextColor:selected ? UIColor.whiteColor : UIColor.labelColor];
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    [self.contentView setBackgroundColor:highlighted ? self.tintColor : UIColor.clearColor];
    [self.imageView setTintColor:highlighted ? UIColor.whiteColor : UIColor.labelColor];
    [self.textLabel setTextColor:highlighted ? UIColor.whiteColor : UIColor.labelColor];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if( [super initWithFrame:frame] )
    {
        [self.contentView.layer setCornerRadius:2.0f];
        
        [self setImageView:({
            UIImageView *f = [UIImageView.alloc initWithImage:[UIImage systemImageNamed:@"paperplane.fill"]];
            [f setContentMode:UIViewContentModeScaleAspectFit];
            [f setTintColor:UIColor.labelColor];
            [self.contentView addSubview:f];
            [f setTranslatesAutoresizingMaskIntoConstraints:NO];
            [f.leftAnchor constraintEqualToAnchor:self.layoutMarginsGuide.leftAnchor].active = YES;
            [f.widthAnchor constraintEqualToConstant:26.0f].active = YES;
            [f.heightAnchor constraintEqualToConstant:26.0f].active = YES;
            [f.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor].active = YES;
            f;
        })];
        [self setTextLabel:({
            UILabel *f = UILabel.new;
            [f setTextAlignment:NSTextAlignmentLeft];
            [f setFont:[UIFont systemFontOfSize:17 weight:UIFontWeightRegular]];
            [f setNumberOfLines:0];
            [self.contentView addSubview:f];
            [f setTranslatesAutoresizingMaskIntoConstraints:NO];
            [f.leftAnchor constraintEqualToAnchor:self.imageView.rightAnchor constant:16.0f].active = YES;
            [f.rightAnchor constraintEqualToAnchor:self.layoutMarginsGuide.rightAnchor].active = YES;
            [f.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor].active = YES;
            f;
        })];
        
        UIView *stroke = UIView.new;
        [stroke setUserInteractionEnabled:NO];
        [stroke setBackgroundColor:UIColor.separatorColor];
        [self.contentView addSubview:stroke];
        [stroke setTranslatesAutoresizingMaskIntoConstraints:NO];
        [stroke.widthAnchor constraintEqualToAnchor:self.contentView.widthAnchor].active = YES;
        [stroke.heightAnchor constraintEqualToConstant:1.0f / UIScreen.mainScreen.scale].active = YES;
        [stroke.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor].active = YES;
        [stroke.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor].active = YES;
    }
    return self;
}

@end
