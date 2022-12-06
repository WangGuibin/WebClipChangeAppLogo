//
//  InstalledAppManager.h
//  ChangeAppLogo
//
//  Created by 王贵彬 on 2022/11/19.
//

#import <Foundation/Foundation.h>
#import "AppStoreModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface InstalledAppManager : NSObject

+ (InstalledAppManager *)share;

@property (nonatomic,strong) NSMutableArray<AppInfoModel*> *installedApps;

@property (nonatomic,assign) BOOL isLoaded;

- (void)syncData;

//需在加载完才能查找 isLoaded = YES时
- (BOOL)isInstalledWithId:(NSString *)bundleId;

@end

NS_ASSUME_NONNULL_END
