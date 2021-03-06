# API Response and Online Debug


For API response, PhalApi uses HTTP + JSON by default. Communicate through the HTTP / HTTPS protocol, and the returning results are transferred in JSON format. Under normal circumstances, when the API service responds normally, as in the previous "Hello World" API, you may see the following response header information and returning content.

```html
HTTP/1.1 200 OK
Content-Type: application/json;charset=utf-8

... ...

{"ret":200,"data":{"title":"Hello World!"},"msg":""}
```

When the API project throws an uncaught exception, or Error occurs due to PHP syntax problems, no content is returning and a 500 response status code is obtained. Similar as follows:

```
HTTP/1.1 500 Internal Server Error
```

## Response Structure: data-ret-msg

Recall what the default API service returns. Similar as follows:
```html
{
    "ret": 200,
    "data": {
        "title": "Hello World!",
        "content": "Hello PHPer, Welcome to PhalApi! ",
        "version": "2.0.0",
        "time": 1499477583
    },
    "msg": ""
}
```
The “ret” field is the returning status code, 200 indicates success; the "data" field is the business data provided by the project, defined by the interface developer; "msg" is the error prompt information under abnormal conditions. Will introduce separately below.

 + data: Business data, recommended object type, can return any type of data to the client
 + ret: Status code, integer, 200 means success, 4xx means illegal request from client, 5xx means server error, other values can be customized (may be string type in debug mode)
 + msg: Message, string

### Business Data: data

The business data "data" is the data part that the API and the client mainly communicate with each other. It can be of any type and defined by the API developer. However, for better extension and backward compatibility, it is recommended to use the extensible collection form instead of the native type. That is to say, an array should be returned, not the basic types of integer, boolean, and string.


The business data is mainly returned in the Api layer, the returning result of the method corresponding to the API class. As the implementation code of the following default interface service ```?s=Site.Index```.

```php
<?php
namespace App\Api;

use PhalApi\Api;

class Site extends Api {

    public function index() {
        return array(
            'title' => 'Hello World!',
            'content' => \PhalApi\T('Hi {name}, welcome to use PhalApi!', array('name' => $this->username)),
            'version' => PHALAPI_VERSION,
            'time' => $_SERVER['REQUEST_TIME'],
        );
    }
```

In fact, the specific business data requires a complex period of processing to meet the needs of a specific business scenario. The Api layer needs to work together with the Domain layer and the Model layer to complete the specified function. For now, we know that the API result is returned in the Api layer, and the result returned by the member method of the corresponding API class is sufficient.

Again, it is recommended that business data returning Object to the client for future scalability. The following are some examples:
```
# (Not recommended) Directly return the basic type data(eg: string) 
{"ret":200,"data":"Hello ","msg":""}

# (Not recommended) Return data type
{"ret":200,"data":["Hello "],"msg":""}

# (Recommended) Return Object type data
{"ret":200,"data":{"content":"Hello "},"msg":""}
``` 

### Returning Status Code: ret

Returns the status code "ret", used to indicate the status of the API response. With reference to the status code from HTTP, ret is mainly divided into four categories: Normal Response, Redirection, Illegal Request, and Server Error.

