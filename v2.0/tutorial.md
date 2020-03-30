# Abstract

![](https://camo.githubusercontent.com/41579d7d1278396ffdae4e1e37cba7aea8422c4a/687474703a2f2f776562746f6f6c732e71696e6975646e2e636f6d2f6d61737465722d4c4f474f2d32303135303431305f35302e6a7067)

PhalApi is a lightweight PHP open source API framework, **Help you to create value**！
We are constantly updating and keeping forward; responsible for the API development and responsible for the open source community! 
We promise we will be free forever!

PhalApi Official Website：[www.phalapi.net](https://www.phalapi.net/).

## Latest Docs

 + [Official Online Version - Recommend](http://docs.phalapi.net/#/v2.0/tutorial)
 + [PDF Offline Version](http://docs.phalapi.net/html/PhalApi-2x-release.pdf)
 + [HTMl Offline Version](http://docs.phalapi.net/html/PhalApi-2x-release.html)
 + [Markdown Opensource Version](https://gitee.com/dogstar/phalapi-wiki)

## What is PhalApi 2.x？

PhalApi, referred to as π Framework, is a lightweight PHP open source API framework, focusing on API development and striving to make API development easier:

 + Committing to fast, stable and continuous delivery of valuable API services.
 + Focusing on test-driven development, domain-driven design, extreme programming, agile development.
 + Supporting many extended class libraries to provide efficient and convenient solutions together with more open source projects.
 + Supporting protocols including HTTP / SOAP / RPC / etc.
 + Easy to build interfaces / microservices / RESTful API / Web Services.


PhalApi currently has two major series versions. The 1.x series version, which mainly uses a more ancient and traditional approach; The main differences are:


 + Use [composer](https://getcomposer.org/) to manage all the dependencies.
 + Introduce Namespace concept.
 + Obey [PSR-4](http://www.php-fig.org/) Regulation.

> Reminder: In this development document, unless otherwise specified, PhalApi means both PhalApi 1.x version and PhalApi 2.x version.

## Features

PhalApi is a super cool open source framework. The more you know about it, the more you can discover its coolness. Here are some key features.

### Feature 1: Low learning cost

PhalApi always adheres to the KISS principle, and follows the principle of least innovation in the Unix philosophy. In addition to following international conventions and adopting a common practice, PhalApi also gives priority to the schemes that everyone is familiar with when designing. For example, the format of the API return result is everyone-known JSON format. For junior developers who are new to the PHP programming language, or even client developers who have not previously encountered PHP, according to previous learning experience, in most cases, you can complete the basic learning of the PhalApi framework within one week. And put into the actual project development.

### Feature 2: Automatically generated online API documentation

After coding in the format specified by the framework, PhalApi will automatically generate the Online API List Document and Online API Detail Document to facilitate the client to view the latest interface signature and return fields in real time.

There are two main types of automatically generated online documents:  

 + Online API List Document  
 ![](http://cdn7.phalapi.net/20170701174008_d80a8df4f918dc063163a9d730ceaf32)

 + Online API Detail Document
 ![](http://cdn7.phalapi.net/20170701174325_f69dd605f2b1dd177089323f1f5a798e)

### Feature 3: Numerous reusable extension libraries  

PhalApi框架扩展类库, 是各自独立, 可重用的组件或类库, 可以直接集成到PhalApi开发项目, 从而让项目开发人员感受搭建积木般的编程乐趣, 降低开发成本.  

目前, 已经提供的扩展类库有40+个, 包括:微信公众号开发扩展、微信小程序开发扩展、支付扩展、上传扩展、Excel表格和Word文档扩展等.  

> 温馨提示：部分扩展类库需要调整移植到PhalApi 2.x风格方能使用.

### Feature 4: Active open source community

PhalApi不是“我们”的框架, 而是我们大家每个人的开源框架.PhalApi开源社区非常活跃, 除了有1000+人的实时交流群, 还有自主搭建的[问答社区](http://qa.phalapi.net/), 以及近百名参与贡献的同学.  

PhalApi 2.x的学习资料目前还在陆续补充中, 但依然可以参考PhalApi 1.x 版本系列丰富的学习资料, 有：[开发文档](https://www.phalapi.net/wikis/)、[视频教程](https://www.phalapi.net/wikis/8-1.html)、[《初识PhalApi》免费电子书](http://www.ituring.com.cn/book/2405)、[博客教程](https://my.oschina.net/wenzhenxi/blog?catalog=3363506)等.  

## Applicable scene and environment

PhalApi代码开源、产品开源、思想开源, 请放心使用.  

PhalApi适用的场景, 包括但不限于：  

 + 为移动App（包括iOS、iPad、Android、Windowns Phone等终端）提供接口服务  
 + 用于搭建接口平台系统, 提供聚合类接口服务, 供其他后端系统接入使用  
 + 为前后端分离的H5混合页面应用, 提供Ajax异步接口

对于架构无关、专注架构及提升架构这三种情况, PhalApi都能胜任之.  

正如其他负责任的开源框架一样, PhlaApi也有其不适宜使用的时机.包括但不限于：  

 + 开发CLI项目（但已提供支持命令行项目开发的[CLI扩展类库](http://git.oschina.net/dogstar/PhalApi-Library/tree/master/CLI)）
 + 开发网站项目, 即有界面展示和视图渲染（但已提供支持视图渲染的[View扩展类库](http://git.oschina.net/dogstar/PhalApi-Library/tree/master/View)）
 + 对数据严谨性要求高, 如金融行业的相关项目, 毕竟PHP是弱类型语言

## Intended audience of this document  

 + Developers who are new to PhalApi framework
 + Developers who are doing projects under PhalApi framework
 + Anyone who wants to learn a useful and easy API framework
 + Managers who are looking for an excelent API framework for their project.

## Contact Us 

#### Any problom related to this document, give us a feedback here: (https://github.com/phalapi/phalapi/issues), Thanks!
