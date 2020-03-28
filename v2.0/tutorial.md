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

 + 致力于快速、稳定、持续交付有价值的接口服务
 + 关注于测试驱动开发、领域驱动设计、极限编程、敏捷开发
 + 有众多的扩展类库, 与更多开源项目一起提供高效便捷的解决方案
 + 支持HTTP、SOAP和RPC协议, 可用于快速搭建微服务、RESTful接口或Web Services

PhalApi现存有两大系列版本.分别是经典的第一代版本, 即1.x系列版本, 主要是使用了较为古老传统的做法；以及全新的第二代版本, 即2.x系列版本, 主要区别是：  

 + Use [composer](https://getcomposer.org/) to manage all the dependencies.
 + Introduce Namespace concept.
 + Obey [PSR-4](http://www.php-fig.org/) Regulation.

> 温馨提示：在本开发文档中, 若未特别标明, PhalApi指PhalApi 1.x 版本和PhalApi 2.x 版本.

## Features

PhalApi is a super cool open source framework. The more you know about it, the more you can discover its coolness. Here are some key features.

### Feature 1: Low learning cost

PhalApi始终坚持KISS原则, 并遵循Unix哲学中的最小立异原则.除了遵循国际惯例, 采用约定俗成的做法, PhalApi还在设计时优先考虑大家所熟悉的方案.例如, 接口返回结果格式便是路人皆知的JSON格式.对于刚接触PHP编程语言的初级开发同学, 甚至是之前未曾接触过PHP的客户端开发同学, 根据以往的学习经验, 大部分情况下, 可以在一周内完成PhalApi框架的基础学习, 并投入到实际项目开发中.  

### Feature 2：自动生成的在线接口文档  

按框架指定的格式完成接口代码编写后, PhalApi会自动生成在线接口列表文档和在线接口详情文档, 以方便客户端实时查看最新的接口签名和返回字段.  

自动生成的在线文档主要有两类：  

 + 在线接口列表文档  
 ![](http://cdn7.phalapi.net/20170701174008_d80a8df4f918dc063163a9d730ceaf32)

 + 在线接口详情文档  
 ![](http://cdn7.phalapi.net/20170701174325_f69dd605f2b1dd177089323f1f5a798e)

### Feature 3：众多可重用的扩展类库  

PhalApi框架扩展类库, 是各自独立, 可重用的组件或类库, 可以直接集成到PhalApi开发项目, 从而让项目开发人员感受搭建积木般的编程乐趣, 降低开发成本.  

目前, 已经提供的扩展类库有40+个, 包括:微信公众号开发扩展、微信小程序开发扩展、支付扩展、上传扩展、Excel表格和Word文档扩展等.  

> 温馨提示：部分扩展类库需要调整移植到PhalApi 2.x风格方能使用.

### Feature 4：活跃的开源社区  

PhalApi不是“我们”的框架, 而是我们大家每个人的开源框架.PhalApi开源社区非常活跃, 除了有1000+人的实时交流群, 还有自主搭建的[问答社区](http://qa.phalapi.net/), 以及近百名参与贡献的同学.  

PhalApi 2.x的学习资料目前还在陆续补充中, 但依然可以参考PhalApi 1.x 版本系列丰富的学习资料, 有：[开发文档](https://www.phalapi.net/wikis/)、[视频教程](https://www.phalapi.net/wikis/8-1.html)、[《初识PhalApi》免费电子书](http://www.ituring.com.cn/book/2405)、[博客教程](https://my.oschina.net/wenzhenxi/blog?catalog=3363506)等.  

## 适用场景与范围  

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
