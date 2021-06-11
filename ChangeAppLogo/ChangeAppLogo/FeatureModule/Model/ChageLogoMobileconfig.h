//
//  ChageLogoMobileconfig.h
//  ChangeAppLogo
//
//  Created by 王贵彬 on 2020/11/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChageLogoMobileconfig : NSObject

/**
 {
    webclip mobileconfig ..
 
    [
        {app config},
        {app config},
            ...
        {app config},
        {app config},
    ]
    
 }
 */


/// 创建一个应用的局部描述文件代码
/// @param iconBase64 图标base64
/// @param isRemoveFromDestop 是否从桌面移除
/// @param appName 应用标题
/// @param uuid 唯一标识
/// @param bundleId 应用唯一标识 必选
/// @param URL universal link 或者 URLScheme
+ (NSString *)createOneAppConfigWithIcon:(NSString *_Nullable)iconBase64
                          isRemoveFromDestop:(BOOL)isRemoveFromDestop
                                 appName:(NSString *)appName
                                    uuid:(NSString *)uuid
                                bundleId:(NSString *)bundleId
                                     URL:(NSString *_Nullable)URL;


/// 把app的配置组装成一个完整的WebClip描述文件
/// @param configs app的描述文件代码 可以是一个/也可以是拼接好几个
/// @param appSetName 集合描述文件的名字 可选
/// @param uuid 唯一标识
+ (NSString *)addConfigIntoGroupWithConfigs:(NSString*)configs
                                 appSetName:(NSString *_Nullable)appSetName
                                       uuid:(NSString *)uuid;


@end

NS_ASSUME_NONNULL_END
