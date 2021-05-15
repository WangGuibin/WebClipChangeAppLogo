#  关于WebClip生成桌面Logo配置 



## 1. 准备

-  **iPhone升级至iOS14以上** (`不然可能会出现打开应用中间还是有一段空白页面过渡`)
- 参考博客 https://gjh.me/?p=594#comment-3105 了解webclip的基本信息
- [iOS 14 上替换应用图标](https://scomper.me/ios/2020-10-17) 
- 下载Mac App  `Apple configurator2`

## 2. 描述文件解析(直接上代码了)
具体可查看源码 [ChageLogoMobileconfig.m](./ChangeAppLogo/ChangeAppLogo/FeatureModule/Model/ChageLogoMobileconfig.m)文件

```xml
<?xml version='1.0' encoding='UTF-8'?><!DOCTYPE plist PUBLIC '-//Apple//DTD PLIST 1.0//EN' 'http://www.apple.com/DTDs/PropertyList-1.0.dtd'>
<plist version='1.0'>
	<dict>
        <key>PayloadContent</key>
        <array>
            <dict>
                <key>FullScreen</key>
                <true/>
                <!--    书签能否在桌面被删除?   -->
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
                <!--     跳转的URLScheme (可选)-->
                <key>URL</key>
                <string>appcliplaunch://</string>
                <!--    目标app的bundleID (必填)    -->
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

- 使用`Apple configurator2`配置好描述文件(值得注意的是`TargetApplicationBundleIdentifier`这个字段必须填对应的bundleId不然会停顿空白页再跳转),然后再利用`AirDrop`传送到手机安装  

-  把描述文件托管到文件服务器上或者互联网网盘然后使用手机自带的`Safari`浏览器下载打开安装即可

- <del>`App Store`下载第三方换图标`App`也可快速实现功能~ (良莠不齐,有些是要跳空白页再跳的,有些是跳捷径再跳的,有些是webclip处理好的~ 比如: `趣图标`和`捷径集`以及`捷径盒`里的一些捷径) </del> (iOS14.3 添加捷径打开应用并添加到主屏幕可以选取相册自定义图片 有一点瑕疵就是第一次启动这个捷径时会类似弹一个推送横幅的弹窗 所以如果仅仅只是替换图标系统捷径就可以轻松实现 体验好一些的话就得通过WebClip去实现了) 

## 4. 大致原理

- 获取`bundleID`,已知或者从调用`App Store`搜索`api`获取 ,替换`TargetApplicationBundleIdentifier`字段
- 获取图标图片生成base64编码,替换`Icon`字段
- 生成`UUID`等唯一标识,替换相关`UUID`标识
- 替换应用名字段
- 把各个需要替换的字段更新生成新的描述文件进行安装即可 
- 其实可以一个描述文件包含多个书签或者应用,因为内部`PayloadContent`那一层是一个`array`,我发现`捷径集`好像就是这样实现的
- 至于签不签名好像并不影响使用

#### 想方设法获取应用的BundleId
[我写了一个捷径去获取应用的BundleId](https://www.icloud.com/shortcuts/6712dc78b5e04af28473a3bf9a80893c)
已获取了一些应用的bundleId 可供参考: 
```bash
微信 com.tencent.xin
微博 com.sina.weibo
微博国际版 com.weibo.international
手机淘宝 com.taobao.taobao4iphone
美团 com.meituan.imeituan
拼多多 com.xunmeng.pinduoduo
时光相册 com.ss.iphone.everphoto
知乎 com.zhihu.ios
豆瓣 com.douban.frodo
王者荣耀 com.tencent.smoba
和平精英 com.tencent.tmgp.pubgmhd
捷径盒 com.jiejinghe.luke
腾讯视频 com.tencent.live4iphone
爱奇艺 com.qiyi.iphone
优酷 com.youku.YouKu
大众点评 com.dianping.dpscope
飞书 com.bytedance.ee.lark
360手机卫士-电话短信骚扰拦截助手 net.qihoo.360mobilesafe
WPS Office com.kingsoft.www.office.wpsoffice
抖音 com.ss.iphone.ugc.Aweme
快手 com.jiangjia.gif
剪映 - 轻而易剪 com.lemon.lv
腾讯文档 com.tencent.txdocs
腾讯相册管家-换机手机照片同步，智能分类整理 com.tencent.photogallery
闲鱼 - 闲置二手游起来 com.taobao.fleamarket
转转 - 有质检的二手交易平台 com.wuba.zhuanzhuan
找靓机-二手手机交易平台 zhaoliangji
爱回收-闲置二手手机回收平台 com.aihuishou.AiHuiShouApp
小红书 – 标记我的生活 com.xingin.discover
京东-只为热爱行动 com.360buy.jdmobile
唯品会 - 品牌特卖 com.vipshop.iphone
手机天猫-理想生活上天猫 com.taobao.tmall
链家-二手房新房租房交易平台 com.exmart.HomeLink
酷狗音乐-就是歌多 com.kugou.kugou1002
网易云音乐-音乐的力量 com.netease.cloudmusic
QQ音乐 - 让生活充满音乐 com.tencent.QQMusic
全民K歌-你其实很会唱歌 com.tencent.QQKSong
微信读书 com.tencent.weread
百度 com.baidu.BaiduMobile
掌阅 - 引领品质阅读 com.zhangyue.zyiReader.iReader
东方财富-股票交易 基金理财 com.eastmoney.iphone
QQ com.tencent.mqq
搜狗输入法-语音变声斗图表情 com.sogou.sogouinput
简书-创作你的创作 com.jianshu.Hugo
```

## 5. 尝试一下这个微信替身(用手机`Safari`打开)  [点击安装](https://cdn.jsdelivr.net/gh/WangGuibin/MyFilesRepo/images/1621059762.mobileconfig)

iOS代码实现可以如下这样打开Safari加载远程配置文件即可:
```swift
        let downStr = "https://cdn.jsdelivr.net/gh/WangGuibin/MyFilesRepo/images/1621059762.mobileconfig"
        let realURL = URL(string: downStr)
        UIApplication.shared.openURL(realURL!)

```
根据以上我自己写了一个简易版的换图标捷径https://www.icloud.com/shortcuts/685dcb208eca411bafd6f911d3832e5b
和 iOS App demo 暂且称之为 [图标易容术](https://github.com/WangGuibin/WebClipChangeAppLogo)