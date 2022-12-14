# 数据库连接

截至PhalApi 2.6.0 版本，内置支持的数据库连接有：

 + MySQL (PDO) 
 + MS SQL Server (PDO) 
 + PostgreSQL (PDO) 

# 数据库基本配置

数据库的配置文件为./config/dbs.php，默认使用的是MySQL数据库。主要有两部分配置：servers和tables。分别是：

 + servers，针对数据库的配置，可以配置多个数据库
 + tables，针对表的配置，支持配置分表（不需要分表可不配置分表）

## servers数据库配置

servers选项用于配置数据库服务器相关信息，可以配置多组数据库实例，每组包括数据库的账号、密码、数据库名字等信息。不同的数据库实例，使用不同标识作为下标。格式如下：　　

servers数据库配置项|配置说明|是否必须|默认值|示例
---|---|---|---|---
type|数据库类型|否|mysql|可以是mysql，sqlsrv或pgsql
host|数据库域名|否|localhost|127.0.0.1、或数据库域名
name|数据库名字|是||test
user|数据库用户名|是||root
password|数据库密码|是||123456
port|数据库端口|否|3306或1433|3306
charset|数据库字符集|否|UTF8|UTF8、utf8mb4
pdo_attr_string|结果集为字符串类型|否|false|推荐为false，PhalApi 2.9.0 及上以版本支持

例如下面这份默认配置。
```php
return array(
    /**
     * DB数据库服务器集群
     */
    'servers' => array(
        'db_master' => array(                         //服务器标记
            'host'      => '127.0.0.1',             //数据库域名
            'name'      => 'phalapi',               //数据库名字
            'user'      => 'root',                  //数据库用户名
            'password'  => '',                      //数据库密码
            'port'      => 3306,                  //数据库端口
            'charset'   => 'UTF8',                  //数据库字符集
        ),
    ),
);
```

默认的数据库标记是db_master，也就是servers的下标，注意db_master不是数据库名称，也是一个称号，通常是指主数据库，一般不需要修改。

## tables表配置

tables选项用于配置数据库表的表前缀、主键字段和路由映射关系，可以配置多个表，下标为不带表前缀的表名，其中```__default__```下标选项为缺省的数据库路由，即未配置的数据库表将使用这一份默认配置。  

简单来说，如果是简单的数据库使用，不需要分表，简单这样配置即可：
```php
    /**
     * 自定义路由表
     */
    'tables' => array(
        //通用路由
        '__default__' => array(
            'prefix' => 'tbl_',
            'key' => 'id',
            'map' => array(
                array('db' => 'db_master'),
            ),
        ),
    ),
```

其中， ```tables.__default__```是通配表，此下标不能更改或删除。每一组表的配置格式如下：

tables表配置项|配置说明|示例
---|---|---
prefix|表前缀|tbl_，如果没有统一表前缀可以为空
key|表主键|id
map|数据库实例映射关系，可配置多组。|array(array('db' => 'db_master'))

其中，map的每组格式为：```array('db' => 服务器标识, 'start' => 开始分表标识, 'end' => 结束分表标识)```，start和end要么都不提供，要么都提供。 此外，db_master不能更改或者需要在前面的servers已经配置。后面会在分表再详细解释，暂时不用理会。

将servers配置和tables的配置，放在一起就是：

```php
return array(
    /**
     * DB数据库服务器集群
     */
    'servers' => array(
        'db_master' => array(                         //服务器标记
            'host'      => '127.0.0.1',             //数据库域名
            'name'      => 'phalapi',               //数据库名字
            'user'      => 'root',                  //数据库用户名
            'password'  => '',                      //数据库密码
            'port'      => 3306,                  //数据库端口
            'charset'   => 'UTF8',                  //数据库字符集
        ),
    ),

    /**
     * 自定义路由表
     */
    'tables' => array(
        //通用路由
        '__default__' => array(
            'prefix' => 'tbl_',
            'key' => 'id',
            'map' => array(
                array('db' => 'db_master'),
            ),
        ),
    ),
);
```
其中，在servers中配置了名称为db_master数据库实例，意为数据库主库，其host为localhost，名称为phalapi，用户名为root等。在tables中，只配置了通用路由，并且表前缀为tbl_，主键均为id，并且全部使用db_master数据库实例。  

> **温馨提示：**当tables中配置的db数据库实例不存在servers中时，将会提示数据库配置错误。  

# 如何排查数据库连接错误？

普通情况下，数据库连接失败时会这样提示：
```
{
    "ret": 500,
    "data": [],
    "msg": "服务器运行错误: 数据库db_demo连接失败"
}
```
  
