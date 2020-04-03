# 运营平台

PhalApi的Portal运营平台，是提供给运营团队使用的管理后台。从PhalApi 2.12.0 及以上版本提供，可以非常方便进行数据和业务上的管理。  

## 介绍

运营平台有以下几个特点：  
 + 免费使用，可放心用于商业项目开发
 + 基于[layuimini](http://layuimini.99php.cn/)LAYUI MINI 后台管理模板和[layui](https://www.layui.com/)经典模块化前端框架开发运营平台界面，让后端开发也能轻松入手
 + 提供与后面界面配套的后台数据接口，基本不用写代码，就能实现后台数据的增删改查操作
 + 可视化运营平台安装，安装后即可使用
 + 丰富的应用超市和插件即将来临，敬请期待！  

## 首次安装运营平台

参考文档[下载与安装](http://docs.phalapi.net/#/v2.0/download-and-setup)，下载安装好PhalApi 2.2.0 及以上版本后，并且配置好数据库连接。然后访问运营平台：  
```
http://dev.phalapi.net/portal/
```

你也可以通过在线接口文档的右上角的顶部菜单【登录】进入。

![](http://cdn7.okayapi.com/yesyesapi_20200313114729_3e45027da1e6c215d1852c1aa48fb823.png)

> 温馨提示：把dev.phalapi.net换成你的域名；配置时需要把网站的根路径设置到public目录。  

如果第一次使用，会提示未安装，并自动跳转到安装页面。

![](http://cdn7.okayapi.com/yesyesapi_20200309172737_a4b73f5763b4d8758f367a2a34230830.png)

输入你需要初始化的管理员账号和自己的密码，然后点击【立即安装】。  

安装成功后，将会跳转到登录页面。

![](http://cdn7.okayapi.com/yesyesapi_20200309174512_4362a4853b3dcb860538aada234bb476.png)

登录成功后，进入运营平台首页。

## 如何手动安装运营平台？

修改./config/dbs.php数据库配置，然后将./data/phalapi.sql文件导入到你的数据库即可。  

## 升级运营平台

PhalApi的升级，主要分为三部分。  

 + 第一部分：**phalapi/kernal**，框架核心部分，通过composer方式可以更新
 + 第二部分：**phalapi/phalapi**，PhalApi项目，整合了kernal、运营平台等，是一个完整的项目，需要通过到Github/码云等重新下载
 + 第三部分：**Portal插件**，PhalApi运营平台，安装后可单独升级Portal运营平台部分。  

对于Portal插件，可以在运营平台里面进行查看和更新：  
![](http://cdn7.okayapi.com/yesyesapi_20200401113206_dd211561c085fef8fe71e5793b2b4cf9.png)  
适合已经安装了PhalApi和运营平台的项目。  

也可以直接到应用市场下载：
![](http://cdn7.okayapi.com/yesyesapi_20200401113312_9306821e3109ad35e36f6c7e0b247855.png)
下载后，和插件的安装升级方式一样。  
> Portal插件链接：[http://www.yesdev.cn/phalapi-portal](http://www.yesdev.cn/phalapi-portal)  


## 使用运营平台

默认情况下，有三大版块：运营平台、页面示例和应用市场。

### 运营平台
可以根据项目业务的需求，添加需要的新菜单和功能界面。

首页，功能未实现，只是一个静态效果。
![](http://cdn7.okayapi.com/yesyesapi_20200309181436_29b086516a5ec57056fa575f5b7424c8.jpg)

菜单管理，可以实现菜单的查看，编辑和删除。

![](http://cdn7.okayapi.com/yesyesapi_20200309181753_86f46d36d2ea0df837945f6864d460e8.png)

CURD表格示例，在项目开发过程中，新业务的数据管理可以参考此示例。基本上把后台模板复制后简单修改下即可得到新的功能模块，后台接口只需要极少量的改动。下面会单独进行详细讲解。

可以实现表格数据的列表查询和搜索、增加、修改、删除和批量删除等操作。

![](http://cdn7.okayapi.com/yesyesapi_20200309182259_f7937a2780d1a53b0b0bb2208d4ca78e.jpg)

### 页面示例
页面示例，为方便大家开发运营平台的新界面和新功能，这里保留了layuimini原来的部分页面示例。开发时，可以参考或复制过来修改调整。

![](http://cdn7.okayapi.com/yesyesapi_20200309182633_100d5082e5bb4310273cc5c5c29d93ea.png)

### 应用市场

PhalApi将结合广大开发者提供优质的应用、插件和接口源码，通过应用市场提供给大家使用。目前正在开发中，敬请期待！
