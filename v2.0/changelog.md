# PhalApi 2.x 开源接口框架版本更新

## PhalApi v2.22.1（2023-06-13）

### 主要更新
 + 1、简化PhalApi接口项目，删除portal以及不需要的插件  

## PhalApi v2.21.6 (2023-04-17)  

### 主要更新
 + 1、自定义动态返回JSON根节点  ```\PhalApi\Response::addResult($key, $value)```  
 ![](/images/20230417-231929.png)  
 + 2、CURL请求，支持手动设置为请求失败时不抛出异常 ```\PhalApi\CUrl::setIsThrowException(false)```  

### Bugfixed
 + 1、优先修复接口测试后返回结果的高亮以及超出换行显示；  
 ![](/images/20230215-213129.png)  
 + 2、修复每个月1号日志文件权限问题，主要是创建目录后再次更新目录权限  
 + 3、fixed 文件配置加载失败导致计划任务程序中断，提供新接口 ```\PhlaApi\DI()->config->resetConfig()->get('xxx.xxx');```  


## PhalApi v2.20.0 (2022-12-25)

### 主要更新

 + 1、PhalApi-NotORM 2.12.1 底层数据库更新，合并NotORM_Literal的参数，让其支持```:name```的参数绑定方式。例如MySQL在进行REPLACE()操作时。

### Bugfixed

### 扩展更新

 + 1、完善```phalapi/cli```命令行扩展：  
  - 对必须的参数进行校验；对执行接口结果进行JSON美化显示；支持多种颜色提示；
  - 支持 自定义帮助说明；同步更新文档；追加 service的输出提示；  
  - 扩展接口命令列表、扩展公共命令参数。  

 ![](/images/20221208-174039.png)   


## PhalApi v2.19.0 (2022-12-02)

PhalApi开源接口框架 v2.19.0

