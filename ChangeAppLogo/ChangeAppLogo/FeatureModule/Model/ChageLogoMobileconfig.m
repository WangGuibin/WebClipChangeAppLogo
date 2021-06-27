//
//  ChageLogoMobileconfig.m
//  ChangeAppLogo
//
//  Created by 王贵彬 on 2020/11/28.
//

#import "ChageLogoMobileconfig.h"

@implementation ChageLogoMobileconfig
//NSString *iconText = [NSString stringWithFormat:@"<key>Icon</key><data>%@</data>",base64Img];
//if (!base64Img.length) {
//    iconText = @"";
//}


/**
 
 以下这种方式类似于模板,修改一些参数,然后写文件~  逛github时发现一个仓库貌似是外国友人用SwiftUI写的 https://github.com/mamunul/WebClip 他是直接用PropertyListEncoder写xml文件感觉不那么啰嗦...😄 算了 俺也不想改了 就这吧~
 
<dict>
 //是否全屏
 <key>FullScreen</key>
  <true/>
 //是否移除
 <key>IsRemovable</key>
 <%@/>
 
 %@ //图标 iconText
 
 <key>Label</key>
 <string>%@</string>
 
 //描述
 <key>PayloadDescription</key>
 <string>配置 Web Clip 设置</string>
 
 //应用描述文件的名字
 <key>PayloadDisplayName</key>
 <string>Web Clip</string>
 
 //应用描述唯一id 后缀与PayloadUUID一致
 <key>PayloadIdentifier</key>
 <string>com.apple.webClip.managed.xxx</string>
 
 //类型
 <key>PayloadType</key>
 <string>com.apple.webClip.managed</string>
 
 <key>PayloadUUID</key>
 <string>UUID</string>
 
 //版本
 <key>PayloadVersion</key>
 <real>1</real>
 
 //预组装?
 <key>Precomposed</key>
 <true/>
 
 //可不填 iOS14.4需要填写 配合bundleId才能无缝过渡,这个URL应该是app的universal link
 我试过填写的 https://www.baidu.com 配合微博的bundleId 结果打开微博然后唤起webView跳转了百度~ ... 匪夷所思...
 <key>URL</key>
 <string>URL</string>
 
 //bundleId 必填 不然无法指定是打开哪个app
 <key>TargetApplicationBundleIdentifier</key>
 <string>%@</string>
  
</dict>

 ### 更新于2021年6月11日 20:45:06
 *******************************************************************************************
 最近恰好学了Vue 写了一个在线工具练手 结合在线工具可以方便调试 (不需要打包app这么麻烦,也不需要去写捷径折腾~)
 https://github.com/WangGuibin/webclicp-vue-app
 苹果捷径iOS14.3以上即可实现换图标的功能 只是第一次启动会弹通知栏~ 就这~
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
                                     URL:(NSString *_Nullable)URL
{
    NSString *iconText = [NSString stringWithFormat:@"<key>Icon</key><data>%@</data>",iconBase64];
    if (!iconBase64.length) {
        iconText = @"";
    }
    
    if (URL.length) {
        URL = [NSString stringWithFormat:@"<key>URL</key>\n<string>%@</string>\n",URL];
    }else{
        URL = @"";
    }
        
    NSMutableString *strM = [NSMutableString string];
    [strM appendFormat:@"<dict>\n"];
    [strM appendFormat:@"<key>FullScreen</key><true/>\n"];
    [strM appendFormat:@"<key>IsRemovable</key>\n"];
    [strM appendFormat:@"<%@/>\n",isRemoveFromDestop?@"true":@"false"];
    [strM appendFormat:@"%@\n",iconText];
    [strM appendFormat:@"<key>Label</key>\n"];
    [strM appendFormat:@"<string>%@</string>\n",appName];
    [strM appendFormat:@"<key>PayloadDescription</key>\n"];
    [strM appendFormat:@"<string>配置 Web Clip 设置</string>\n"];
    [strM appendFormat:@"<key>PayloadDisplayName</key>\n"];
    [strM appendFormat:@"<string>Web Clip</string>\n"];
    [strM appendFormat:@"<key>PayloadIdentifier</key>\n"];
    [strM appendFormat:@"<string>com.apple.webClip.managed.%@</string>\n",uuid];
    [strM appendFormat:@"<key>PayloadType</key>\n"];
    [strM appendFormat:@"<string>com.apple.webClip.managed</string>\n"];
    [strM appendFormat:@"<key>PayloadUUID</key>\n"];
    [strM appendFormat:@"<string>%@</string>\n",uuid];
    [strM appendFormat:@"<key>PayloadVersion</key>\n"];
    [strM appendFormat:@"<real>1</real>\n"];
    [strM appendFormat:@"<key>Precomposed</key><true/>\n%@",URL];
    [strM appendFormat:@"<key>TargetApplicationBundleIdentifier</key>\n"];
    [strM appendFormat:@"<string>%@</string>\n",bundleId];
    [strM appendFormat:@"</dict>\n"];
//    NSLog(@"%@",strM);
    return [strM copy];
}


/// 把app的配置组装成一个完整的WebClip描述文件
/// @param configs app的描述文件代码
/// @param appSetName 集合描述文件的名字 可选
/// @param uuid 唯一标识
+ (NSString *)addConfigIntoGroupWithConfigs:(NSString *)configs
                                 appSetName:(NSString *_Nullable)appSetName
                                       uuid:(NSString *)uuid

{
    appSetName = appSetName?:@"WebClip描述文件";
    
    NSMutableString *strM = [NSMutableString string];
    [strM appendFormat:@"<?xml version='1.0' encoding='UTF-8'?><!DOCTYPE plist PUBLIC '-//Apple//DTD PLIST 1.0//EN' 'http://www.apple.com/DTDs/PropertyList-1.0.dtd'><plist version='1.0'><dict><key>PayloadContent</key><array>\n"];
    [strM appendFormat:@"%@\n",configs];
    [strM appendFormat:@"</array><key>PayloadDisplayName</key>\n"];
    [strM appendFormat:@"<string>%@</string>\n",appSetName];
    [strM appendFormat:@"<key>PayloadIdentifier</key>\n"];
    [strM appendFormat:@"<string>CoderWGB.%@</string>\n",uuid];
    [strM appendFormat:@"<key>PayloadRemovalDisallowed</key><false/>\n"];
    [strM appendFormat:@"<key>PayloadType</key><string>Configuration</string>\n"];
    [strM appendFormat:@"<key>PayloadUUID</key>\n"];
    [strM appendFormat:@"<string>%@</string>\n",uuid];
    [strM appendFormat:@"<key>PayloadVersion</key>\n"];
    [strM appendFormat:@"<integer>1</integer>\n"];
    [strM appendFormat:@"</dict>\n"];
    [strM appendFormat:@"</plist>\n"];
    NSLog(@"%@",strM);
    return [strM copy];
}


@end
