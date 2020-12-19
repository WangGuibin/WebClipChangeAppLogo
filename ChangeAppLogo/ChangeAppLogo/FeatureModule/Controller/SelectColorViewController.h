//
//  SelectColorViewController.h
//  ChangeAppLogo
//
//  Created by 王贵彬 on 2020/12/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SelectColorViewController : UIViewController

@property (nonatomic, copy) void(^callBackBlock) (UIColor *color);

@end

NS_ASSUME_NONNULL_END
