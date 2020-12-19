//
//  AppListViewController.h
//  ChangeAppLogo
//
//  Created by 王贵彬 on 2020/10/24.
//

#import <UIKit/UIKit.h>
#import "AppStoreModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppListViewController : UIViewController
//选择的app
@property (nonatomic, copy) void (^callBack)(AppInfoModel *model);

@end

NS_ASSUME_NONNULL_END
