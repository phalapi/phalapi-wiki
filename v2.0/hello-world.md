# "Hello World"

This article assumes that you have successfully installed the PhalApi 2.x project, if not, you can read[Download and Installation](download-and-setup).

## Write an API

In the PhalApi 2.x version, the project source code is placed in the /path/to/PhalApi2/src directory. Each namespace corresponds to a subdirectory, the default namespace is App, and there are three subdirectory:  Api, Domain, and Model. The directory and the functions.php file for storing functions. For example, the directory structure looks like this:

```bash
./src/
└── app
    ├── Api # Place the API source code, equivalent to the View layer
    ├── Common # Public code directory, placement tools, etc.
    ├── Domain # Domain business layer, responsible for business logic and processing, equivalent to the Controller layer
    ├── functions.php
    └── Model # Data source layer, responsible for data persistent storage and operation, equivalent to the Model layer
```

When you need to add a new API, you must first add a new API file in the Api layer. For example, for the "Hello World" example, you can use your favorite editor to create a ./src/app/Api/Hello.php file, and write the code like below.
```php
// File ./src/app/Api/Hello.php
  1 <?php
  2 namespace App\Api;
  3 
  4 use PhalApi\Api;
  5 
  6 /**
  7  * My first API
  8  */
  9 class Hello extends Api {
 10 
 11     public function getRules() {
 12         return array(
 13             'world' => array(
 14                 'username' => array('name' => 'username', 'desc' => 'website username'),
 15             ),
 16         );
 17     }
 18 
 19     /**
 20      * API name - Welcome
 21      * @desc Welcome to my website, bilibili!!
 22      */
 23     public function world() {
 24         return array('content' => 'Hello ' . $this->username);
 25     }
 26 }
```

When writing an API, special attention is required:

 + 1、The default Namespace must be```App\Api``` (Line 2)
 + 2、The specific implemented interface class must be the subclass of ```PhalApi\Api```（Line 4, Line 9）
 + 3、The method of defining an API Class must be public（Line 23）
 + 4、Place all the API parameters in the getRules () function（Line 11）
 + 5、It is recommended to returen the Object structure when returning data, easy to expand （Line 24）

 ## Access an API

 通常情况下, 建议可访问的根路径设为/path/to/PhalApi2/public.若未设置根目录为public目录, 此时接口访问的URL格式为：```接口域名/public/?s=Namespace.Class.Action```.其中, s参数用于指定待请求的接口服务, 由三部分组成.分别是：    

组成部分|是否必须|默认值|说明
---|---|---|---
Namespace|可选|App|Api命名空间前缀, 多级命名空间时用下划线分割, 缺省命名空间为App
Class|必须|无|待请求的接口类名, 通常首字母大写, 多个目录时用下划线分割
Action|必须|无|待请求的接口类方法名, 通常首字母大写.若Class和Action均未指定时, 默认为Site.Index

> 温馨提示：s参数为service参数的缩写, 即使用```?s=Class.Action```等效于```?service=Class.Action```, 两者都存在时优先使用service参数.

例如, 上面新增的Hello World接口的访问链接为：  
```
http://dev.phalapi.net/?s=Hello.World
```

或者可以使用完整的写法, 带上命名空间App：  
```
http://dev.phalapi.net/?s=App.Hello.World
```

## API Return

By default, the returning result of the API is in JSON format, and the top-level fields return code 'ret', business data 'data', and error message 'msg'. The 'data' field corresponds to the result returned by the API class method. As in the 'Hello Wolrd' example, returning result is:
<!-- 默认情况下, 接口的结果以JSON格式返回, 并且返回的顶级字段有状态码ret、业务数据data, 和错误提示信息msg.其中data字段对应接口类方法返回的结果.如Hello Wolrd示例中, 返回的结果是：   -->
```
{"ret":200,"data":{"title":"Hello World!"},"msg":""}
```

After JSON visualization, it is: 
```
{
    "ret": 200,
    "data": {
        "title": "Hello World!"
    },
    "msg": ""
}
```


#### Congratulations! You have completed a simple API development of PhalApi 2.x by the way!
