# 打印和保存SQL语句

本章，将介绍SQL语句的在线调试打印和文件纪录。这对于平时开发和线上问题排查都非常有帮助，也是项目开发过程中经常要用到的技能。

# 调试模式细说

在PhalApi初期，只有一个开关控制全局的调试模式。回顾前面内容，可以发现。开启调试模式很简单，主要有两种方式：  

 + **单次请求开启调试**：默认添加请求参数```&__debug__=1```  
 + **全部请求开启调试**：把配置文件```./Config/sys.php```文件中的配置改成```'debug' => true,```  

在PhalApi 2.7.0版本后，为了进行更细维度的区分，增加了NotORM专用的调试开关```sys.notorm_debug```，同时添加了是否把SQL写入日志的开关配置```sys.enable_sql_log```。这三个开关配置，作用分别是：

 + sys.debug：是否开启接口调试模式，开启后在客户端可以直接看到更多调试信息
 + sys.notorm_debug，是否开启NotORM调试模式，开启后仅针对NotORM服务开启调试模式
 + sys.enable_sql_log，是否纪录SQL到日志，需要同时开启notorm_debug方可写入日志

组合场景如下：

sys.debug|sys.notorm_debug|sys.enable_sql_log|场景说明
---|---|---|---
true|true|true|适用于后端自测和开发时使用，即全能的开发模式。可以在接口返回的sqls字段直接查看SQL语句，也可以在日志文件中查看SQL语句。
false|true|true|适用于生产环境或测试环境，在客户端不会显示调试信息。但在runtime的日志文件中会纪录SQL语句。
false|false|false|适用于生产环境，不进行任何调试，不纪录任何SQL语句。

# 打印SQL语句

如前面章节所介绍，当开启调试模式后，在请求接口时可实时显示本次接口执行过程中执行的全部SQL语句。

### 全部SQL语句在哪里？

开启调试模式后，不管接口响应为正常还是异常，都可以在debug.sqls字段，看到本次执行的全部SQL语句。如下所示：  
```
{
    "ret": 200,
    "data": {
    },
    "msg": "",
    "debug": {
        "sqls": [  // 全部执行的SQL语句
        ]
    }
}
```

### 获取全部的SQL语句

使用以下代码，可以获取截止到当前所执行和查询的全部SQL语句，返回的是一个数组。  
```php
$sqlArr = \PhalApi\DI()->tracer->getSqls();
```

### 获取获取最后一条SQL语句

使用以下代码，可以获取最后执行或查询的SQL语句。  
```php
// 返回最后一条SQL语句，没有任何SQL语句时返回false
$sql = \PhalApi\DI()->tracer->getLastSql();
```

> 此功能需要在PhalApi 2.23.0 及以上版本才支持。

## SQL语句解读
在debug.sqls中会显示所执行的全部SQL语句，由框架自动搜集并统计。
示例：  
```
[#1 - 0.84ms - 49.1KB - SQL]/path/to/phalapi/src/app/Api/Examples/CURD.php(96): App\\Domain\\Examples\\CURD::get() phalapi.phalapi_curd SELECT * FROM phalapi_curd WHERE (id = 1);
```
表示是第一条执行的SQL语句，消耗了0.84毫秒，内存消耗49.1KB，SQL语句是```SELECT * FROM phalapi_curd WHERE (id = 1);```，操作的数据库是phalapi、数据库表是phalapi_curd。  

最后显示的SQL打印格式是：  
```
[#序号 - 当前SQL的执行时间ms - 当前SQL消耗的内存大小 - SQL]执行的PHP文件路径(行号):    执行的PHP类名和方法名   数据库名.数据库表名    所执行的SQL语句及参数列表
```
> 温馨提示：PhalApi 2.23.0 及以上版本，追加了内存大小的记录和打印。  