Category|Range of ret|Basic value|Describution
---|---|---|---
Normal Response|200～299|200|Indicates that the API service responding normally
Redirection|300～399|300|表示重定向, 对应异常类[PhalApi\Exception\RedirectException](https://github.com/phalapi/kernal/blob/master/src/Exception/RedirectException.php)的异常码
Illegal Request|400～499|400|表示客户端请求非法, 对应异常类[PhalApi\Exception\BadRequestException](https://github.com/phalapi/kernal/blob/master/src/Exception/BadRequestException.php)的异常码
Server Error|500～599|500|表示服务器内容错误, 对应异常类[PhalApi\Exception\InternalServerErrorException](https://github.com/phalapi/kernal/blob/master/src/Exception/InternalServerErrorException.php)的异常码


正常响应时, 通常返回ret = 200, 并且同时返回data部分的业务数据, 以便客户端能实现所需要的业务功能.   

值得注意的是, 抛出的异常应该继承于[PhalApi\Exception](https://github.com/phalapi/kernal/blob/master/src/Exception.php)类, 并且构造函数的第一个参数, 是返回给客户端的错误提示信息, 对应下面将讲到的msg字段. 第二个参数是返回状态码的**叠加值**, 也就是说最终的ret状态码都会在400的基数上加上这个叠加值, 即: 401 = 400 + 1.   

例如, 常见地, 当签名失败时可以返回一个401错误, 并提示“签名失败”.   
```php
<?php
namespace App\Api;

use PhalApi\Api;
use PhalApi\Exception\BadRequestException;

class Hello extends Api {

    public function fail() {
        throw new BadRequestException('签名失败', 1);
    }
}
```

会得到以下结果输出:   
```
{
    "ret": 401,
    "data": [],
    "msg": "Bad Request: 签名失败"
}
```

> 注意: ret在调试模式下可能是字符串类型, 因为Exception 返回整型（integer）的异常代码, 但在其他类中可能返回其他类型(比如在 PDOException 中返回 string). 参考自PHP官方手册[PHP: Exception::getCode - Manual](https://www.php.net/manual/zh/exception.getcode.php).   

例如出现PDOException异常时, 调试模式下返回的ret为非整型的结果:   
```
{
    "ret": "42S02",
    "data": {},
    "msg": "SQLSTATE[42S02]: Base table or view not found: 1146 Table 'phalapi.phalapi_curd' doesn't exist",
    "debug": {
        "exception": [
        ]
    }
}
```
### Error Message: msg

当接口不是正常响应, 即ret不在2XX系列内时, msg字段会返回相应的错误提示信息. 即当有异常触发时, 会自动将异常的错误信息作为错误信息msg返回.   

## How to configure Header output？  

如果需要设置响应的header, 可以通过```\PhalApi\DI()->response->addHeaders($key, $content)```接口进行设置, 其中:   
 + 第一个参数$key, 表示头的名称
 + 第二个参数$content, 表示内容

头信息重复时以最后的为准. 例如当需要设置允许跨域时, 可以在./config/di.php后面的位置添加以下代码:   
```php
// 允许跨域
$response = \PhalApi\DI()->response;
$response->addHeaders('Access-Control-Allow-Origin', '*'); // *代表允许任何网址请求
// $response->addHeaders('Access-Control-Allow-Origin', 'www.phalapi.net'); // 推荐指定网站
$response->addHeaders('Access-Control-Allow-Methods', 'POST,GET,OPTIONS,DELETE'); // 允许请求的类型
$response->addHeaders('Access-Control-Allow-Credentials', 'true'); // 设置是否允许发送 cookies
$response->addHeaders('Access-Control-Allow-Headers', 'Content-Type,Content-Length,Accept-Encoding,X-Requested-with, Origin'); // 设置允许自定义请求头的字段
```

其中, 需要注意, Nginx还需要添加以下配置, 以便允许OPTION跨域请求.   
```
# 跨域
location / {
    if ($request_method = 'OPTIONS') {
        add_header Access-Control-Allow-Origin *;
        add_header Access-Control-Allow-Methods 'GET, POST, OPTIONS, DELETE';
        add_header Access-Control-Allow-Headers 'DNT,X-Mx-ReqToken,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Authorization';
        return 204;
    }
}

```

## How to configure JSON Chinese format output?

默认情况下, 输出的中文会被转换成Unicode, 形如```\uXXXX```, 如: 
```
"content":"PHPer\u60a8\u597d\uff0c\u6b22\u8fce\u4f7f\u7528PhalApi\uff01"
```

虽然不影响使用, 但不便于查看. 如果需要不被转码, 可以使用[JSON_UNESCAPED_UNICODE](http://php.net/manual/en/json.constants.php)选项进行配置. 重新注册```DI()->response```并指定配置选项. 例如可以: 

```php
$di->response = new \PhalApi\Response\JsonResponse(JSON_UNESCAPED_UNICODE); // 中文显示
```

设置后, 重新请求, 将会看到: 
```
"content":"PHPer您好, 欢迎使用PhalApi! "
```

类似地, 还可以设置更多其他的选项, 如追加强制使用对象格式: 
```php
$di->response = new \PhalApi\Response\JsonResponse(JSON_UNESCAPED_UNICODE | JSON_FORCE_OBJECT); // 中文显示 且 强制对象格式
```

> 特别注意: data的全部业务数据必须是UTF-8编码, 才能正常JSON编码并输出. 

## Extension: How to use other returning formats?

除了使用JSON格式返回外, 还可以使用其他格式返回结果.   

例如在部分H5混合应用页面进行异步请求的情况下, 客户端需要服务端返回JSONP格式的结果, 则可以这样在DI配置文件./config/di.php中去掉以下注释.   
```php
// 支持JsonP的返回
if (!empty($_GET['callback'])) {
    $di->response = new \PhalApi\Response\JsonpResponse($_GET['callback']);
}
```

目前, PhalApi 2.x 已经支持的响应格式有:   

响应格式|实现类
---|---
JSON格式|[PhalApi\Response\JsonResponse](https://github.com/phalapi/kernal/blob/master/src/Response/JsonResponse.php)
JSONP格式|[PhalApi\Response\JsonpResponse](https://github.com/phalapi/kernal/blob/master/src/Response/JsonpResponse.php)
XML格式|[PhalApi\Response\XmlResponse](https://github.com/phalapi/kernal/blob/master/src/Response/XmlResponse.php)
控制台格式|[PhalApi\Response\ExplorerResponse](https://github.com/phalapi/kernal/blob/master/src/Response/ExplorerResponse.php)

以下代码片段演示了如何使用其他默认的返回格式, 在./config/di.php文件中重新注册response服务即可实现不同返回格式的切换.   
```php
// 支持JsonP的返回
if (!empty($_GET['callback'])) {
    $di->response = new \PhalApi\Response\JsonpResponse($_GET['callback']);
}
// 效果, 请求: /?s=App.Hello.World&callback=test
// test({"ret":200,"data":{"content":"Hello "},"msg":""})

// 返回XML格式
$di->response = new PhalApi\Response\XmlResponse();
// 效果
// <?xml version="1.0" encoding="utf-8"?><xml><ret><![CDATA[200]]></ret><data><content><![CDATA[Hello ]]></content></data><msg><![CDATA[]]></msg></xml>
```

当需要返回一种当前PhalApi没提供的格式, 需要返回其他格式时, 可以:   

 + 1、实现抽象方法[PhalApi\Response::formatResult($result)](https://github.com/phalapi/kernal/blob/master/src/Response.php)并返回格式化后结果
 + 2、在./config/di.php文件中重新注册```\PhalApi\DI()->response```服务

## How to modify ret/data/msg fields?

默认情况下, PhalApi接口框架在顶层的返回字段使用ret/data/msg结构, 如果需要使用其他字段, 可修改```sys.response.structure_map```映射配置, 例如打开./config/sys.php文件修改:   
```php
    /**
     * 返回结果
     */
    'response' => array(
        'structure_map' => array( // 返回结构字段映射配置
            'ret'   => 'err_status',
            'data'  => 'result',
            'msg'   => 'err_message',
            'debug' => 'debug',
            ),
        ),
```
即可以把全部接口返回的结果字段进行映射调整, 调整后接口返回示例是:   
```
{
    "err_status": 200,
    "result": {
        "title": "Hello PhalApi",
        "version": "2.10.1",
        "time": 1582176767
    },
    "err_message": ""
}
```

> 温馨提示: PhalApi 2.11.0 及以上版本, 方可支持```sys.response.structure_map```映射配置. 

## Online Debugging

### Turn on Debugging Mode

开启调试模式很简单, 主要有两种方式:   

 + **单次请求开启调试**: 默认添加请求参数```&__debug__=1```  
 + **全部请求开启调试**: 把配置文件```./config/sys.php```文件中的配置改成```'debug' => true,```  
  
## What are the debugging information?
  
正常响应的情况下, 当开启调试模式后, 会返回多一个```debug```字段, 里面有相关的调试信息. 如下所示:   
```
{
    "ret": 200,
    "data": {
    },
    "msg": "",
    "debug": {
        "stack": [  // 自定义埋点信息
        ],
        "sqls": [  // 全部执行的SQL语句
        ],
        version "2.10.1" // PhalApi框架当前版本号
    }
}
```
> 温馨提示: 调试信息仅当在开启调试模式后, 才会返回并显示.   

在发生未能捕捉的异常时, 并且开启调试模式后, 会将发生的异常转换为对应的结果按结果格式返回, 即其结构会变成以下这样:   
```
{
    "ret": 0,  // 异常时的错误码
    "data": {},
    "msg": "", // 异常时的错误信息
    "debug": {
        "exception": [  // 异常时的详细堆栈信息
        ],
        "stack": [  // 自定义埋点信息
        ],
        "sqls": [  // 全部执行的SQL语句
        ],
        version "2.10.1" // PhalApi框架当前版本号
    }
}
```

### **View all executed SQL statements**  
 
debug.sqls中会显示所执行的全部SQL语句, 由框架自动搜集并统计. 最后显示的信息格式是:   
```
[序号 - 当前SQL的执行时间ms]所执行的SQL语句及参数列表
```
示例:   
```
[1 - 0.32ms]SELECT * FROM tbl_user WHERE (id = ?); -- 1
```
表示是第一条执行的SQL语句, 消耗了0.32毫秒, SQL语句是```SELECT * FROM tbl_user WHERE (id = ?);```, 其中参数是1.   

自从PhalApi 2.7.0 版本后, 我们对调试的SQL语句进行升级, 提供了更多调试信息. 新版的格式是: 
```
[序号 - 当前SQL的执行时间ms - SQL]执行的PHP文件路径(行号):    执行的PHP类名和方法名   数据库表名    所执行的SQL语句及参数列表
```

例如这个例子: 
```
[#1 - 4.03ms - SQL]/path/to/phalapi/src/app/Api/Examples/CURD.php(147):    App\\Api\\Examples\\CURD::sqlDebug()    phalapi_curd    SELECT * FROM phalapi_curd WHERE (id = 1) LIMIT 1;
```

从左到右, 依次表示的信息是: 

 + 1、在什么地方（代码位置）
 + 2、哪个类哪个方法（操作对象）
 + 3、对哪个数据库表
 + 4、进行了什么数据库操作（SQL语句和参数列表）


### **查看自定义埋点信息**   
 
debug.stack中埋点信息的格式如下:   
```
[#序号 - 距离最初节点的执行时间ms - 节点标识]代码文件路径(文件行号)
```
示例:   
```
[#0 - 0ms]/path/to/phalapi/public/index.php(6)
```
表示, 这是第一个埋点（由框架自行添加）, 执行时间为0毫秒, 所在位置是文件```/path/to/phalapi/public/index.php```的第6行. 即第一条的埋点发生在框架初始化时. 

与SQL语句的调试信息不同的是, 自定义埋点则需要开发人员根据需要自行纪录, 可以使用全球追踪器```PhalApi\DI()->tracer```进行纪录, 其使用如下:   
```php
// 添加纪录埋点
PhalApi\DI()->tracer->mark();

// 添加纪录埋点, 并指定节点标识
PhalApi\DI()->tracer->mark('DO_SOMETHING');
```

调试模式下接口返回效果类似: 
```
{
    "ret": 200,
    "data": {
        "content": "Hello"
    },
    "msg": "",
    "debug": {
        "stack": [
            "[#1 - 0ms - PHALAPI_INIT]/Users/dogstar/projects/tmp/phalapi/public/index.php(6)",
            "[#2 - 0.2ms - PHALAPI_RESPONSE]/Users/dogstar/projects/tmp/phalapi/vendor/phalapi/kernal/src/PhalApi.php(46)",
            "[#3 - 0.5ms - DO_SOMETHING]/Users/dogstar/projects/tmp/phalapi/src/app/Api/Hello.php(24)",
            "[#4 - 0.5ms - PHALAPI_FINISH]/Users/dogstar/projects/tmp/phalapi/vendor/phalapi/kernal/src/PhalApi.php(74)"
        ],
        "sqls": [],
        "version": "2.10.1"
    }
}
```

通过上面方法, 可以对执行经过的路径作标记. 你可以指定节点标识, 也可以不指定. 对一些复杂的接口, 可以在业务代码中添加这样的埋点, 追踪接口的响应时间, 以便进一步优化性能. 当然, 更专业的性能分析工具推荐使用XHprof.   
> 参考: 用于性能分析的[XHprof扩展类库](http://git.oschina.net/dogstar/PhalApi-Library/tree/master/Xhprof).   

### **查看异常堆栈信息**  

当有未能捕捉的接口异常时, 开启调试模式后, 框架会把对应的异常转换成对应的返回结果, 并在debug.exception中体现. 而不是像正常情况直接500, 页面空白. 这些都是由框架自动处理的.   
  
例如, 让我们故意制造一些麻烦, 手动抛出一个异常.   
```php
<?php
namespace App\Api;
use PhalApi\Api;
class Hello extends Api {

    public function fail() {
        throw new \Exception('这是一个演示异常调试的示例', 501);
    }
}
```

再次请求后, 除了SQL语句和自定义埋点信息外, 还会看到这样的异常堆栈信息. 然后便可根据返回的异常信息进行排查定位问题.   

```
{
    "ret": 501,
    "data": {},
    "msg": "这是一个演示异常调试的示例",
    "debug": {
        "exception": [
        {
            "function": "world",
            "class": "App\\Api\\Hello",
            "type": "->",
            "args": []
        },
        {
            "file": "/Users/dogstar/projects/tmp/phalapi/vendor/phalapi/kernal/src/PhalApi.php",
            "line": 53,
            "function": "call_user_func",
            "args": [
                [
                {
                    "username": null
                },
            "World"
                ]
                ]
        },
        {
            "file": "/Users/dogstar/projects/tmp/phalapi/public/index.php",
            "line": 9,
            "function": "response",
            "class": "PhalApi\\PhalApi",
            "type": "->",
            "args": []
        }
        ],
            "stack": [
                "[#1 - 0ms - PHALAPI_INIT]/Users/dogstar/projects/tmp/phalapi/public/index.php(6)",
            "[#2 - 0.2ms - PHALAPI_RESPONSE]/Users/dogstar/projects/tmp/phalapi/vendor/phalapi/kernal/src/PhalApi.php(46)",
            "[#3 - 1.9ms - PHALAPI_FINISH]/Users/dogstar/projects/tmp/phalapi/vendor/phalapi/kernal/src/PhalApi.php(74)"
                ],
            "sqls": [],
            "version": "2.10.1"
    }
}
```
### **添加自定义调试信息**

当需要添加其他调试信息时, 可以使用```PhalApi\DI()->response->setDebug()```进行添加.   
  
如:  
```php
class Hello extends Api {

    public function fail() {
        $x = 'this is x';
        $y = array('this is y');
        \PhalApi\DI()->response->setDebug('x', $x);
        \PhalApi\DI()->response->setDebug('y', $y);
    }
}
```

请求后, 可以看到:   
```
    "debug": {
        "x": "this is x",
        "y": [
            "this is y"
        ]
    }
```

## Recommendation: Assisted Debugging Convention

PhalApi框架, 可以集成众多扩展类库. 当涉及多个开发者、多个开发团队, 以及多个项目时, 集成到PhalApi后, 除了传统方式将调试信息写到日志外和直接输出到屏幕外, 我们现在有了一种全新的协助性调试方式. 

如前面介绍, 可以添加自定义调试信息. 在追加调试信息时, 我们推荐约定, 每个项目或扩展类库统一采用以下方式: 

 + 统一使用前缀

统一使用前缀, 是指在setDebug()时, 对于变量名统一添加前缀, 以区分不同的项目.  

例如, 对于XXX扩展, 可以: 

```php
\PhalApi\DI()->response->setDebug('XXX_var', $var);

// 其他代码……

\PhalApi\DI()->response->setDebug('XXX_arr', $arr);
```

这样, XXX扩展就添加了两个调试变量. 

同时, 对于YYY扩展, 可以: 

```php
\PhalApi\DI()->response->setDebug('YYY_var', $var);

// 其他代码……

\PhalApi\DI()->response->setDebug('YYY_arr', $arr);
```

这样, YYY扩展就添加了两个调试变量. 

通过添加前缀, 既可以明显区分不同的项目、扩展、模块和功能, 又不会冲突覆盖. 