### 主要更新
 + 1、新增 生成PHP代码骨架的 [phalapi-buildcode命令](http://docs.phalapi.net/#/v2.0/shell)，由 ```萤火虫``` 协助提供；  

```bash
$ ./bin/phalapi-buildcode 
Wecome to use ./bin/phalapi-buildcode command tool v0.0.1

Example:  ./bin/phalapi-buildcode --a User/Reg

Usage:  Command [options] [arguments]
  --a          创建一个API层文件
  --d          创建一个Domain层文件
  --m          创建一个Model层文件
```

 + 2、在线接口文档，支持 按接口自定义标题/按接口英文名称（默认） 两种友好的[接口列表排序](http://docs.phalapi.net/#/v2.0/api-docs?id=%e5%a6%82%e4%bd%95%e8%b0%83%e6%95%b4%e6%8e%a5%e5%8f%a3%e6%96%87%e6%a1%a3%e7%9a%84%e5%88%86%e7%b1%bb%e5%92%8c%e6%8e%92%e5%ba%8f%ef%bc%9f)展示方式；  
 ![](/images/20221202-164044.png)  

### Bugfixed
暂无。

### 扩展类库

 + 1、[phalapi/cli](https://github.com/phalapi/cli) 扩展类库发布 v3.1.0 版本，同步升级所依赖的[GetOpt.PHP](https://github.com/getopt-php/getopt-php)，以及优化以命令行方式运行接口的提示、类型映射等；   
 ![](/images/cli-20221123-224827.png)    

## PhalApi v2.18.8 (2022-11-12)

PhalApi开源接口框架 v2.18.8    

### [主要更新]

 + 1、新增默认的首页；
 + 2、修复admin服务注释后的报错；
 + 3、添加Hello world示例接口；
 + 4、同步升级内核 PhalApi Kernal 2.18.8，开放PDO连接获取。（如果项目中有重载```\PhalApi\Database\Database::getPdo($dbKey)```，需要同步将此方法的访问级别从protected提升到public）

![](/images/2022-11-12T09-54-16.420Z.png)

## PhalApi v2.18.7 (2022-11-02)

PhalApi开源接口框架 v2.18.7

### [主要更新]

 + 1、在SQL日记，追加显示数据库名称，调整前是：```表名```，调整后是```数据库名.表名```，例如：```db_name.table_name```  

![](/images/20221102-222929.png) 

## PhalApi 2.18.4
### [主要更新]
 + 1、接口文档分类，支持按接口模块名称分组显示  
![](/images/20220809-204539.png)   

## PhalApi 2.18.2

### [BUG修复]

 + 1、优化接口文档不存在的情况，以更友好的方式保留显示service名称，避免污染受访接口服务名称。

## PhalApi 2.18.1

### [BUG修复]
 + 1、@Version注解，偏移量+1，修复多显示了空格

## PhalApi 2.18.0 

### [主要更新]
 + 1、API接口文档，支持```@version```注解  
![](/images/v2.18-1.png)   
 + 2、对在线的接口列表文档和接口详情文档，优化接口请求方式GET和POST的同步高亮提示  
![](/images/v2.18-2.png)   

### [BUG修复]
 + 1、修复接口在线测试，无法支持GET请求

## PhalApi 2.17.4
### [主要更新]

### [BUG修复]
 + 1、统一在线接口文档模板渲染路径，解决异常时模板不一致

## PhalApi 2.17.3
### [主要更新]
 + 1、在线接口文档，请求方式同步显示，并且修复接口标题有HTML样式时无法显示标题的问题
 + 2、集成```.env```文件的环境变量配置，新增文档[使用.env进行环境配置](http://docs.phalapi.net/#/v2.0/phpdotenv)

### [BUG修复]
 + 1、fix:使用window.localStorage存储接口的在线调试参数(PR提交合并，by ledccn)

## PhalApi 2.17.2

### [BUG修复]
 + 1、SQL记录，只提取部分必要的参数，避免全部记录，以及避免记录密码等敏感信息到日志文件  
 + 2、翻译和DataApi参数说明补充  
 + 3、DataModel调用不存在方法时的异常提示信息，去掉多余的美元符号
 + 4、在线接口文档模板判断调整，避免出现warning  

## PhalApi 2.17.1
### [BUG修复]
1、优化路由解析，解决开启后无法正常访问默认接口的问题，@大卫

## PhalApi 2.17.0 
### [主要更新]
 + 1、新增API_NAMESPACE，方便在入口指定当前默认的命名空间，即默认模块。缺省值为：App  
 + 2、新增HtmlResponse，支持简单页面渲染返回，```@大卫```

### [BUG修复]
 + 1、优化路由解析，解决开启后无法正常访问默认接口的问题，```@大卫``` 

## PhalApi 2.16.0
### [主要更新]
 + 1、新增接口```@method```注释，可以限制接口请求方式为GET或POST或其他，同步修改接口文档列表页、接口文档详情页。 

## PhalApi 2.15.0 
### [主要更新]
 + 1、添加脚本，一键生成DataModel源代码，bin/phalapi_build_data_model.php
 + 2、调整优化应用市场，向更开放的开源社区方向调整，插件源代码仓库[位置](https://gitee.com/dogstar/PhalApi-Net/tree/master/download/plugins)
 + 3、开源协议从原来的GPL-2调整成更开放的Apache License，更利于商业化使用

### [BUG修复] 
 + 1、修复部署在非public目录下，在线接口文档样式加载失败的问题
 + 2、解决使用 phpstorm 编辑时，因为找不到闭合标签爆红

## PhalApi 2.14.0

### [主要更新]
 + 1、增加扩展[phalapi/ding-com-bot](https://gitee.com/kaihangchen_admin/DingComBot)，钉钉企业内部webhook机器人扩展，```by NullUserException```
 + 2、在线接口文档支持设置文档查看密码
   ![](http://cd8.yesapi.net/yesyesapi_20200413092820_23af88be4a214167876f1446fbcc26f5.png)
 + 3、在线接口文档支持翻译，提供英文和简体中文，可进行语言切换
   ![](http://cd8.yesapi.net/yesyesapi_20200426144656_19c017a002c21501e9c53127a5af773d.png)  
 + 4、一些已知bugfixed

### [Portal运营后台]
 + 1、一些已知bugfixed

## PhalApi 2.13.3

### [主要更新]

 + 1、Cache具体实现类添加```Cache::pull($key)```新方法，实现Get&Delete操作。PhalApi\Cache接口不添加此方法，避免升级后影响已有的实现类。 
 + 2、DataApi进驻Kernal内核
 + 3、上线英文文档：https://docs-en.phalapi.net/#/ ，海外，支持HTTPS，by```williamjiangsa```
   ![](http://cd8.yesapi.net/yesyesapi_20200327145639_b272b5ef69469514a8499f60e45cc53d.png) 
 + 4、增加错误处理，```PhalApi\Error```，可纪录警告、提醒和致命错误
 + 5、在线接口文档，支持更多示例，如：Javascript示例、Object-C示例、Java示例、CURL示例、PHP示例、Python示例、Golang示例、C#示例
   ![](http://cd8.yesapi.net/yesyesapi_20200330112631_6b554cfab3e4586799bd6e4b5174e8aa.png)  
 + 6、内置User用户插件、Portal运营平台插件
   ![](http://cd8.yesapi.net/yesyesapi_20200331131605_f1655e5be028aa93c218b176714717ce.png)
 + 7、一些已知的bugfixed



### [Portal运营后台]
 + 1、添加菜单显示权限的控制，分可用户角色和指定用户
   ![](http://cd8.yesapi.net/yesyesapi_20200326115903_4dfcf8d4088c59d3d2591b6aeba7fbf2.png)
 + 2、实现插件的卸载
   ![](http://cd8.yesapi.net/yesyesapi_20200326152402_0a617958bb371af6fa3b12bb80c29a67.png)  
 + 3、管理员admin添加判断是否超管
 + 4、插件版本检测与更新提示
 + 5、首页调整
   ![](http://cd8.yesapi.net/yesyesapi_20200331131856_5363b9786cfcebe7b344745d1c2127d7.png)
 + 6、一些已知的bugfixed


## PhalApi 2.12.0

### [主要更新]
 + 1、NotORM底层包支持LEFT JOIN关联查询，新增接口```alias($aliasTableName)```和```leftJoin($joinTableName, $aliasJoinTableName, $onWhere)```，接口更友好。
 + 2、进行数据库查询时，以下划线+数字为后缀的表名会自动作为分表被解析，当分表策略不存在时会自动去掉数字后缀。通过新增的```dbs.tables.__default__.keep_suffix_if_no_map```配置项，当设置为true时可以在当分表未匹配时依然保留数字作为表后缀。分表路由中也可通过```keep_suffix_if_no_map```进行配置，且优先级高于```__default__```，同时能进行单独配置。
 + 3、当前环境的配置文件优先加载，新增宏定义API_MODE，可以是：dev, test, prod
 + 4、工具类PhalApi\Tool类中添加新方法：```arrayExcludeKeys($array, $excludeKeys)```，可用于排除数组中不需要的键，例如用于排除数据库查询结果不需要的字段。
 + 5、基于layuimin开发管理后台
 + 6、在./config/di.php注入初始化文件，添加第三方插件的装载入口。
 + 7、在线接口文档UI美化，更优雅

![](http://cd8.yesapi.net/yesyesapi_20200310225952_d319cc197a31f8f3522a82643bf31d60.png)

### [Portal运营后台]
作为历来的痛点，PhalApi虽然作为接口开源框架，但一直缺少管理后台。为此，PhalApi采用了当前流行且优秀的layuimin开发全新的管理后台。作为第一版管理后台，功能特点有：  
 + 1、实现管理员创建、后台登录、修改密码和退出等功能
 + 2、添加管理后台模块接口，命名空间为Admin，并且提供管理员会话检测的```PhalApi\DI->admin```服务
 + 3、管理后台菜单的动态获取
 + 4、管理后台的静态页面示例调整

![](http://cd8.yesapi.net/yesyesapi_20200309172737_a4b73f5763b4d8758f367a2a34230830.png)

### [官方应用市场]
官方应用市场已同步上线，欢迎广大开发者进驻！  
![](http://cd8.yesapi.net/yesyesapi_20200312174646_c11cdee922c66706ffa2b5c16900ef2c.png)
> PhalApi应用市场：http://www.yesx2.com/

### [辅助更新]
 + 1、添加[PhalApi的钉钉群webhook机器人扩展](https://gitee.com/kaihangchen_admin/DingBot)，由```NullUserException```提供。

### [BUG修复] 
 + 1、修复mssql编码设置问题， ```'NAMES' is not a recognized SET option.```

## PhalApi 2.11.0

### [主要更新]
 + 1、接口文档，接口命令空间翻译成中文，把```App```显示为```我的应用```
 + 2、在线接口文档兼容扩展类库中多级命名空间的接口，例如```PhalApi\扩展名.Site.Index```调整为```PhalApi_扩展名.Site.Index```
 + 3、优化接口文档在线测试交互，添加loading，避免接口请求失败时无法区分
 + 4、文件日记支持日记文件名前缀配置，以及改用工厂方法加系统配置方式初始化注册文件日记服务
 + 5、添加配置项```sys.response.structure_map```，支持接口返回结果的字段映射配置
 + 6、在线接口文档的semantic前端资源改用本地

### [辅助更新]
 + 1、添加[PhalApi 2.x 虎皮椒支付扩展](https://github.com/phalapi/xunhupay)
 + 2、收录[symochan/phalapi-usercheck](https://github.com/hs9206/phalapi-usercheck)第三方用户登陆检测 UserCheck扩展

### [BUG修复]
 + 1、修复离线文档生成时不能指定列表和详情页模板，并且统一模板路径

## PhalApi 2.10.0

### [主要更新]
 + 1、PDO支持具体驱动的连接选项，支持连接超时设置，避免接口长时间连接出现504 Time out
 + 2、PDO调整为有错误时抛出携带更详细错误信息的PDOExcepion，避免笼统的错误提示
 + 3、添加```\PhalApi\Api::getApiCommonRules()```，以便支持部分接口不需要全局应用参数的场景。
 + 4、支持接口参数置空，通过NULL或FALSE赋值可将接口参数取消
 + 5、在线接口文档，接口参数转换成客户端看到的参数类型
 + 6、接口参数规则中添加is_doc_hide配置，设置为true时，接口文档不显示此参数，但实际上仍可在PHP代码中使用

### [辅助更新]

### [BUG修复]


## PhalApi 2.9.1 

### [主要更新]
 + 1、特别注意：数据库查询返回结果默认都为字符串类型，优化为自动类型匹配，如整型。如果不需要开启，则可添加 ```dbs.servers.db_master.pdo_attr_string``` 配置项为true，则可以保持原来继续返回为字符串的数据库结果。如果出现：the database server cannot successfully prepare the statement 错误，请进行调试并手动检测SQL的语法正确性。
 + 2、对于接口参数规则，增加解析后的回调函数配置on_after_parse，支持多个函数名的管道配置和回调函数配置，详细请见文档说明[解析后回调函数 on_after_parse](http://docs.phalapi.net/#/v2.0/api-params?id=%e5%85%ac%e5%85%b1%e5%8f%82%e6%95%b0%e9%85%8d%e7%bd%ae%e9%80%89%e9%a1%b9)
 + 3、添加日志接口示例

### [辅助更新]
 + 1、迁移User扩展到2.x，[phalapi/user](https://packagist.org/packages/phalapi/user)
 + 2、日志文件在di初始化时，若缺少目录权限，在调试时不抛出异常，避免初始化失败

### [BUG修复]
    + 1、PHPRPC扩展，[修复rpc请求$_GET为空问题](https://github.com/phalapi/phprpc/pull/1)
    + 2、对于array接口参数规则，当传递参数为空字符串时，解析为空数组array()，而不是包含一个空字符串的数组array('')

## PhalApi 2.8.0

![](http://cd8.yesapi.net/yesyesapi_20190906104439_b646444bcd0c285705692dfd33808c09.png)

### [主要更新]
 + 1、文件日志[PhalApi\Logger\FileLogger](https://github.com/phalapi/kernal/blob/master/src/Logger/FileLogger.php)区分隐式静默和显式异常两种模式，可通过\PhalApi\DI()->debug全局模式或初始化时指定调试模式。为调试模式时，若写入失败将500异常提示
 + 1、文件配置[PhalApi\Config\FileConfig](https://github.com/phalapi/kernal/blob/master/src/Config/FileConfig.php)区分隐式静默和显式异常两种模式，可通过\PhalApi\DI()->debug全局模式或初始化时指定调试模式。为调试模式时，若配置不存在将500异常提示

### [辅助更新]
 1、修复phalapi/PHPMailer扩展一些bug，支持使用网易邮箱
 2、新增微信公众号、企业号等开发扩展[phalapi/phalapimp](https://gitee.com/kaihangchen_admin/phalapimp)

### [BUG修复]
 + 1、URI路由匹配模式下默认接口读取不到
 + 2、配置多个数据库时候, 调用get、update时会提示 dbs.tables should not be empty （[issue 97](https://github.com/phalapi/phalapi/issues/97)）

## PhalApi 2.7.0

![20190701093439](https://user-images.githubusercontent.com/12585518/60406042-7f2dc480-9be6-11e9-8702-5447dcb19b95.jpg)

### [主要更新]

 +  1、在系统配置中追加新的配置项```sys.enable_sql_log```：是否记录SQL日志。将上一版需要[手动记录SQL日志](https://github.com/phalapi/phalapi/blob/master-2x/src/app/Common/Tracer.php)的方式实现配置化。[能不能同时记录一下当前运行的SQL命令的数据库?](https://github.com/phalapi/phalapi/commit/41b463d96392e80f3c0f53266ac71af61fb5a0de)
 + 2、文件缓存[FileCache](https://github.com/phalapi/kernal/blob/master/src/Cache/FileCache.php)，追加新配置项：是否格式化缓存文件名enable_file_name_format，默认为TRUE。为FALSE时不格式化文件名，方便查看，但开发者需要注意文件名的有效性。
 + 3、开放接口文档模板（即从Kernal移到PhalApi，方便项目修改）；并在接口详情在线文档，追加支持JSON示例的配置和展示。接口返回的示例放置在./src/app/demos目录下，各个应用分开，文件名以接口服务名称为文件名，后缀为```.json```。
 ![](http://cd8.yesapi.net/yesyesapi_20190522100934_d74f29dbb6af0de572206d7330475f2e.jpeg)
 + 4、数据库连接配置支持sql server(通过dblib驱动)，感谢 ```@薛胜林```提供。
 + 5、调整默认的数据库配置，表前缀```prefix```默认为空。此调整只对新项目的配置有影响，该配置位于```./config/dbs.php```。
 + 6、添加```sys.enable_uri_match```配置，开启后可进行URI路由匹配。
 
### [辅助更新]

 + 1、PhalApi 2.x扩展类库，PHPMailer，添加port端口配置，可以支持465等端口。
 + 2、添加PhalApi 2.x扩展类库，[MongoDB 扩展](https://github.com/logmecn/phalapi-mongo)，```by logmecn```

### [BUG修复]

 + 1、PhalApi 2.x FastRoute扩展一些bugfixed，感谢 ```@pluveto```


## PhalApi 2.6.1

### [主要更新]

 + 1、默认MD5签名增加分隔符,防止位移篡改参数
 + 2、清除vendor下的空目录，避免composer update失败
 + 3、获取头部，兼容HTTP_USER_AGENT和User-Agent这两种写法，提高友好性
 + 4、NotORM底层包新增接口：executeSql($sql, $parameters)，可用于执行带结果的原生sql。
 + 5、NotORM底层包新增支持更新单个或多个计数器的接口：updateCounter()、updateMultiCounters()
 + 6、支持PostgreSQL数据库配置

### [辅助更新]

 + 1、移植[PHPRPC扩展](https://github.com/phalapi/phprpc)到2.x版本
 + 2、移植[Pay扩展](https://github.com/phalapi/pay)到2.x版本

### [BUG修复]

 + 1、修复离线文档的生成

## PhalApi 2.5.0

### [主要更新]

 + 1、phalapi-buildtest脚本升级，优化单元测试代码生成
 + 2、NotORM底层包支持在批量插入inser_multi时使用IGNORE关键词，PhalApi-NotORM更新至2.3.0版本
 + 3、接口参数新增message配置，支持自定义友好的错误提示信息，并支持i18n国际翻译

### [辅助更新]

 + 1、七牛上传时支持文件名前缀配置 preffix
 + 2、新增扩展[session 封装](https://github.com/Zhangzijing/session)，由@Zhangzijing 提供
 + 3、在线接口文档界面美化
 + 4、添加默认的redis配置

### [BUG修复] 

 + 1、修复在线文档数组默认值反序列化问题

## PhalApi 2.4.2

### [BUG修复]

 + 1、在线文档bugfixed：搜索框样式、版本号、日期等

## PhalApi 2.4.0

### [主要更新]

 + 1、在线文档，样式优化，并添加接口搜索功能，方便查找

### [辅助更新]

 + 1、新增[CORS跨域扩展](https://github.com/gongshunkai/phalapi-cors)，由@吞吞小猴 提供  
 + 2、2.x文档完善，丰富数据库操作的说明及示例

### [BUG修复]

 + 1、分表策略下默认缺省表名再次获取时，因缓存击中而最终出现表_xxx不存在，bugfixed
 + 2、默认接口返回时，对于XML格式的输出进行object转字符串的报错修正

## PhalApi 2.3.1

 + 1、一些bugfixed

## PhalApi 2.3.0

### [主要更新]

 + 1、[NotORM 功能增强](https://github.com/phalapi/kernal/pull/5)
 + 2、[请求模拟的参数的来源为server或header时隐藏该参数](https://github.com/phalapi/kernal/pull/6)
 + 3、修改返回空数组```[]```，为返回空对象```{}```（此外会存在不兼容性问题，请留意）
 + 4、[NotORM组件更新](https://github.com/phalapi/notorm/pull/1)：增加getConn用法 返回原生PDO驱动用法,在一些特殊的情况下使用；增加exec用法,用于执行一些特殊语句；phalapi/phalapi#68简化事务操作方法
 + 5、[Helper 修改增强](https://github.com/phalapi/kernal/pull/7)
 + 6、新增命令行终端执行的命令./bin/phalapi-cli  

### [辅助更新]

 + 1、新增[微信小程序扩展](https://packagist.org/packages/phalapi/wechatmini)
 + 2、官网2.0文档添加全文档搜索（感谢```@Qin```同学提交PR）
 + 3、[请求参数规则扩展](https://github.com/chenall/phalapi)

### [BUG修复]

## PhalApi 2.2.3

### [主要更新]

### [辅助更新]

 + 1、迁移[chenall/phalapi-soap](https://github.com/chenall/phalapi-soap)扩展，由 @chenall 提供  
 + 2、迁移[phalapi/auth](https://github.com/twodayw/auth.git) 扩展，由 @twodayw 提供  
 + 3、新增[phalapi/jwt](https://github.com/twodayw/phalapi2-jwt) 扩展，由 @twodayw 提供 
 + 4、新增[微信扩展phalapi-weixin](https://github.com/chenall/phalapi-weixin)，由 @chenall 提供  

### [BUG修复]

 + 1、文件缓存的文件名增强唯一性，避免冲突碰撞，加上前缀  
 + 2、解决接口参数如果设置正则表达式，不是必须参数情况下，依然要验证REGX的问题
 + 3、优化输入日志的时候，中文进行了编码，可读性较差问题

## PhalApi 2.2.2

### [主要更新]

 + 1、JSON格式错误时，追加参数错误提示  
 + 2、在线接口文档美化，添加顶部导航菜单，并添加友好的图标

### [辅助更新]

 + 1、迁移[phalapi/apk](https://github.com/wenzhenxi/phalapi2-apk)APK文件解包处理扩展，由 @喵了个咪 提供

### [BUG修复]

 + 1、单元测试兼容高版本的PHPUnit
 + 2、NotORM数据库查询失败时，修正空对象调用问题
 + 3、修复 接口详情页接口测试工具bug/新增多文件上传支持 @天未白

## PhalApi 2.2.0

### [主要更新]
 
 + 1、内嵌二维码QrCode扩展，并添加生成二维码的示例接口服务Examples_QrCode.Png  
 + 2、在线接口列表文档、在线接口详情文档，渲染时支持指定视图路径  

### [辅助更新]

 + 1、界面更美化的在线接口文档扩展[DocumentUI](https://gitee.com/dogstar/PhalApi-Library/tree/master/DocumentUI) ，由 @xcalder 提供，[参考示例](http://api.openant.com/users/listAllApis.php)  
 + 2、新增生成二维码[QrCode扩展](https://github.com/phalapi/qrcode)，基于PHP QrCode实现。  
 + 3、新增生成条形码[barcode扩展](https://github.com/phalapi/barcode)，基于barcodegen实现。
 + 4、新增拼音转换[pinyin扩展](https://github.com/phalapi/pinyin)，基于overtrue/pinyin实现。  
 + 5、迁移1.x扩展PhalApi-Image图像处理到[phalapi-image](https://github.com/gongshunkai/phalapi-image)，由 @吞吞小猴 提供  
 + 6、新增图灵机器人接口[Tuling123](https://gitee.com/dogstar/PhalApi-Library/tree/master/Tuling123) 扩展，由 @webx32 提供
 + 7、迁移短信扩展[phalapi-sms](https://github.com/gongshunkai/phalapi-sms)，由 @吞吞小猴 提供  
 + 8、增加[极验验证码扩展](https://github.com/gongshunkai/phalapi-gtcode)，由 @吞吞小猴 提供

### [BUG修复]

 + 1、修复在线接口列表文档，相同类名和相同方法名重复问题  

## PhalApi 2.1.2 (2017-11-05发布)

### [主要更新]

 + 1、在线文档列表添加多级菜单，支持一个命名空间一个折叠栏 (@吞吞小猴前端支持)  
 + 2、在线文档详情添加参数记忆功能，并支持全局同名参数共享数据  
 + 3、在线接口文档，支持接口类或方法的隐藏，注释为```@ignore```   
 + 4、在线详情文档，添加中文描述作为标题前缀
 + 5、数据库连接，默认添加sqlserver支持，```type = sqlserver```  
 + 6、支持命名空间白名单独立配置  
 + 7、```Issue #22``` 服务白名单时，全局接口参数不需要再验证

### [辅助更新]

 + 1、添加[phalapi/PHPMailer](https://github.com/phalapi/PHPMailer)邮件发送扩展
 + 2、《初识PhalApi——探索接口服务开发的技艺》电子书已编写完毕 
 + 3、添加[phalapi/qiniu](https://github.com/phalapi/qiniu)七牛CDN扩展
 + 4、收录[ctbsea/phalapi-smarty](https://github.com/ctbsea/phalapi-smarty)扩展

### [BUG修复]

 + 1、修复在线文档类名重复时有丢失显示
 + 2、出于安全考虑，仅当在调试模式下，正则匹配失败时才显示正则表达式
 + 3、在线接口详情文档，恢复文件上传功能
 + 4、在线接口详情文件，恢复在https协议下无法调试

## PhalApi 2.0.2 全新版本 (2017/09/02) 

### [PhalApi2安装方式]
使用composer创建项目的命令，可实现一键安装。
```
$ composer create-project phalapi/phalapi
```

### [主要更新]
 + 1、PhalApi2全面发布
 + 2、迁移View扩展到PhalApi 2.x 版本
 + 3、迁移Redis扩展类库到PhalApi 2.x 版本
 + 4、迁移扩展类库Task、FastRoute到PhalApi 2.x 版本
 + 5、完善单元测试，将代码覆盖率从76%提升到91％。

### [功能性更新]
 + 1、Json格式和JsonP格式支持中文显示设置，以及其他Json选项配置
 + 2、PhalApi_Curl部分代码优化，兼容PHP 5.3
 + 3、调试模式下，追加返回框架版本号，方便定位解决问题
 + 4、添加XML格式的响应返回
 + 5、service参数支持缩写，即使用?s=Class.Action等效于?service=Class.Action，两者都存在时优先使用service参数
 + 6、修改文件类型默认可以多选 根据选择文件是单张或多张，采取不同处理，兼容服务器端多文件上传处理方式 @Ederth

### [框架优化]
 + 1、修改优化内置Task扩展类库的语法问题
 + 2、框架性能优化，请求默认接口服务，总执行时间从8,393 microsecs降到4,486 microsecs，内存峰值从1,619,544 bytes降到767,920 bytes，函数调用次数从701次降至345次，性能约提升了近一倍，不止是更快。详细Xhprof分析报告请见[这里](https://www.phalapi.net/xhprof/xhprof_html/index.php?run=597d5b9e25889&source=xhprof_foo)。

### [BUG修复]
 + 1、修复文件上传时的Warning提示
 + 2、分表的主键问题修复

