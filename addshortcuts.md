# RT: 如何为自己的App增加捷径自定义拓展

> 这不是一句两句话能描述清楚的,所以直接进入一图胜千言模式 。

<img src="https://cdn.jsdelivr.net/gh/WangGuibin/MyFilesRepo/images/1.png" style="zoom:50%;" />

 首先添加`Target` 找到`Intent Extension` 添加就完事儿了

<img src="https://cdn.jsdelivr.net/gh/WangGuibin/MyFilesRepo/images/2.png" style="zoom:50%;" />

下一步下一步,弹窗的话就点`Activited`,接下来再创建`SiriKit Intent Defintion File`

![](https://cdn.jsdelivr.net/gh/WangGuibin/MyFilesRepo/images/3.png)

起名字没啥讲究,一般一个项目就一个这玩意儿,默认的就完事儿了 

![](https://cdn.jsdelivr.net/gh/WangGuibin/MyFilesRepo/images/4.png)

这里开始就有些操作了,添加一个`intent`项目 ,填写如图的一些表单信息,勾选重要的几项,添加自定义参数等

![](https://cdn.jsdelivr.net/gh/WangGuibin/MyFilesRepo/images/5.png)

如果需要回调处理,响应结果这里也需要填写,创建返回结果的字段/类型,生成模板文件的时候会生成对应的返回方法

![](https://cdn.jsdelivr.net/gh/WangGuibin/MyFilesRepo/images/6.png)

编译后查看如图位置,点击箭头进去,即可查看生成的模板文件,只有头文件查看API接口(苹果一贯的闭源作风)

![](https://cdn.jsdelivr.net/gh/WangGuibin/MyFilesRepo/images/7.png)

看看👀 就这就这: 

![](https://cdn.jsdelivr.net/gh/WangGuibin/MyFilesRepo/images/8.png)

然后就去找到一开始创建`Target`自动生成的文件`IntentHandler.m`去实现对应的`intent`处理

![](https://cdn.jsdelivr.net/gh/WangGuibin/MyFilesRepo/images/9.png)

每个intent的处理,风格有点相似,只是类型不同而已,大概这就是模板文件的魅力吧

![](https://cdn.jsdelivr.net/gh/WangGuibin/MyFilesRepo/images/10.png)

到这一步处理完,就完事了,然后就是运行主App,验证结果了(最好是卸载重新安装)

运行App之后,打开捷径App,新建一个快捷指令,如图: 

![](https://cdn.jsdelivr.net/gh/WangGuibin/MyFilesRepo/images/Xnip2020-11-28_11-12-49.png)

然后找到自己开发的App

![](https://cdn.jsdelivr.net/gh/WangGuibin/MyFilesRepo/images/Xnip2020-11-28_11-13-24.png)

那就拿这个`图标易容术`[^1]来举个例子吧 

![](https://cdn.jsdelivr.net/gh/WangGuibin/MyFilesRepo/images/Xnip2020-11-28_11-13-41.png)

写的一个沙盒存储,基于`NSUserDefaults`[^2]实现的,如果想要卸载App也能不丢失数据,那实现方案只能更换钥匙串或者iCloud等,但是这个操作是基于这个应用的,我也不希望我开发的App被人卸载,虽说有点流氓操作,但是不想用就别用的原则就是这么简单粗暴~ 

![](https://cdn.jsdelivr.net/gh/WangGuibin/MyFilesRepo/images/Xnip2020-11-28_11-13-50.png)

这个描述就是一开始创建`Intent`时表单里的`description`字段,提前编辑好再copy过去,排版会好看些.



存储功能展示

<img src="https://cdn.jsdelivr.net/gh/WangGuibin/MyFilesRepo/images/Xnip2020-11-28_11-15-00.png" style="zoom:67%;" />

查数据

<img src="https://cdn.jsdelivr.net/gh/WangGuibin/MyFilesRepo/images/Xnip2020-11-28_11-15-33.png" style="zoom:67%;" />



开发这些操作其实很简单,都有现成的轮子直接套用转换就是,最为困难的地方是限制于想法,如果没有一个好的想法或者实现方式还不如不去做它.

结合之前玩捷径的一些经验,开发了以下工具,比起之前可以更方便更便捷~ 

<img src="https://cdn.jsdelivr.net/gh/WangGuibin/MyFilesRepo/images/IMG_3112.PNG" style="zoom:50%;" />

<img src="https://cdn.jsdelivr.net/gh/WangGuibin/MyFilesRepo/images/IMG_3109.PNG" style="zoom:50%;" />

<img src="https://cdn.jsdelivr.net/gh/WangGuibin/MyFilesRepo/images/IMG_3110.PNG" style="zoom:50%;" />

<img src="https://cdn.jsdelivr.net/gh/WangGuibin/MyFilesRepo/images/IMG_3113.PNG" style="zoom:50%;" />



<img src="https://cdn.jsdelivr.net/gh/WangGuibin/MyFilesRepo/images/IMG_3111.PNG" style="zoom:50%;" />







整体开发下来好像没有什么很困难的东西,只不过国内目前还很少对应的中文资料,只能硬着头皮找英文资料取经~ 

参考资料: 

- Alex Hay https://github.com/mralexhay/ShortcutsExample
- `Toolbox pro`的作者的博客 [Adding Shortcuts To An App](https://toolboxpro.app/blog)



[^1]: 这是我的一个开源项目,是基于iOS14利用WebClip技术通过生成mobileConfig描述文件来替换应用图标的一种实现方案,项目地址[WebClipChangeAppLogo](https://github.com/WangGuibin/WebClipChangeAppLogo)
[^2]: apple官方文档 [NSUserDefaults](https://developer.apple.com/documentation/foundation/nsuserdefaults)

