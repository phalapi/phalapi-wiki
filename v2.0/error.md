# PHP异常和错误处理

## 抛出异常
如果你需要抛出异常，针对客户端的非法请求，可以使用：  

```php
// 对应接口返回 ret = 400
throw new \PhalApi\Exception\BadRequestException('非法请求，缺少必要参数');

// 对应接口返回 ret = 401
throw new \PhalApi\Exception\BadRequestException('无权访问，身份校验失败', 1);
```

如果需要抛出服务器内部的逻辑异常，可以使用：  
```php
// 对应接口返回  ret = 500
throw new \PhalApi\Exception\InternalServerErrorException('数据库无法连接');

// 对应接口返回  ret = 599
throw new \PhalApi\Exception\InternalServerErrorException('接口次数余额不足', 99);
```

你也可以先use后使用，例如：  
```php
<?php
use PhalApi\Exception\BadRequestException; // 客户端非法请求
use PhalApi\Exception\InternalServerErrorException; // 服务器内部错误

throw new BadRequestException('非法请求，缺少必要参数');
throw new InternalServerErrorException('数据库无法连接');
```

> 温馨提示：只有继承于```PhalApi\Exception```的异常子类，在抛出时才会被PhalApi框架自动处理和转换成接口的失败返回。其他异常抛出需要程序自主捕捉处理。

## PhalApi的错误处理
> 自PhalApi 2.12.3 及以上版本提供错误处理。

在./config/di.php文件注册：
```php
$di->error = new \PhalApi\Error\ApiError();
```

在这背后，会：  
 + 1、通过set_error_handler()注册用户错误处理函数
 + 2、通过register_shutdown_function()处理PHP致命错误

主要处理方式，是将相关的警告、错误、和提醒信息纪录到文件日志。  

## 用户错误的处理效果

故意编写使用一个不存在的变量的代码。  
```php
<?php
namespace App\Api;
use PhalApi\Api;

class Site extends Api {
    public function index() {
        // 变量未声明
        $abc = $xyz;

        return array(
            'title' => 'Hello ' . $this->username,
            'version' => PHALAPI_VERSION,
            'time' => $_SERVER['REQUEST_TIME'],
        );
    }
}
```

请求接口：  
```
http://dev.phalapi.net/?s=App.Site.Index
```

不影响接口正常返回，会在背后产生以下日志。  
```
$ tail -f ./runtime/log/202003/notice_20200326.log 
2020-03-26 10:14:06|NOTICE|Notice(8)：Undefined variable: xyz [文件：/Users/dogstar/projects/github/phalapi/src/app/Api/Site.php，行号：29，时间：1585188846]
```

## PHP致命错误的处理效果

故意使用一个不存在的类。  

```php
<?php
namespace App\Api;
use PhalApi\Api;

class Site extends Api {
    public function index() {
        // 致命错误
        $ufo = new UFO();

        return array(
            'title' => 'Hello ' . $this->username,
            'version' => PHALAPI_VERSION,
            'time' => $_SERVER['REQUEST_TIME'],
        );
    }
}
```

请求接口：  
```
http://dev.phalapi.net/?s=App.Site.Index
```

错误和原来的一样，同时在背后产生以下日志。  
```
$ tail -f ./runtime/log/202003/error_20200326.log
2020-03-26 10:10:40|ERROR|Error(1)：Uncaught Error: Class 'App\Api\UFO' not found in /Users/dogstar/projects/github/phalapi/src/app/Api/Site.php:32\nStack trace:\n#0 [internal function]: App\Api\Site->index()\n#1 /Users/dogstar/projects/github/phalapi/vendor/phalapi/kernal/src/PhalApi.php(53): call_user_func(Array)\n#2 /Users/dogstar/projects/github/phalapi/public/index.php(9): PhalApi\PhalApi->response()\n#3 {main}\n  thrown [文件：/Users/dogstar/projects/github/phalapi/src/app/Api/Site.php，行号：32，时间：1585188640]
```

## 错误日志文件分类

针对用户级别和错误以及PHP致命错误，会最终写入到以下几类日志文件。  

 + **error_** 日志文件前缀：致命错误，例如语法错误、用户错误等
 + **warning_** 日志文件前缀：警告
 + **notice_** 日志文件前缀：提示，例如变量或下标不存在
 + **strict_** 日志文件前缀：严格模式下的错误
 + **deprecated_** 日志文件前缀：弃用

例如；
```
$ ll ./runtime/log/202003/
-rwxrwxrwx  1 _www  staff   2.7K  3 26 09:06 20200326.log
-rwxrwxrwx  1 _www  staff   7.0K  3 26 10:14 error_20200326.log
-rwxrwxrwx  1 _www  staff   2.2K  3 26 10:14 notice_20200326.log
```

## 调整错误日志目录

如果还是想使用文件日志纪录，但需要调整日志目录位置，可以重载```PhalApi\Error\ApiError::getLogger($type)```方法。例如： 

```php
class MyError extends ApiError {
    protected function getLogger($type) {
        if (!isset($this->loggers[$type])) {
            $config = \PhalApi\DI()->config->get('sys.file_logger');

            $config['log_folder'] = '/var/logs/runtime'; // 调整错误日志的目录，确保需要有写入权限

            $config['file_prefix'] = lcfirst($type);
            $this->loggers[$type] = FileLogger::create($config);
        }
        return $this->loggers[$type];
    }
}
```

最后，重新注册。  


## 定制你的错误处理
错误处理接口：  
```php
<?php
namespace PhalApi;

/**
 * 错误类
 *
 * @package     PhalApi\Error
 * @license     http://www.phalapi.net/license GPL 协议 GPL 协议
 * @link        http://www.phalapi.net/
 * @author      dogstar <chanzonghuang@gmail.com> 2020-03-25
 */
interface Error {

    /**
     * 自定义的错误处理函数
     * @param int $errno 包含了错误的级别，是一个 integer
     * @param string $errstr 包含了错误的信息，是一个 string
     * @param string $errfile 可选的，包含了发生错误的文件名，是一个 string
     * @param int $errline 可选项，包含了错误发生的行号，是一个 integer
     */
    public function handleError($errno, $errstr, $errfile = '', $errline = 0);
}
```

可参考```PhalApi\Error\ApiError```，定制你的错误处理。  

例如将错误收集到数据库。  
```php
<?php
namespace App\Common;

use PhalApi\Error\ApiError;

class MyError extends ApiError {
    /**
     * 上报错误
     * @param array $context
     */
    protected function reportError($context) {
        // 纪录到数据库
    }
}
```

其中```$context```参数是一个数组，下标有：  
 + error：错误类型，有：Error、Warning、Notice、Strict、Deprecated
 + errno：错误值，整数，PHP定义的错误，包含了错误的级别，是一个 integer
 + errstr：包含了错误的信息，是一个 string
 + errfile：包含了发生错误的文件名，是一个 string
 + errline：包含了错误发生的行号，是一个 integer
 + time: 当时时间戳  


最后，重新注册DI的error服务。  
```php
// 错误处理
$di->error = new App\Common\MyError();
```

