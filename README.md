# WebClipChangeAppLogo
iOS14利用WebClip更换图标,做到无缝启动App 

<p>
    <img alt="GitHub Repo stars" src="https://img.shields.io/github/stars/wangguibin/WebClipChangeAppLogo?color=green&label=stars%20%E2%98%86&logo=star&logoColor=white&style=for-the-badge">
    <img alt="GitHub forks" src="https://img.shields.io/github/forks/wangguibin/WebClipChangeAppLogo?style=social">
    <img alt="GitHub last commit (branch)" src="https://img.shields.io/github/last-commit/wangguibin/WebClipChangeAppLogo/main">
    <img alt="GitHub search hit counter" src="https://img.shields.io/github/search/wangguibin/WebClipChangeAppLogo/webclip?color=red&style=flat-square">

</p>

[![Sparkline](https://stars.medv.io/Wangguibin/WebClipChangeAppLogo.svg)](https://stars.medv.io/Wangguibin/WebClipChangeAppLogo)

## Stargazers over time

[![Stargazers over time](https://starchart.cc/Wangguibin/WebClipChangeAppLogo.svg)](https://starchart.cc/Wangguibin/WebClipChangeAppLogo)





<img src="./1.png" alt="简陋的UI凑合一下" style="zoom:50%;" />

## 1. 准备 

-  **iPhone升级至iOS14以上** (`不然可能会出现打开应用中间还是有一段空白页面过渡`)
- 参考博客 https://gjh.me/?p=594#comment-3105 了解webclip的基本信息
- [iOS 14 上替换应用图标](https://scomper.me/ios/2020-10-17) 
- 下载Mac App  `Apple configurator2`

## 2. 描述文件解析(直接上代码了)

```xml
<?xml version='1.0' encoding='UTF-8'?><!DOCTYPE plist PUBLIC '-//Apple//DTD PLIST 1.0//EN' 'http://www.apple.com/DTDs/PropertyList-1.0.dtd'>
<plist version='1.0'>
	<dict>
        <key>PayloadContent</key>
        <array>
            <dict>
                <key>FullScreen</key>
                <true/>
                <!--    书签能否被删除?   -->
                <key>IsRemovable</key>
                <false/>
                <!--    图标的base64编码 -->
                <key>Icon</key>
                <data>base64编码(实际是需要填这个字段的 太长了这里就略了)</data>
                <!--      描述文件的标签 这个是桌面上的名字     -->
                <key>Label</key>
                <string>应用名</string>
                <!--       描述文件的简介         -->
                <key>PayloadDescription</key>
                <string>这个是webClip 用于替换应用启动更换图标之类的或者网页书签的一个桌面快捷打开的方式</string>
                <!--   描述文件内层导航栏显示的名字   -->
                <key>PayloadDisplayName</key>
                <string>WebClip内部名字</string>
                <!--      唯一标识         -->
                <key>PayloadIdentifier</key>
                <string>com.example.appclip.apple.webClip.managed.xxxooo</string>
                <!--        类型        -->
                <key>PayloadType</key>
                <string>com.apple.webClip.managed</string>
                <!--     UUID保证唯一性即可        -->
                <key>PayloadUUID</key>
                <string>25F701C5-1305-42D4-B6C4-0FB453940C05</string>
                <!--       版本号      -->
                <key>PayloadVersion</key>
                <real>1</real>
                <!--      预组装     -->
                <key>Precomposed</key>
                <true/>
                <!--     跳转的URLScheme -->
                <key>URL</key>
                <string>appcliplaunch://</string>
                <!--    目标app的bundleID    -->
                <key>TargetApplicationBundleIdentifier</key>
                <string>com.sanche.AppClips</string>
            </dict>
        </array>
        <!--     描述文件的名字  -->
        <key>PayloadDisplayName</key>
        <string>WebClip描述文件的名字</string>
        <!--     描述文件的id   -->
        <key>PayloadIdentifier</key>
        <string>com.example.appclip</string>
        <!--    描述文件不允许删除? 貌似无效啊 -->
        <key>PayloadRemovalDisallowed</key>
        <true/>
        <!--      类型  -->
        <key>PayloadType</key>
        <string>Configuration</string>
        <!--      UUID保证唯一性即可    -->
        <key>PayloadUUID</key>
        <string>95EF972A-9463-4037-83B8-7B23602F5C5D</string>
        <!--     版本   -->
        <key>PayloadVersion</key>
        <integer>1</integer>
    </dict>
</plist>

```



##  3. 如何使用

- 使用老外写的一个`iOS`捷径https://routinehub.co/shortcut/6565/   

- 使用`Apple configurator2`配置好描述文件,然后再利用`AirDrop`传送到手机安装  

-  把描述文件托管到文件服务器上或者互联网网盘然后使用手机自带的`Safari`浏览器下载打开安装即可

- `App Store`下载第三方换图标`App`也可快速实现功能~ (良莠不齐,有些是要跳空白页再跳的,有些是跳捷径再跳的,有些是webclip处理好的~ 比如: `趣图标`和`捷径集`以及`捷径盒`里的一些捷径) 

## 4. 大致原理

- 获取`bundleID`,已知或者从调用`App Store`搜索`api`获取 ,替换`TargetApplicationBundleIdentifier`字段
- 获取图标图片生成base64编码,替换`Icon`字段
- 生成`UUID`等唯一标识,替换相关`UUID`标识
- 替换应用名字段
- 把各个需要替换的字段更新生成新的描述文件进行安装即可 
- 其实可以一个描述文件包含多个书签或者应用,因为内部`PayloadContent`那一层是一个`array`,我发现`捷径集`好像就是这样实现的
- 至于签不签名好像并不影响使用

## 5. 尝试一下这个微信替身(用手机`Safari`打开)  [点击安装](https://cdn.jsdelivr.net/gh/WangGuibin/MyFilesRepo/files/weixin.mobileconfig)

iOS代码实现可以如下这样打开Safari加载远程配置文件即可:
```swift

        let downStr = "https://cdn.jsdelivr.net/gh/WangGuibin/MyFilesRepo/files/weixin.mobileconfig"
        let realURL = URL(string: downStr)
        UIApplication.shared.openURL(realURL!)

```
根据以上我自己写了一个简易版的换图标捷径https://www.icloud.com/shortcuts/685dcb208eca411bafd6f911d3832e5b
和 iOS App demo 暂且称之为 [图标易容术](https://github.com/WangGuibin/WebClipChangeAppLogo)