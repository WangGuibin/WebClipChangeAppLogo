//
//  InstalledAppManager.m
//  ChangeAppLogo
//
//  Created by 王贵彬 on 2022/11/19.
//

#import "InstalledAppManager.h"
#import <objc/runtime.h>

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
    
    //遍历bundle的方法列表
    //        unsigned int count;
    //        Method *methodList = class_copyMethodList(LSApplicationWorkspace, &count);
    //        NSLog(@"\n------开始------\n");
    //        for (int i = 0; i < count; i++) {
    //            Method method = methodList[i];
    //            NSString *methodName = NSStringFromSelector(method_getName(method));
    //            NSLog(@"%@", methodName);
    //        }
    //        NSLog(@"\n------结束------\n");
    //
    //        free(methodList);
                

    
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
        //过滤系统应用
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
            NSString *appName = [plugin performSelector:@selector(localizedName)];
                                 
            AppInfoModel *model = [AppInfoModel new];
            model.bundleId = bundleIdentifier;
            model.trackName = appName;
            model.version = shortVersionString;
            model.minimumOsVersion = minimumSystemVersion;
            model.sellerName = vendorName;
            [self.installedApps addObject:model];
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



/// 打开指定应用
/// - Parameter bundleId: 应用唯一标识
/// - return 返回YES说明打开了 NO则说明打开失败
- (BOOL)openAppWithId:(NSString *)bundleId{
    Class LSApplicationWorkspace  = NSClassFromString(@"LSApplicationWorkspace");
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    NSObject * workspace = [LSApplicationWorkspace performSelector:@selector(defaultWorkspace)];
    NSString *bundleID = [bundleId stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    BOOL isOpen = [workspace performSelector:@selector(openApplicationWithBundleID:) withObject:bundleID];
#pragma clang diagnostic pop
    return isOpen;
}

@end

/*
    方法列表
 
 __IS_iconDataForVariant:withOptions:
 __IS_iconDataForVariant:preferredIconName:withOptions:
 un_applicationBundleIdentifier
 un_applicationBundleURL
 if_userActivityTypes
 familyID
 isGameCenterEnabled
 isRestricted
 dataContainerURL
 vendorName
 storeFront
 genre
 detach
 signerIdentity
 isWhitelisted
 activityTypes
 ratingRank
 valueForUndefinedKey:
 companionApplicationIdentifier
 itemID
 installType
 .cxx_destruct
 applicationIdentifier
 downloaderDSID
 isBetaApp
 appState
 subgenres
 isInstalled
 signerOrganization
 requiredDeviceCapabilities
 deviceFamily
 isPlaceholder
 isWatchKitApp
 installProgress
 methodSignatureForSelector:
 forwardingTargetForSelector:
 initWithCoder:
 platform
 applicationType
 isRemovedSystemApp
 purchaserDSID
 managedPersonas
 respondsToSelector:
 description
 encodeWithCoder:
 ratingLabel
 environmentVariables
 isDeviceBasedVPP
 teamID
 itemName
 _initWithContext:bundleUnit:applicationRecord:bundleID:resolveAndDetach:
 _initWithBundleUnit:context:bundleIdentifier:
 correspondingApplicationRecord
 registeredDate
 storeCohortMetadata
 genreID
 preferredArchitecture
 staticDiskUsage
 dynamicDiskUsage
 ODRDiskUsage
 plugInKitPlugins
 applicationDSID
 originalInstallType
 appIDPrefix
 externalVersionIdentifier
 betaExternalVersionIdentifier
 sourceAppIdentifier
 applicationVariant
 isAppUpdate
 isNewsstandApp
 supportsODR
 fileSharingEnabled
 iconIsPrerendered
 iconUsesAssetCatalog
 isPurchasedReDownload
 hasMIDBasedSINF
 missingRequiredSINF
 isDeletableIgnoringRestrictions
 _managedPersonas
 _usesSystemPersona
 groupContainerURLs
 isRemoveableSystemApp
 complicationPrincipalClass
 gameCenterEverEnabled
 installFailureReason
 setAlternateIconName:withResult:
 alternateIconName
 primaryIconDataForVariant:
 iconDataForVariant:
 iconDataForVariant:withOptions:
 deviceManagementPolicy
 getDeviceManagementPolicyWithCompletionHandler:
 siriActionDefinitionURLs
 claimedDocumentContentTypes
 claimedURLSchemes
 handlerRankOfClaimForContentType:
 isStandaloneWatchApp
 getGenericTranslocationTargetURL:error:
 getBundleMetadata
 installProgressSync
 bundleModTime
 bundleType
 profileValidated
 UPPValidated
 freeProfileValidated
 userInitiatedUninstall
 setUserInitiatedUninstall:
 localizedNameForContext:preferredLocalizations:useShortNameOnly:
 localizedNameForContext:
 localizedNameForContext:preferredLocalizations:
 _localizedNameWithPreferredLocalizations:useShortNameOnly:
 clearAdvertisingIdentifier
 
 
 */
