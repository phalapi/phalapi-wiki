# 目录

前言
  - [前言](http://docs.phalapi.net/#/v2.0/tutorial.md) 带你快速了解什么是PhalApi开源接口框架！  
  - [如何升级PhalApi？](http://docs.phalapi.net/#/v2.0/how-to-upgrade.md) 框架有新版本时，我要怎么更新？  

一、快速开发
  - [1.1下载与安装](http://docs.phalapi.net/#/v2.0/download-and-setup.md) 第一次使用，在本地下载、安装和运行PhalApi。  
  - [1.2 运行Hello World](http://docs.phalapi.net/#/v2.0/hello-world.md) 编写你的第一个接口，真的非常简单。  
  - [1.3 如何请求接口服务](http://docs.phalapi.net/#/v2.0/how-to-request.md) 接口写好后，客户端如何请求的使用接口？  
  - [1.4 接口响应、在线调试和性能](http://docs.phalapi.net/#/v2.0/response-and-debug.md) 在线调试和开发你的API接口。  
  - [1.5 Api接口层](http://docs.phalapi.net/#/v2.0/api.md) 由接口服务层，负责对客户端的请求进行响应，处理接收客户端传递的参数，最后返回结果。  
  - [1.6 DataApi通用数据接口](http://docs.phalapi.net/#/v2.0/data-api.md) 从PhalApi 2.13.0 版本新推出的通用数据接口。  
  - [1.7 Domain领域层与ADM模式](http://docs.phalapi.net/#/v2.0/domain.md) PhalApi使用的是ADM分层模式，Domain是连接Api层与Model层的桥梁。
  - [1.8 Model数据层与数据库操作](http://docs.phalapi.net/#/v2.0/model.md) Model层称为数据模型层，是广义上的数据层，不仅仅只是针对数据库操作。
  - [1.9 DataModel数据基类](http://docs.phalapi.net/#/v2.0/database-datamodel.md) 为减少数据库操作的代码开发量，新推出的数据库数据基类。 
  - [1.10 单元测试](http://docs.phalapi.net/#/v2.0/unit-test.md) 推荐使用TDD测试驱动开发最佳实践，并主要使用的是PHPUnit进行单元测试。 
  - [1.11 自动加载、PSR-4和编程规范](http://docs.phalapi.net/#/v2.0/autoload.md) 如果你已经熟悉此约定成俗的命名规范，可跳过这一节。 
  - [1.12 接口文档](http://docs.phalapi.net/#/v2.0/api-docs.md) 接口文档将会自动实时生成，分为两大类：在线接口列表文档和在线接口详情文档。  
  - [1.13 初始化](http://docs.phalapi.net/#/v2.0/init.md) 框架的应用的初始化，都在这里。  

二、数据库
  - [2.1 数据库连接](http://docs.phalapi.net/#/v2.0/database-connect.md) 支持MySQL、MS SQL Server、PostgreSQL等常用数据库的配置和连接。  
  - [2.2 数据库与NotORM](http://docs.phalapi.net/#/v2.0/database-notorm.md) PhalApi框架主要是使用了NotORM来操作数据库。  
  - [2.3 数据库使用和查询](http://docs.phalapi.net/#/v2.0/database-usage.md) 最常用的数据库操作和使用方式，对应CURD、事务、关联查询等操作。
  - [2.4 数据库分库分表策略](http://docs.phalapi.net/#/v2.0/database-multi.md) 详细介绍数据库分库分表策略和用法，适合海量数据的水平存储。  
  - [2.5 连接多个数据库](http://docs.phalapi.net/#/v2.0/database-other.md) 项目需要连接多个数据库的多种解决方案介绍和对比。  
  - [2.6 打印和保存SQL语句](http://docs.phalapi.net/#/v2.0/database-sql-debug.md) 将介绍SQL语句的在线调试打印和文件纪录。对于平时开发和线上问题排查都非常有帮助，必备的开发技能。  
  - [2.7 定制你的Model基类](http://docs.phalapi.net/#/v2.0/database-model.md) 高级专业深度用法，为你的项目和业务定制和设计通用的数据库基类。  

三、高级专题
  - [3.1 接口参数](http://docs.phalapi.net/#/v2.0/api-params.md) 接口参数是学习和开发接口的必修课，通过参数规则配置快速实现文档展示、校验和提示。  
  - [3.2 配置](http://docs.phalapi.net/#/v2.0/config.md)  PHP配置文件的简单读取，以及```.env```配置文件和读取方式。  
  - [3.3 日志](http://docs.phalapi.net/#/v2.0/logger.md) 简化版的日记接口。  
  - [3.4 缓存](http://docs.phalapi.net/#/v2.0/cache.md) 从简单的缓存、再到高速缓存、最后延伸到多级缓存，逐步进行说明。 
  - [3.5 过滤器(接口签名)](http://docs.phalapi.net/#/v2.0/filter.md) 如何设计和实现你的接口签名方式，和接口服务白名单配置。  
  - [3.6 COOKIE](http://docs.phalapi.net/#/v2.0/cookie.md) COOKIE的基本使用。  
  - [3.7 加密](http://docs.phalapi.net/#/v2.0/crypt.md) mcrypt、RSA和更富弹性的加密方案。  
  - [3.8 国际化](http://docs.phalapi.net/#/v2.0/i18n.md) 使用i18n进行国际化的项目开发和翻译，以及语言设定。  
  - [3.9 CURL请求](http://docs.phalapi.net/#/v2.0/curl.md) 当需要进行curl请求时，可使用PhalApi封装的CURL请求类```PhalApi\CUrl```。  
  - [3.10 工具和杂项](http://docs.phalapi.net/#/v2.0/tool.md) 获取客户端IP地址、生成随机字符串、数组转XML格式等工具函数。  
  - [3.11 DI服务汇总及核心思想](http://docs.phalapi.net/#/v2.0/di.md) DI基本使用和注册，以及DI服务资源一览表，和更高阶的DI核心思想解读及来源的。 
  - [3.12 扩展类库](http://docs.phalapi.net/#/v2.0/library.md) 由开源社区一起维护，致力于与开源项目一起提供企业级的解决方案！  
  - [3.13 SDK包的使用](http://docs.phalapi.net/#/v2.0/sdk.md) 为了统一客户端请求接口，为此使用了内部领域特定语言： 接口查询语言 （Api Structured Query Language） 。  
  - [3.14 脚本命令](http://docs.phalapi.net/#/v2.0/shell.md) 自动化是提升开发效率的一个有效途径，多用脚本，写少代码。  
  - [3.15 MQ队列](http://docs.phalapi.net/#/v2.0/mq-gearman.md) PhalApi可以轻松与各MQ队列进行整合使用。   
  - [3.16 PHP异常和错误处理](http://docs.phalapi.net/#/v2.0/error.md) PhalApi的错误处理。  
  - [3.17 .env环境变量配置](http://docs.phalapi.net/#/v2.0/phpdotenv.md) 为了更方便管理、切换和维护不同运行环境的环境配置，可以使用专门的```.env```文件。  

四、拓展阅读 
  - [4.1 记录API请求日志](http://docs.phalapi.net/#/v2.0/components/more/how-to-record-api-log.md)
  - [4.2 拦截多个接口请求并返回自定义内容](http://docs.phalapi.net/#/v2.0/components/more/how-to-volley-api-request.md)
  - [4.3 另一种方法获取接口参数](http://docs.phalapi.net/#/v2.0/components/more/how-to-get-api-params.md)
  - [4.4 如何将ip地址转换成ip归属地](http://docs.phalapi.net/#/v2.0/components/more/how-to-use-ip2address.md)
  - [4.5 如何将phalapi和GatewayWorker结合使用](http://docs.phalapi.net/#/v2.0/components/more/how-to-work-with-gateway.md)
  - [4.6 RabbitMQ消息队列](http://docs.phalapi.net/#/v2.0/components/more/mq-rabbitmq.md)
  - [4.7 其他教程及知识点](http://docs.phalapi.net/#/v2.0/components/more/other_content.md)
  - [4.x 如何参与文档的编辑](http://docs.phalapi.net/#/v2.0/components/more/how-to-edit.md)

五、2020视频教程
  - [第一课 B站首发，2020视频教程开讲啦！](http://docs.phalapi.net/#/v2.0/components/course/video_1.md) 由开源作者dogstar进行全面的视频教程讲解，带领技术新手快速掌握使用PHP接口项目的开发。 
  - [第二课 视频教程 - 下载和安装](http://docs.phalapi.net/#/v2.0/components/course/video_2.md) 在Windows/Mac/Linux系统下的安装视频。  
  - [第三课 视频教程 - Hello World](http://docs.phalapi.net/#/v2.0/components/course/video_3.md) 编写第一个Hello World接口。 
  - [第四课 视频教程 - 如何请求接口服务](http://docs.phalapi.net/#/v2.0/components/course/video_4.md)  如何指定待请求的接口服务？  
  - [第五课 视频教程 - 接口响应与在线调试](http://docs.phalapi.net/#/v2.0/components/course/video_5.md)  如何返回接口结果？  
  - [第六课 视频教程 - Api接口层](http://docs.phalapi.net/#/v2.0/components/course/video_6.md) Api层职责是什么？  
  - [第七课 视频教程 - Domain领域业务层与ADM模式解说](http://docs.phalapi.net/#/v2.0/components/course/video_7.md) 何为Api-Domain-Model模式？  
  - [第八课 视频教程 - Model数据层与数据库连接](http://docs.phalapi.net/#/v2.0/components/course/video_8.md) 如何连接数据库和数据库基本配置。  
  - [第九课 视频教程 - 测试驱动开发与PHPUnit](http://docs.phalapi.net/#/v2.0/components/course/video_9.md) PhalApi默认的单元测试、TDD 测试驱动开发和经典的PHPUnit（XUnit）。  
  - [第十课 视频教程 - 自动加载和PSR-4](http://docs.phalapi.net/#/v2.0/components/course/video_10.md) PHP世界中的各种类自动加载方式。  
  - [第十一课 视频教程 - 接口文档](http://docs.phalapi.net/#/v2.0/components/course/video_11.md) 别再手动编写接口文档了！  
  - [视频教程 - 十分钟体验PhalApi Pro，让PHP接口开发更有趣！](https://www.bilibili.com/video/av89890967/) 需要更专业的商用接口平台？可以了解一下专业版！  
  - [视频教程 - 茶店应用实战](https://www.bilibili.com/video/av95817153) 一个完整的小程序项目。  

六、关于PhalApi 2.x
  - [6.1 PhalApi 2.x 版本完美诠释](http://docs.phalapi.net/#/v2.0/what-about-2x.md) 带你走进PhalApi最最核心的内核和2.x版本的系统架构设计。  
  - [6.2 PhalApi 2.x 升级指南](http://docs.phalapi.net/#/v2.0/how-to-upgrade-2x.md) 新项目推荐使用 2.x版本，历史项目不支持1.x直接升级到2.x。  
  - [6.3 PhalApi 2.x VS PhalApi 1.x](http://docs.phalapi.net/#/v2.0/compare-2x-with-1x.md) 没有最好，只有更好。从性能、单元测试、静态代码质量等多个维度进行综合分析。    

七、版本更新 
  - [更新日记](http://docs.phalapi.net/#/v2.0/changelog.md?v=2.23.0)  历年的PhalApi 2.x 开源接口框架版本更新。  
  - [历史归档](http://docs.phalapi.net/#/v2.0/recovery.md) 运营平台和应用市场，不再默认开放，有需要可以自己手动恢复。  
  - [](.md)
  - [](.md)

