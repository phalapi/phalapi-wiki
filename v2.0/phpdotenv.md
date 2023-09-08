# 使用.env进行环境配置

为了更方便管理、切换和维护不同运行环境的环境配置，可以使用```.env```文件。此功能依赖于```vlucas/phpdotenv```。  

> vlucas/phpdotenv代码仓库：[https://github.com/vlucas/phpdotenv](https://github.com/vlucas/phpdotenv)  
> 温馨提示：按以下方式操作后，才支持 .env 文件的使用。  

## 手动安装
PhalApi已经内置集成了```.env```文件的配置和使用，如果需要手动安装，你可以执行：
```bash
$ composer require vlucas/phpdotenv
```

## 准备.env文件
使用前，可以把根目录的```.env.example```示例文件复制到```.env```。推荐从```.gitignore```中排除此配置文件。    
```bash
$ cp .env.example .env
```

为了和其他项目进行配置的区分，建议统一使用配置前缀，例如：```PHALAPI_```。  
打开修改```.env```文件，根据你的需要，添加或更新环境配置。    

```
# 数据库配置
PHALAPI_DB_TYPE="mysql"
PHALAPI_DB_HOST="127.0.0.1"
PHALAPI_DB_NAME="phalapi"
PHALAPI_DB_USER="root"
PHALAPI_DB_PASSWORD=""
PHALAPI_DB_PORT="3306"
PHALAPI_DB_CHARSET="UTF8"
```

## 使用 .env 环境配置
在数据库配置文件./config/dbs.php或系统配置./config/sys.php或其他配置文件，就可以使用```.env```文件中的环境配置。例如使用数据库的配置：  
```php
'db_master' => array(                       // 服务器标记 / database identify
    'type'      => isset($_ENV['PHALAPI_DB_TYPE'])      ? $_ENV['PHALAPI_DB_TYPE']      : 'mysql',                 // 数据库类型，暂时只支持：mysql, sqlserver / database type
    'host'      => isset($_ENV['PHALAPI_DB_HOST'])      ? $_ENV['PHALAPI_DB_HOST']      : 'localhost',             // 数据库域名 / database host
    'name'      => isset($_ENV['PHALAPI_DB_NAME'])      ? $_ENV['PHALAPI_DB_NAME']      : 'phalapi',               // 数据库名字 / database name
    'user'      => isset($_ENV['PHALAPI_DB_USER'])      ? $_ENV['PHALAPI_DB_USER']      : 'root',                  // 数据库用户名 / database user
    'password'  => isset($_ENV['PHALAPI_DB_PASSWORD'])  ? $_ENV['PHALAPI_DB_PASSWORD']  : '',                      // 数据库密码 / database password
    'port'      => isset($_ENV['PHALAPI_DB_PORT'])      ? $_ENV['PHALAPI_DB_PORT']      : '3306',                  // 数据库端口 / database port
    'charset'   => isset($_ENV['PHALAPI_DB_CHARSET'])   ? $_ENV['PHALAPI_DB_CHARSET']   : 'UTF8',                  // 数据库字符集 / database charset
    'pdo_attr_string'   => false,           // 数据库查询结果统一使用字符串，true是，false否
    'driver_options' => array(              // PDO初始化时的连接选项配置
        // 若需要更多配置，请参考官方文档：https://www.php.net/manual/zh/pdo.constants.php
        ),
    ),
```

## .env 更多用法

PhalApi已经注册了dotenv服务，见```config/di.php```：  
```php
$di = \PhalApi\DI();


// 加载 .env 环境配置
$di->dotenv = Dotenv\Dotenv::createImmutable(API_ROOT);
// .env 非必须的加载
$di->dotenv->safeLoad(); 
// .env 必须的加载方式
// $di->dotenv->load();


// 配置
$di->config = new FileConfig(API_ROOT . DIRECTORY_SEPARATOR . 'config');
```
> 温馨提示：如果```.env```文件对于项目是必须的，可以使用```load()```方式加载，否则可用```safeLoad()```。  

更多针对 ```.env``` 的用法，可以参考以下示例：  
```php
$di = PhalApi\DI();

// 环境变量是否必须
$di->dotenv->required('DATABASE_DSN');

// 或使用数组判断是否必须
$di->dotenv->required(['DB_HOST', 'DB_NAME', 'DB_USER', 'DB_PASS']);
```

如果需要使用其他文件名，例如：```.env.prod```文件，可以这样指定：  
```php
$di->dotenv = Dotenv\Dotenv::createImmutable(API_ROOT, '.env.prod');
```
或动态拼接：  
```php
$di->dotenv = Dotenv\Dotenv::createImmutable(API_ROOT, '.env.' . API_MODE);
```

更多用法和详细文档，请见[PHP dotenv](https://github.com/vlucas/phpdotenv)。  


