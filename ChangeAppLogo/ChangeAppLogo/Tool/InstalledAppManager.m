//
//  InstalledAppManager.m
//  ChangeAppLogo
//
//  Created by 王贵彬 on 2022/11/19.
//

#import "InstalledAppManager.h"

@implementation InstalledAppManager

+ (InstalledAppManager *)share{
    static InstalledAppManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[InstalledAppManager alloc] init];
    });
    return _manager;
}

- (void)syncData{
    self.installedApps = @[].mutableCopy;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self getAppInfoList];
    });
}

/// iOS12+
- (void)getAppInfoList {
    Class LSApplicationWorkspace = objc_getClass("LSApplicationWorkspace");
    Class LSApplicationProxy = objc_getClass("LSApplicationProxy");
    
    id defaultWorkspace = [LSApplicationWorkspace performSelector:@selector(defaultWorkspace)];
    
    // 此方法在iOS12+获取不到
    //    id allApplications = [defaultWorkspace performSelector:@selector(allInstalledApplications)];
    NSArray *plugins = [defaultWorkspace performSelector:@selector(installedPlugins)];
    
    NSMutableSet *list = [[NSMutableSet alloc] init];
    for (id plugin in plugins) {
        id bundle = [plugin performSelector:@selector(containingBundle)];
        if (bundle) {
            [list addObject:bundle];
        }
    }
    // 遍历所有app信息
    for (id plugin in list) {
        // BundleID
        NSString *bundleIdentifier = [plugin performSelector:@selector(bundleIdentifier)];
        if (![bundleIdentifier containsString:@"com.apple"]) {
            
            NSString *itemName = [plugin performSelector:@selector(itemName)];
            NSLog(@"itemName -> %@ bundleIdentifier: %@", itemName,bundleIdentifier);
            
            NSString *applicationDSID = [plugin performSelector:@selector(applicationDSID)];
            NSLog(@"applicationDSID -> %@", applicationDSID);
            
            NSString *applicationIdentifier = [plugin performSelector:@selector(applicationIdentifier)];
            NSLog(@"applicationIdentifier -> %@", applicationIdentifier);
            
            NSString *applicationType = [plugin performSelector:@selector(applicationType)];
            NSLog(@"applicationType -> %@", applicationType);
            
            NSString *dynamicDiskUsage = [plugin performSelector:@selector(dynamicDiskUsage)];
            NSLog(@"dynamicDiskUsage -> %@", dynamicDiskUsage);
            
            NSString *itemID = [plugin performSelector:@selector(itemID)];
            NSLog(@"itemID -> %@", itemID);
            
            
            NSString *minimumSystemVersion = [plugin performSelector:@selector(minimumSystemVersion)];
            NSLog(@"minimumSystemVersion -> %@", minimumSystemVersion);
            
            NSString *requiredDeviceCapabilities = [plugin performSelector:@selector(requiredDeviceCapabilities)];
            NSLog(@"requiredDeviceCapabilities -> %@", requiredDeviceCapabilities);
            
            NSString *sdkVersion = [plugin performSelector:@selector(sdkVersion)];
            NSLog(@"sdkVersion -> %@", sdkVersion);
            
            NSString *shortVersionString = [plugin performSelector:@selector(shortVersionString)];
            NSLog(@"shortVersionString -> %@", shortVersionString);
            
            
            NSString *sourceAppIdentifier = [plugin performSelector:@selector(sourceAppIdentifier)];
            NSLog(@"sourceAppIdentifier -> %@", sourceAppIdentifier);
            
            NSString *staticDiskUsage = [plugin performSelector:@selector(staticDiskUsage)];
            NSLog(@"staticDiskUsage -> %@", staticDiskUsage);
            
            NSString *teamID = [plugin performSelector:@selector(teamID)];
            NSLog(@"teamID -> %@", teamID);
            
            NSString *vendorName = [plugin performSelector:@selector(vendorName)];
            NSLog(@"vendorName -> %@", vendorName);
            
            AppInfoModel *model = [AppInfoModel new];
            model.bundleId = bundleIdentifier;
            model.trackName = itemName;
            model.version = shortVersionString;
            model.minimumOsVersion = minimumSystemVersion;
            model.sellerName = vendorName;
            [self.installedApps addObject:model];
            
        }else{
            NSLog(@"系统应用: %@",bundleIdentifier);
        }
    }
    self.isLoaded = YES;
}


//需在加载完才能查找 isLoaded = YES时
- (BOOL)isInstalledWithId:(NSString *)bundleId{
    if(!self.isLoaded){
        return NO;
    }
    for (AppInfoModel *model in self.installedApps) {
        if([model.bundleId isEqualToString:bundleId]){
            return YES;
        }
    }
    return NO;
}


@end
