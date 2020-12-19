//
//  SFSymbolsIntentIntentHandler.m
//  ChangeAppLogo
//
//  Created by 王贵彬 on 2020/12/12.
//

#import "SFSymbolsIntentIntentHandler.h"
#import <UIKit/UIKit.h>
#import "UIColor+Extends.h"

@implementation SFSymbolsIntentIntentHandler
///MARK:- 获取系统图标
- (void)handleSFSymbolsIntent:(SFSymbolsIntentIntent *)intent completion:(void (^)(SFSymbolsIntentIntentResponse *response))completion NS_SWIFT_NAME(handle(intent:completion:)){
    
    UIImageSymbolWeight weight = (NSInteger)intent.iconWeight;
    CGSize size = CGSizeMake(intent.width.floatValue, intent.height.floatValue);
    UIColor *tinColor = [UIColor colorFromHexCode:intent.tintColor];
    UIColor *bgColor = [UIColor colorFromHexCode:intent.backgroundColor];
    if (!tinColor) {
        tinColor = [UIColor colorWithRed:arc4random()%256/255.0f green:arc4random()%256/255.0f  blue:arc4random()%256/255.0f alpha:1.0f];
    }
    
    if (!bgColor) {
        bgColor = [UIColor colorWithRed:arc4random()%256/255.0f green:arc4random()%256/255.0f  blue:arc4random()%256/255.0f alpha:1.0f];
    }
    UIImage *iconImg = [UIImage systemImageNamed:intent.iconName withConfiguration:[UIImageSymbolConfiguration configurationWithWeight:(weight)]];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:iconImg];
    imageView.tintColor = tinColor;
    imageView.backgroundColor = bgColor;
    imageView.frame = CGRectMake(0, 0, size.width , size.height);
    iconImg = [self snapshotImageWithView:imageView];
    NSData *iconData = UIImagePNGRepresentation(iconImg);
    INFile *file = [INFile fileWithData:iconData filename:intent.iconName typeIdentifier:nil];
    SFSymbolsIntentIntentResponse *result = [SFSymbolsIntentIntentResponse successIntentResponseWithImage:file];
    completion(result);
}

- (UIImage *)snapshotImageWithView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snap;
}

@end