更完整的SQL格式解读，请参考文档：[接口响应与在线调试 - 查看全部执行的SQL语句](http://docs.phalapi.net/#/v2.0/database-sql-debug)，此处不再赘述。  


## SQL调试示例

例如，我们可以请求App.Examples_CURD.SqlDebug这个示例接口，对数据库进行一些简单操作，并且在请求时开启调试模式。最终请求的接口链接是：

```
http://dev.phalapi.net/?s=App.Examples_CURD.SqlDebug&__debug__=1
```

接口源代码是：
```php
<?php
namespace App\Api\Examples;
    
use PhalApi\Api;
use App\Domain\Examples\CURD as DomainCURD;

/** 
 * 数据库CURD基本操作示例
 * @author dogstar 20170612
 */     

class CURD extends Api {
    /**
     * 演示如何进行SQL调试和相关的使用
     * @desc 除此接口外，其他示例也可进行在线调试。本示例将便详细说明如何调试。
     */
    public function sqlDebug() {
        $rs = array();

        // 当需要进行sql调试时，请先开启sys.debug和sys.notorm_debug，设置为true

        // 以下是操作数据库部分
        // 第一种，你可以直接在API层或任何地方使用全局方式操作数据库（但不推荐！）
        $rs['row_1'] = \PhalApi\DI()->notorm->phalapi_curd->where('id', 1)->fetchOne();

        // 第二种，基本的CURD可以使用Model类直接完成（推荐！）
        $model = new \App\Model\Examples\CURD();
        $rs['row_2'] = $model->get(2);

        // 第三种，通过Domain领域层统一封装（强烈推荐！！）
        $domain = new DomainCURD();
        $rs['row_3'] = $domain->getList(3, 1, 5);

        // 到这一步，你可以访问当前接口（手动/通过配置开启调试模式）
        // 浏览器访问：http://localhost/phalapi/public/?s=App.Examples_CURD.SqlDebug&__debug__=1
        // 将会在debug返回字段看到SQL调试信息

        // 最后，当sys.notorm_debug和sys.enable_sql_log均开启时，将能在日志文件中纪录sql
        // 如命令：$ tail -f ./runtime/log/201905/20190523.log

        return $rs;
    }
}
```

最终返回的接口结果，经JSON格式后是：
```json
{
    "ret": 200,
    "data": {
        "row_1": false,
        "row_2": false,
        "row_3": {
            "items": [],
            "total": 0
        }
    },
    "msg": "",
    "debug": {
        "stack": [
            "[#1 - 0ms - 757.3KB - PHALAPI_INIT]/path/to/phalapi/public/index.php(6)",
            "[#2 - 0.8ms - 782.1KB - PHALAPI_RESPONSE]/path/to/phalapi/vendor/phalapi/kernal/src/PhalApi.php(46)",
            "[#3 - 202.9ms - 1.1MB - PHALAPI_FINISH]/path/to/phalapi/vendor/phalapi/kernal/src/PhalApi.php(74)"
        ],
        "sqls": [
            "[#1 - 44.23ms - 48.5KB - SQL]/path/to/phalapi/src/app/Api/Examples/CURD.php(149): App\\Api\\Examples\\CURD::sqlDebug() phalapi.phalapi_curd SELECT * FROM phalapi_curd WHERE (id = 1) LIMIT 1;",
            "[#2 - 0.45ms - 48.8KB - SQL]/path/to/phalapi/src/app/Api/Examples/CURD.php(153): App\\Api\\Examples\\CURD::sqlDebug() phalapi.phalapi_curd SELECT * FROM phalapi_curd WHERE (id = 2);",
            "[#3 - 86.83ms - 48.9KB - SQL]/path/to/phalapi/src/app/Domain/Examples/CURD.php(34): App\\Model\\Examples\\CURD::getListItems() phalapi.phalapi_curd SELECT * FROM phalapi_curd WHERE (state = 3) ORDER BY post_date DESC LIMIT 0,5;",
            "[#4 - 42.91ms - 46.4KB - SQL]/path/to/phalapi/src/app/Domain/Examples/CURD.php(35): App\\Model\\Examples\\CURD::getListTotal() phalapi.phalapi_curd SELECT COUNT(id) FROM phalapi_curd WHERE (state = 3);"
        ],
        "version": "2.23.0"
    }
}
```

其中，可以看到本次执行的全部SQL语句：
```json
        "sqls": [
            "[#1 - 44.23ms - 48.5KB - SQL]/path/to/phalapi/src/app/Api/Examples/CURD.php(149): App\\Api\\Examples\\CURD::sqlDebug() phalapi.phalapi_curd SELECT * FROM phalapi_curd WHERE (id = 1) LIMIT 1;",
            "[#2 - 0.45ms - 48.8KB - SQL]/path/to/phalapi/src/app/Api/Examples/CURD.php(153): App\\Api\\Examples\\CURD::sqlDebug() phalapi.phalapi_curd SELECT * FROM phalapi_curd WHERE (id = 2);",
            "[#3 - 86.83ms - 48.9KB - SQL]/path/to/phalapi/src/app/Domain/Examples/CURD.php(34): App\\Model\\Examples\\CURD::getListItems() phalapi.phalapi_curd SELECT * FROM phalapi_curd WHERE (state = 3) ORDER BY post_date DESC LIMIT 0,5;",
            "[#4 - 42.91ms - 46.4KB - SQL]/path/to/phalapi/src/app/Domain/Examples/CURD.php(35): App\\Model\\Examples\\CURD::getListTotal() phalapi.phalapi_curd SELECT COUNT(id) FROM phalapi_curd WHERE (state = 3);"
        ],
```

Domain层和Model层操作数据库的相关代码请见项目源代码：https://github.com/phalapi/phalapi/tree/master-2x/src/app。

# 纪录SQL语句到日志文件

前面所介绍的实时打印SQL语句很实用，但只局限于现场查看。如果到线上环境，或者需要在测试环境查看过去执行了哪些SQL语句，就需要先把SQL语句存到日志文件，当有需要时再随时回来翻看。

## 纪录SQL到日志文件
当需要将SQL语句纪录到日志时，只需要开启两个配置，即：sys.notorm_debug和sys.enable_sql_log。可以修改./config/sys.php配置文件，改为：
```php
return array(
    /**
     * @var boolean 是否开启NotORM调试模式，开启后仅针对NotORM服务开启调试模式
     */
    'notorm_debug' => true,

    /**
     * @var boolean 是否纪录SQL到日志，需要同时开启notorm_debug方可写入日志
     */
    'enable_sql_log' => true,
);
```

继续请求上面的示例，可以在日志文件，例如：
```
$ tail -f ./runtime/log/201905/20190524.log 
```

对应看到：
```bash
2023-12-03 13:04:56|SQL|[#1 - 44.23ms - 48.5KB - SQL]/path/to/phalapi/src/app/Api/Examples/CURD.php(149):    App\Api\Examples\CURD::sqlDebug()    phalapi.phalapi_curd    SELECT * FROM phalapi_curd WHERE (id = 1) LIMIT 1;|{"request":{"service":"App.Examples_CURD.SqlDebug"}}
2023-12-03 13:04:56|SQL|[#2 - 0.45ms - 48.8KB - SQL]/path/to/phalapi/src/app/Api/Examples/CURD.php(153):    App\Api\Examples\CURD::sqlDebug()    phalapi.phalapi_curd    SELECT * FROM phalapi_curd WHERE (id = 2);|{"request":{"service":"App.Examples_CURD.SqlDebug"}}
2023-12-03 13:04:56|SQL|[#3 - 86.83ms - 48.9KB - SQL]/path/to/phalapi/src/app/Domain/Examples/CURD.php(34):    App\Model\Examples\CURD::getListItems()    phalapi.phalapi_curd    SELECT * FROM phalapi_curd WHERE (state = 3) ORDER BY post_date DESC LIMIT 0,5;|{"request":{"service":"App.Examples_CURD.SqlDebug"}}
2023-12-03 13:04:56|SQL|[#4 - 42.91ms - 46.4KB - SQL]/path/to/phalapi/src/app/Domain/Examples/CURD.php(35):    App\Model\Examples\CURD::getListTotal()    phalapi.phalapi_curd    SELECT COUNT(id) FROM phalapi_curd WHERE (state = 3);|{"request":{"service":"App.Examples_CURD.SqlDebug","__debug__":"1"}}
```

## 保存SQL到单独或其他日志文件
默认情况下，PhalApi使用框架默认的日记服务保存SQL语句，即会把SQL语句和其他logger日记放在同一个文件。如果需要把SQL全部单独保存到其他文件，你可以在DI注册tracer服务时，手动指定需要用到的logger服务，例如：  
```php
// 初始化好你的SQL日记服务，使用文件名前缀：sql_
$fileConfig = array_merge($di->config->get('sys.file_logger'), ['file_prefix' => 'sql']);
$sqlLogger = \PhalApi\Logger\FileLogger::create($fileConfig);
$di->tracer = new \PhalApi\Helper\Tracer($sqlLogger);
```

生效后，可以在runtime目录内，找到以```sql_```开头的SQL单独日记。  

# 扩展：定制自己的全球追踪器，对SQL进行更多操作

## 简单了解追踪器助手

上面介绍的SQL收集，其实是NotORM在执行SQL后回调了[PhalApi\Helper\Tracer::sql($statement)](https://github.com/phalapi/kernal/blob/master/src/Helper/Tracer.php)，相关框架代码如下：

```php
<?php
namespace PhalApi\Helper;

class Tracer {
    /**
     * 纪录SQL语句
     * @param string $string  SQL语句
     * @return NULL
     */
    public function sql($statement) {
        // 记录每一条SQL语句
    }
    /**
     * 获取SQL语句
     * @return array
     */
    public function getSqls() {
        return $this->sqls;
    }
}
```

如果我们需要把SQL语句存到日志文件以外的地方或者对慢日志进行报警，那么可以扩展此全球追踪器PhalApi\Helper\Tracer，并且重载sql()方法，实现更多功能。

## 实现自己的追踪器

可以创建 ```./src/app/Commom/Tracer.php``` 文件，例如，额外记录是哪个接口域名。可以参考以下PHP代码：

```php
<?php
namespace App\Common;

/**
 * 额外记录接口域名
 */
class Tracer extends \PhalApi\Helper\Tracer {

    public function sql($statement) {
        $statement = 'demo-api.phalapi.net|' . $statement;
        return parent::sql($statement);
    }
}

```

然后在 ```./config/di.php`` 文件中，重新注册tracer服务：
```php
// 注册扩展的追踪器
$di->tracer = function() {
    return new \App\Common\Tracer();
};  
```

访问接口，开启调试模式下，可以看到：  

在SQL日记文件，可以看到（节选）：  
```json
"sqls": [
    "demo-api.phalapi.net|[#1 - 0.73ms - 49.1KB - SQL]/path/to/phalapi/src/app/Api/Examples/CURD.php(96): App\\Domain\\Examples\\CURD::get() phalapi.phalapi_curd SELECT * FROM phalapi_curd WHERE (id = 1);"
],
```


最后，可以在单独的日记sql文件进行查看。例如：  
```bash
2023-12-03 13:15:35|SQL|demo-api.phalapi.net|[#1 - 0.73ms - 49.1KB - SQL]/path/to/phalapi/src/app/Api/Examples/CURD.php(96):    App\Domain\Examples\CURD::get()    phalapi.phalapi_curd    SELECT * FROM phalapi_curd WHERE (id = 1);|{"request":{"service":"App.Examples_CURD.Get"}}
```

