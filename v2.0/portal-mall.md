# PhalApi应用市场

PhalApi应用市场是基于PhalApi生态开发的应用市场。

## 挑选应用

进入你的运营平台，进入应用市场，挑选应用。

![](http://cdn7.okayapi.com/yesyesapi_20200312123139_653dc13fa6c6809ccbb80551d756f671.png)

## 下载/购买应用

## 应用安装

进入你的运营平台，进入应用市场-我的应用-安装。，
![](http://cdn7.okayapi.com/yesyesapi_20200312122828_01b3e0ed1ee29e80c95a7b635a9c18e7.png)

安装完成后，会提示安装的信息：
![](http://cdn7.okayapi.com/yesyesapi_20200312122828_01b3e0ed1ee29e80c95a7b635a9c18e7.png)

> 如果安装失败，请检测是否有文件和目录的写入权限。此时，可以改用脚本命令安装插件。

你也可以通过脚本命令来安装插件。 

```
[phalapi]$ php ./bin/phalapi-plugin-install.php demo
正在安装 demo
开始检测插件安装包 demo
检测插件是否已安装
插件已安装：plugins/demo.json
开始安装插件……
检测插件安装情况……
插件已安装：plugins/demo.json
插件：demo（demo插件），开发者：作者名称，版本号：1.0，安装完成！
开始检测环境依赖、composer依赖和PHP扩展依赖
PHP版本需要：5.6，当前为：7.1.33
MySQL版本需要：5.3
PhalApi版本需要：2.11.0，当前为：2.11.0
开始数据库变更……
插件安装完毕！
```

## 使用应用

根据不同的应用提供的功能，你就可以在你的运营平台和接口上使用应用所提供的功能和接口了。


