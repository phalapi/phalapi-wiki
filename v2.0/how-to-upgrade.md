
# 如何升级PhalApi？


PhalApi开源生态，主要分为四部分。  

 + 第一部分：**phalapi/phalapi**项目
 + 第二部分：**phalapi/kernal**内核
 + 第三部分：**plugins**第三方应用插件
 + 第四部分：**library**扩展类库

PhalApi开源生态的整体系统架构如下：  

![](http://cd8.yesapi.net/yesyesapi_20200403234846_efba32461a62f4f3d93afc3a1bb341f2.png)

一言以蔽之，kernal是内核、library是对内的技术扩展，plugins是对外的业务扩展，phalapi则是大母体，从而构成完整的项目。  

## 第一部分：**phalapi/phalapi**项目
第一部分：**phalapi/phalapi**，即PhalApi项目，由PhalApi官方维护，欢迎大家参与开源维护，整合了kernal、运营平台等，是一个完整的项目，需要通过到Github/码云等重新下载。包含了：在线接口文档、配置、数据库、翻译包、vendor等，下载后即可使用。  

> PhalApi项目地址：[https://github.com/phalapi/phalapi/](https://github.com/phalapi/phalapi/)，码云：[https://gitee.com/dogstar/PhalApi](https://gitee.com/dogstar/PhalApi)  

## 第二部分：**phalapi/kernal**内核
**phalapi/kernal**，作为PhalApi框架核心部分，由PhalApi官方维护，欢迎大家参与开源维护，对应```PhalApi```的PHP命名空间，即全部以```PhalApi\```命名空间开头的PHP类代码，放置在vendor目录下。  

升级方式：通过composer方式进行更新，PhalApi会保证向前兼容，升级不影响原来的使用。如有特殊情况会特别注明。  

通过compoer命令可升级到最新的PhalApi内核版本。  
```
$ composer update phalapi/kernal
```

此外，PhalApi还有一个核心的包是[phalapi/notorm](https://github.com/phalapi/notorm)，专门用于操作数据库，基于NotORM。phalapi/notorm会由kernal同步进行升级，不需要单独升级此部分。   


> phalapi/kernal项目地址：[https://github.com/phalapi/kernal](https://github.com/phalapi/kernal)

除此之外，PhalApi生态还有丰富的插件应用和扩展类库。主要区别是：插件应用是果创应用市场维护和审核，是商业化的应用市场平台，由PhalApi作者负责运营；扩展类库是开源社区共同维护，完全免费的。  

## 第三部分：**plugins**第三方/内部应用插件
**plugins**第三方应用插件，内置插件包括：PhalApi运营平台、User用户插件等，也有由第三方开发者提供的插件和应用（分为免费和付费两大类），发布后会由应用市场进行审核。安装后可单独进行插件的升级。注意，如果你已经改动到插件的代码，升级前请做好代码备份。这部分的代码包含插件的目录和代码，即包括但不限于：src、public、plugins、data、config等。  

就性质而方，应用插件是面向业务型的，提供相对独立或者完整的功能，可以提供给非技术的人员直接使用，完成某个行业内的需求，例如商城微信小程序、投票活动等。让非技术的人员也可以在安装后即可使用。  

插件安装包位置./plugins/```插件编号```.zip，通过命令行或运营平台界面可进行插件的升级、安装、卸载等。  

对于Portal插件，可以在运营平台里面进行查看和更新：  
![](http://cd8.yesapi.net/yesyesapi_20200401113206_dd211561c085fef8fe71e5793b2b4cf9.png)  
适合已经安装了PhalApi和运营平台的项目。  


## 第四部分：**library**扩展类库

**library**扩展类库是针对特定功能的类库，统一采用composer方式管理，发布在[Packagist](https://packagist.org/?query=phalapi)，由开源社区共同维护，每个人都可以参与开发和贡献。代码位置放在vendor目录下，可根据需要进行单独安装，升级方式也是使用composer方式升级。  

就性质而言，扩展类库更多是面向技术性的工具包，纯技术类的，与业务无关，例如：短信发送、邮件发送、文件上传等。安装后，技术人员仍然需要开发才能用于自己的项目场景。  

你也可以引入使用其他composer包。  

![](http://cd8.yesapi.net/yesyesapi_20200403233029_e444c13793e6cc01b85407b09e843855.png)  

> PhalApi 2.x 框架扩展类库：http://docs.phalapi.net/#/v2.0/library  

> Packagist：PhalApi 2.x 已发布全部composer包：https://packagist.org/?query=phalapi  

> 引导：[如何开发扩展类库？](http://docs.phalapi.net/#/v2.0/library?id=%e5%a6%82%e4%bd%95%e5%bc%80%e5%8f%91%e6%89%a9%e5%b1%95%e7%b1%bb%e5%ba%93%ef%bc%9f)


