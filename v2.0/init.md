# 初始化

# PHP-FPM请求下的初始化

对应通过HTTP/HTTPS访问的入口是 ./public/index.php文件。  

# 框架的初始化

PhalApi框架的初始化文件是./public/init.php，包括API、CLI、计划任务等都会加载此文件。


默认情况下，框架进行的初始化如下：

```php
<?php
/**
 * 统一初始化
 */
// 定义项目路径
defined('API_ROOT') || define('API_ROOT', dirname(__FILE__) . '/..');

// 运行模式，可以是：dev, test, prod
defined('API_MODE') || define('API_MODE', 'prod'); 

// 引入composer
require_once API_ROOT . '/vendor/autoload.php';

// 时区设置
date_default_timezone_set('Asia/Shanghai');

// 引入DI服务
include API_ROOT . '/config/di.php';

// 调试模式
if (\PhalApi\DI()->debug) {
    // 启动追踪器
    \PhalApi\DI()->tracer->mark('PHALAPI_INIT');
    error_reporting(E_ALL);
    ini_set('display_errors', 'On'); 
}

// 翻译语言包设定
\PhalApi\SL('zh_cn');
```

两个宏定义：  
 + API_ROOT，表示当前接口项目的根路径，指向PhalApi项目根路径
 + API_MODE，表示当前接口运行的模式，可以是：dev, test, prod，非生产模式时会优先加载当前模式的配置

# 应用初始化

如果应用有额外需要进行初始化的，例如添加全局宏变量，可以在此添加。例如：

```php
<?php
/**
 * 统一初始化
 */
// 定义项目路径
defined('API_ROOT') || define('API_ROOT', dirname(__FILE__) . '/..');

defined('API_PROJECT_NAME') || define('API_PROJECT_NAME', '我的项目名称'); // 应用初始化
```

# DI服务初始化

DI服务的注册和加载，在./config/di.php文件。  

# 公共函数初始化

对于命名空间下的公共函数，在./src/app/functions.php文件。其中```app```可以对应自己需要用到的全名空间。  

# 环境变量的初始化

对应根目录下的隐藏文件 ./.env ，如果没有此文件，可以自己新建一个空白文件。放置类似以下的ENV环境变量：  

```
PHALAPI_DB_TYPE="mysql"
PHALAPI_DB_HOST="127.0.0.1"
PHALAPI_DB_NAME="phalapi"
PHALAPI_DB_USER="dogstar"
PHALAPI_DB_PASSWORD="123"
PHALAPI_DB_PORT="3306"
PHALAPI_DB_CHARSET="UTF8"
```  


