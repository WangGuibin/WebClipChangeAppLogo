# WGBToolKit


## 私库管理

0. 本地先关联一个远程源

```bash
pod repo add MyPodSpecs  https://gitee.com/wangguibin/my-pod-specs
```

1. 先执行 `sh addNewVersion` 然后再 `sh podLint.sh`
2. 如果`lint`失败需要修改代码或者`.spec`文件,改完之后重新提交执行 `sh updateLastTag.sh`之后再重lint这个操作流程
3. 如果`lint`成功了,直接`sh podPush.sh`即可

提交并打tag
```bash
sh addNewVersion.sh  1.0.1   

```

lint看看会不会报错

```bash
sh podLint.sh
```

lint失败修改 重新提交反复lint 去除远程tag重新打tag提交

```bash
sh updateLastTag.sh
```

push到私有源

```bash
sh podPush.sh
```


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

WGBToolKit is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
source 'https://gitee.com/wangguibin/my-pod-specs'
pod 'WGBToolKit'

#或者

pod 'WGBToolKit', :git => 'https://gitee.com/wangguibin/wgbtool-kit' 
#或者 局部安装 按需引入
pod 'WGBToolKit/DebugTool' #debug阶段用到的工具
pod 'WGBToolKit/UIKit' #UI组件或者公共方法分类啥的
pod 'WGBToolKit/Foundation' #基础组件一些公共的方法或者模板代码

```
> TIPS: pod指定git仓库分支节点拉取库的方式
> 1. 指定分支：通过在 Git URL 后添加 #:branch 的方式来指定特定的分支。例如：pod 'MyLibrary', :git => 'https://github.com/username/MyLibrary.git#:develop'  或者 pod 'Alamofire', :git => 'https://github.com/Alamofire/Alamofire.git', :branch => 'dev'   将从名为 develop 的分支中获取代码。
> 2. 指定提交节点：通过在 Git URL 后添加 @SHA 的方式来指定特定的提交节点。例如：pod 'MyLibrary', :git => 'https://github.com/username/MyLibrary.git@1234567890abcdef' 将从提交节点为 1234567890abcdef 的代码版本中获取代码。
> 3. 指定tag  pod 'MyLibrary', :git => 'https://github.com/username/MyLibrary.git, :tag => '3.1.1'
> 4. 指定commitId  pod 'Alamofire', :git => 'https://github.com/Alamofire/Alamofire.git', :commit => '0f506b1c45'


## Author

CoderWGB, 864562082@qq.com

## License

WGBToolKit is available under the MIT license. See the LICENSE file for more info.