考虑到生产环境不方便爆露服务器的相关信息，故这样简化提示。当在开发过程中，需要定位数据库连接失败的原因时，可使用debug调试模式。开启调试后，当再次失败时，会看到类似这样的提示：  
```
{
    "ret": 500,
    "data": [],
    "msg": "服务器运行错误: 数据库db_demo连接失败，异常码：1045，错误原因：SQLSTATE[28000] [1045] ... ..."
}
```  
然后，便可根据具体的错误提示进行排查解决。 

## sql server连接报错SQLSTATE[IMSSP]解决方案

如果在连接sql server时，调试模式时，出现以下错误：
```
"服务器运行错误: 数据库db_master连接失败，异常码：IMSSP，错误原因：SQLSTATE[IMSSP]: The given attribute is only supported on the PDOStatement object."
```

是由于默认的PDO选项PDO::ATTR_ERRMODE设置为PDO::ERRMODE_EXCEPTION的原因，PHP官方文档介绍[错误与错误处理](https://www.php.net/manual/zh/pdo.error-handling.php)。 
解决方案是，修改./config/dbs.php里面的数据库配置，将PDO::ATTR_ERRMODE重新调整为PDO::ERRMODE_SILENT即可。  

```php
    'servers' => array(
        'db_master' => array(                       // 服务器标记
            // 省略……
            'driver_options' => array(              // PDO初始化时的连接选项配置
                // 若需要更多配置，请参考官方文档：https://www.php.net/manual/zh/pdo.constants.php
                \PDO::ATTR_ERRMODE => \PDO::ERRMODE_SILENT, // 错误模板重新设置为默认的PDO::ERRMODE_SILENT，解决sql server的连接错误
                ),
            ),
        ),
```

# 如何获取原始的PDO连接？

当在PhalApi提供的数据库API不能满足你的项目开发需求时，可以通过获取原始的PDO连接后，继续使用PHP官方所提供的PDO类的API接口。   

在PhalApi框架中，你可以使用DI里面的notorm服务或已经注册的其他数据库DI服务实例的 ```getPdo($dbKey)``` 方法，取得PDO连接。  

对应的函数签名是：  

```php
\PhalApi\Database\Database::getPdo($dbKey) — 获取 PDO连接，$dbKey 数据库标志，例如：db_master，返回 \PDO 对象
```

> 请注意：```$dbKey```参数不是你的数据库名称，而是在 dbs.php 文件中 servers数据库配置的数据库标记，例如常用的：db_master，也可以是自定义的值。  

使用示例：  
```php
$pdo = \PhalApi\DI()->notorm->getPdo('db_master');

// 同时执行多条SQL语句
$sql = "DROP TABLE  IF EXISTS `my_table_name`;

CREATE TABLE `my_table_name` (
     `id` int(11) NOT NULL AUTO_INCREMENT,
     `my_name` varchar(20)
);";

// 调用PHP官方的PDO::exec — 执行一条 SQL 语句，并返回受影响的行数
$execRs = $pdo->exec($sql);    
```

> 温馨提示：```\PhalApi\Database\Database::getPdo($dbKey)``` 在PhalApi 2.18.8 版本及以上，由原来的protected访问级别提升到了public。附：[Github提交](https://github.com/phalapi/kernal/commit/f854c996770ca52a10103195d2ca8809e4d1671e)。  

以下为PHP官方的PDO类提供的API接口和方法。 

 + PDO::beginTransaction — 启动一个事务
 + PDO::commit — 提交一个事务
 + PDO::__construct — 创建一个表示数据库连接的 PDO 实例
 + PDO::errorCode — 获取跟数据库句柄上一次操作相关的 SQLSTATE
 + PDO::errorInfo — Fetch extended error information associated with the last operation on the database handle
 + PDO::exec — 执行一条 SQL 语句，并返回受影响的行数
 + PDO::getAttribute — 取回一个数据库连接的属性
 + PDO::getAvailableDrivers — 返回一个可用驱动的数组
 + PDO::inTransaction — 检查是否在一个事务内
 + PDO::lastInsertId — 返回最后插入行的ID或序列值
 + PDO::prepare — 准备要执行的语句，并返回语句对象
 + PDO::query — 执行 SQL 语句，以 PDOStatement 对象形式返回结果集
 + PDO::quote — 为 SQL 查询里的字符串添加引号
 + PDO::rollBack — 回滚一个事务
 + PDO::setAttribute — 设置属性

> 更多使用，请参考[《PHP: PDO - Manual》](https://www.php.net/manual/zh/class.pdo.php)。   

# 如何断开数据库连接？

当需要断开数据库连接时，可以在合适的地方手动调用以下代码：
```php
\PhalApi\DI()->notorm->disconnect();
```

这里的操作是把注册在\PhalApi\DI()->notorm服务内的全部数据库都断开连接，断开后数据库即不可用，需要重新初始化和建立连接。  
例如，你可以在./public/index.php文件最后进行手动断开。

注意，如果你注册的服务名称不是notorm，则改成相应的自定义服务名称。  

