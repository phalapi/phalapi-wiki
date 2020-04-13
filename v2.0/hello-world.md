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

Under normal circumstances, it is recommended that the accessible root path be set to /path/to/PhalApi2/public. If the root directory is not set as 'public' folder, then the URL format for API access is:```WebDomain/public/?s=Namespace.Class.Action```. The s parameter is used to specify the interface service to be requested, and consists of three parts. They are:  

Component|Required|Defaults|Explanation
---|---|---|---
Namespace|No|App|Api Namespace prefix, underlined when multi-level Namespace, the default Namespace is App
Class|Yes|Nil|The name of the interface class to be requested, usually with an initial capital letter, and multiple directories with underscores
Action|Yes|Nil|The name of the interface class method to be requested, usually with an initial capital letter. If neither Class nor Action is specified, the default is 'Site.Index'

> Tips: s parameter is the abbreviation of service, ```?s=Class.Action``` equals to ```?service=Class.Action```, When both exist, the service parameter is used first.

For example, the access link for the 'Hello World' API added above is:
```
http://dev.phalapi.net/?s=Hello.World
```

Or you can use the complete wording, bring the namespace App:
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
