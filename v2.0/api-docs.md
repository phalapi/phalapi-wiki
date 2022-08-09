# 接口文档


## 在线接口文档

PhalApi提供一些非常实用而又贴心的功能特性，其中最具特色的就是自动生成的在线可视化文档。在线接口文档主要分为两大类，分别是：  

 + 在线接口列表文档
 + 在线接口详情文档

当客户端不知道有哪些接口服务，或者需要查看某个接口服务的说明时，可借助此在线接口文档。访问在线接口列表文档的URL是：  
```
http://dev.phalapi.net/docs.php
```

打开后，便可看到类似下面这样的在线接口文档。  
![](http://cdn7.phalapi.net/20170701174008_d80a8df4f918dc063163a9d730ceaf32)  

此在线文档是实时生成的，可根据接口源代码以及注释自动生成。当有新增接口服务时，刷新后便可立即看到效果。通过在接口列表文档，可点击进入相应的接口详情文档页面。  

> 温馨提示：如果打开在线文档，未显示任何接口服务，请确保服务环境是否已关闭PHP的opcache缓存。  

## 项目名称与文档查看密码

修改./public/docs.php文件里面的：  
```php
$projectName = 'PhalApi开源接口框架';
$docViewCode = ''; // 查看文档密码，为空时不限制
```
可以修改项目名称，以及文档查看密码。  

文档查看密码可以限制游客查看接口文档，为空时不限制，设置密码后需要输入文档查看密码方可浏览在线接口文档。效果如下：  
![](http://cd8.yesapi.net/yesyesapi_20200413092820_23af88be4a214167876f1446fbcc26f5.png)

> 温馨提示：文档查看密码需要PhalApi 2.1.4 及以上版本支持。   

## 代码、注释与接口文档

PhalApi提供了自动生成的在线接口文档，对于每一个接口服务，都有对应的在线接口详情文档。如默认接口服务```Site.Index```的在线接口详情文档为：  

![](http://cdn7.phalapi.net/20170716165631_4936f1cf60b99f5f830b4967769cf35b)  

此在线接口详情文档，从上到下，依次说明如下。  

### 接口项目名称
首先，通过根目录下的composer.json文件里面的autoload内psr-4配置，找到项目对应的命名空间名称，例如：
```
    "autoload": {
        "psr-4": {
            "App\\": "src/app"
        }
    }
```
然后，修改./language/zh_cn/common.ph翻译文件，把命名空间的类名改成中文项目名称。如：  
```php
return array(
    "App" => '我的项目',
);
```
刷新接口文档列表页，效果如下：
![](http://cd8.yesapi.net/yesyesapi_20200218153205_85a7edf32fa4db8d719845e3aca334e4.png)


### 接口服务名称

接口服务名称是指用于请求时的名称，对应s参数（或service参数）。接口服务的中文名称，为不带任何注解的注释，通常为接口类成员函数的第一行注释。  
```php
class Site extends Api {

    /**
     * 默认接口服务
     */
    public function index() {
    }
}
```

### 接口说明@desc

接口说明对应接口类成员函数的```@desc```注释，支持HTML格式。  

```php
class Site extends Api {

    /**
     * 默认接口服务
     * @desc 默认接口服务，当未指定接口服务时执行此接口服务
     */
    public function index() {
    }
}
```

> 温馨提示：@desc 注释支持HTML格式。

### 请求方式@method

HTTP/HTTPS协议的请求方式有以下8种方式：  

 + GET
 + HEAD
 + POST
 + PUT
 + DELETE
 + CONNECT
 + OPTIONS
 + TRACE

如果需要指定API请求的方式，例如只允许GET请求或只允许POST请求，或者允许多种请求方式，可以在接口方法的注释中使用```@method``` 注释。  

例如：
```php
<?php       
namespace App\Api\Examples;
use PhalApi\Api;

class CURD extends Api {
    /**
     * 更新数据
     * @desc 根据ID更新数据库中的一条纪录数据
     * @method POST
     * @return int code 更新的结果，1表示成功，0表示无更新，false表示失败
     */
    public function update() {
    }
}
```

上面通过```@method POST```指定了当前接口，只允许POST请求。  

添加注释后，在接口文档列表页，会显示请求方式为POST。如果请求方式为空，则表示无限制。  

![](http://cd8.yesapi.net/yesyesapi_20200930155046_2e916c804cea36a379969c494f5379ad.png)  

在接口文档详情页，也会标注为POST方式。  

![](http://cd8.yesapi.net/yesyesapi_20200930155146_2e4718a17e13e8d369355bd2b58bebb2.png)  

如果使用GET方式请求此接口，会提示请求错误，例如接口返回：  

```
{
    "ret": 404,
    "data": {},
    "msg": "非法请求：请求方式错误，仅支持：POST"
}
```

> 温馨提示：```@method``` 需要PhalApi 2.16.0及以上版本支持。如果需要允许指定的多种方式，可以使用空格隔开，例如：```@method POST GET```。  

### 接口版本@version

> 温馨提示：自PhalApi v2.18.0 及以上版本支持```@version```注解，用于描述接口版本号。 

接口版本的注解示例：  
```php
<?php
namespace App\Api\Examples;

use PhalApi\Api;

/**
 * 接口文档示例
 * @author dogstar 20220615
 */
class Docs extends Api {

    /**
     * 接口文档使用示例
     * @desc 接口说明，更多使用请参考官方文档<a target="_blank" href="http://docs.phalapi.net/#/v2.0/api-docs">http://docs.phalapi.net/#/v2.0/api-docs</a>
     * @method GET
     * @version 1.0
     * @return string content
     * @exception 406 未授权或权限不足
     */
    public function usage() {
        return array('content' => '演示返回字段');
    }
}
```

配置时，不需要在版本注解中添加前置v字母。在接口文档展示效果的如下，
![](http://cd8.okayapi.com/yesyesapi_20220711170756_a8d580b9bca2efbdc8e97a77af97db2f.png)  


### 接口参数

接口参数是根据接口类配置的参数规则自动生成，即对应当前接口类```getRules()```方法中的返回。其中最后的“说明” 字段对应参数规则中的desc选项，支持HTML格式。可以配置多个参数规则。此外，配置文件./config/app.php中的公共参数规则也会显示在此接口参数里。  

```php
class Site extends Api {

    public function getRules() {
        return array(
            'index' => array(
                'username'  => array('name' => 'username', 'default' => 'PHPer', ),
            ),
        );
    }
}
```

> 温馨提示：desc 配置项支持HTML格式。

### 接口返回结果@return

返回结果对应接口类成员函数的```@return```注释，可以有多组，格式为：```@return 返回类型 返回字段 说明```。其中，  
 + **返回类型**：支持string/array/object/int/float/boolean/date/enum
 + **返回字段**：返回结果的键名称，多个层级时使用英文点号连接。例如：```xxx.yyy```，特别地，数组类型使用方括号作为后缀，如```xxx[].yyy```
 + **说明**：返回结果字段的说明，支持HTML格式

```php
class Site extends Api {

    /**
     * 默认接口服务
     * @desc 默认接口服务，当未指定接口服务时执行此接口服务
     * @return string title 标题
     * @return string content 内容
     * @return string version 版本，格式：X.X.X
     * @return int time 当前时间戳
     */
    public function index() {
    }
}
```

> 温馨提示：返回字段说明支持HTML格式。

返回结果的组合顺序，依次由以下三部分构成：  
 + 第一部分：接口类基类的公共返回结果注释（多个基类时依次顺序叠加）
 + 第二部分：当前接口类的类注释里的公共返回结果注释
 + 第三部分：接口类成员函数的返回结果注释

## 客户端请求示例

为了方便客户端在未调用接口前也能了解接口的返回格式和示例，可以添加为每个接口服务添加相应的返回示例、同时，考虑到服务端维护的便易性，我们会对每个接口服务单独使用一个文件来存放。

### 客户端示例文件目录
默认情况下，返回示例文件存放在：

```
./src/view/docs/demos
```

### 支持的客户端示例

支持以下开发语言的示例，对应的文件后缀名是：  
 + ```.json```后缀：HTTP通用示例
 + ```.js```后缀：Javascript示例
 + ```.oc```后缀：Object-C示例
 + ```.java```后缀：Java示例
 + ```.curl```后缀：CURL示例
 + ```.php```后缀：PHP示例
 + ```.py```后缀：Python示例
 + ```.go```后缀：Golang示例
 + ```.cs```后缀：C#示例

示例文件名是：
```
接口服务名称 + 文件后缀名
```

另外，为了方便提取公共的代码示例头部和尾部代码，分别有：  
 + 统一示例头部文件名：```_prefix``` + 文件后缀名
 + 统一示例尾部文件名：```_suffix``` + 文件后缀名

如果有对应客户端开发语言的头部和尾部，在最终文档显示时会自动追加。


最后，为了动态获取当前的接口链接和接口服务名称，在代码示例模板中有以下动态变量：  
 + ```{url}```，表示当前接口链接地址，例如：```http://dev.phalapi.net/```
 + ```{s}```，表示当前接口服务名称，例如：```App.Site.Index```

如果示例模板中有写此动态变量，最终文档显示时会自动替换。

### 示例

例如：

```
./src/view/docs/demos/App.Site.Index.json
```

示例文件里可以放置返回给客户端的示例。如：
```
{
    "ret": 200,
    "data": {
        "title": "Hello PhalApi",
        "version": "2.7.0",
        "time": 1558489902
    },
    "msg": ""
}
```

最后，在线文档的展示效果是：

![](http://cd8.yesapi.net/yesyesapi_20200330114340_6e22156e2b9a248ddd81c77db7cf4210.png)

又如，对于PHP的客户端，可以分别配置头部、示例和尾部。  

PHP示例头部，文件：```./src/view/docs/demos/_prefix.php```，文件内容：  
```
<?php
require_once dirname(__FILE__) . '/PhalApiClient.php';

$client = PhalApiClient::create()
        ->withHost('{url}');
```

PHP示例，文件```./src/view/docs/demos/App.Site.Index.php```，文件内容：  
```
$rs = $client->reset()
    ->withService('{s}')
    ->withParams('username', 'PhalApi')
    ->withTimeout(3000)
    ->request();
```

PHP示例尾部，文件```./src/view/docs/demos/_suffix.php```，文件内容：
```


// ret状态码，200表示成功
var_dump($rs->getRet());
// 业务数据
var_dump($rs->getData());
// 提示信息
var_dump($rs->getMsg());
```

最终文档展示的客户端请求示例效果如下：  
![](http://cd8.yesapi.net/yesyesapi_20200330114944_14ed00c7292ee6783360f4f24564399a.png)  

PhalApi所提供的客户端示例，只是根据PhalApi本身的SDK而配套提供的示例。如果你的接口客户端是其他开发语言，或者使用的是自己封装的SDK，可相应进行调整和修改。  


> 注意！客户端请求示例，需要PhalApi 2.13.1 及以上版本方可支持。

### 接口异常@exception

异常情况对应```@exception```注释，可以有多组，格式为：```@exception 错误码 错误描述信息```。例如：    

```php
    /**
     * @exception 400 非法请求，参数传递错误
     */
    public function index() {
```
刷新后，可以看到新增的异常情况说明。  

![](http://cd8.yesapi.net/yesyesapi_20190522124948_ea764bc8b983cf404a2fbc62cc7027af.jpeg)

异常情况列表依次由以下四部分构成：
 + 第一部分：PhalApi框架的错误返回
 + 第二部分：接口类基类的公共异常注释（多个基类时依次叠加）
 + 第三部分：当前接口类的公共异常注释
 + 第四部分：接口类成员函数的异常注释

### 公共注释

对于当前类的全部函数成员的公共```@exception```异常情况注释和```@return```返回结果注释，可在类注释中统一放置。而对于多个类公共的@exception```和```@return```注释，则可以在父类的类注释中统一放置。

也就是说，通过把```@exception```注解和```@return```注解移到类注释，可以添加全部函数成员都适用的注解。例如，Api\User类的全部接口都返回code字段，且都返回400和500异常，则可以：  
```php
<?php
namespace App\Api;

use PhalApi\Api;

/**
 * @return int code 操作码，0表示成功
 * @exception 400 参数传递错误
 * @exception 500 服务器内部错误
 */

class User extends Api {
```
这样就不需要在每个函数成员的注释中重复添加注解。此外，也可以在父类的注释中进行添加。对于相同异常码的```@exception```注解，子类的注释会覆盖父类的注释，方法的注释会覆盖类的注释；而对于相同的返回结果```@return```注释，也一样。  

需要注意的是，注释必须是紧挨在类的前面，而不能是在namespace前面，否则会导致注释解析失败。  

## 通过在线接口文档进行测试

在线接口文档，不仅可以用来查看接口文档，包括接口参数、返回字段和功能说明外，还可以在上面进行接口测试。这将会直接请求当前的接口。效果如下：

![](http://cd8.yesapi.net/yesyesapi_20190420153522_8629e92c261ad6a1f58f3e990994dce2.png)

## 如何隐藏接口？

如果需要在在线接口文档列表页隐藏接口模块，或者特定的接口，可以使用```@ignore```注释。例如：  
隐藏整个接口模块，可以在类注释添加```@ignore```。
```php
<?php
namespace App\Api;
use PhalApi\Api;

/**
 * @ignore
 */
class User extends Api {

}
```

如果只是需要隐藏特定的接口，可以在类成员函数的注释中添加```@ignore```。
```php
<?php
namespace App\Api;
use PhalApi\Api;

class User extends Api {
    /**
     * 忘记密码接口
     * @ignore
     */
    public function forgetPassword() {
    }

}
```

添加后刷新接口列表页将不会显示，但在接口详情页通过原来的链接仍能正常访问和显示。  

## 如何生成离线接口文档？  

上面在线的接口文档，也可以一键生成离线版的HTML文档，方便传阅，离线查看。  

当需要生成离线文档时，可以在终端，执行以下命令：  

```bash
phalapi$ php ./public/docs.php 

Usage:

生成展开版：  php ./public/docs.php expand
生成折叠版：  php ./public/docs.php fold

脚本执行完毕！离线文档保存路径为：/path/to/phalapi/public/docs
```

执行后，可以看到类似上面的提示和结果输出。再查看生成的离线文档，可以看到类似有：  
```bash
phalapi$ tree ./public/docs
./public/docs
├── App.Examples_CURD.Delete.html
├── App.Examples_CURD.Get.html
├── App.Examples_CURD.GetList.html
├── App.Examples_CURD.Insert.html
├── App.Examples_CURD.Update.html
├── App.Examples_Upload.Go.html
├── App.Site.Index.html
└── index.html
```

最后，可以在页面访问此离线版文档，如访问链接：  
```
http://dev.phalapi.net/docs/index.html
```

也可以将此docs目录打包，在本地打开访问查看。

## 自定义接口文档模板

如果当前默认的接口文档不能满足项目的需求，例如在实际情况下，考虑到项目需要显示自己的公司Logo、项目名称，以及其他一些样式的调整，因此这时可以使用自定义模板。  

那么如何在PhalApi定制自己的在线文档模板？  
实现起来很简单，就像我们平时开放网站页面那样，只需要把模板的路径修改一下即可。  

在线文档共有两份模板，分别是：  
 + 第1份：在线列表页文档模板，模板路径是：```./src/view/docs/api_list_tpl.php```
 + 第2份：在线详情页文档模板，模板路径是：```./src/view/docs/api_desc_tpl.php```

当需要修改时，建议复制一份，再进行修改调整。  

调整后，需要切换文档模板。修改：```./public/docs.php```，调整模板路径。  
```php
$detailTpl = API_ROOT . '/src/view/docs/api_desc_tpl.php';
$listTpl = API_ROOT . '/src/view/docs/api_list_tpl.php';
```

就可以看到你自己的文档模板了。  

## 接口详情页的模板变量
PhalApi针对接口详情页，定义并提供了以下模板变量。  

模板变量名称|说明|类型|示例
---|---|---|---
$service|完整的接口服务名称，英文|字符串|App.Site.Index
$namespace|命名空间|字符串|App
$api|接口名|字符串|Site，目录结构使用下划线分割
$action|接口方法名|字符串|Index，统一以大写字母开头
$className|完整的接口类名，带命名空间|字符串|\App\Api\Site
$rules|接口参数规则|数组|对应Api类中的getRules()函数返回
$returns|接口返回字段|数组|对应接口方法注释内容的解析数据
$description|接口标题说明|字符串|默认接口
$descComment|接口功能描述|字符串|对应@desc注解
$methods|接口允许的请求方式|字符串|默认为空，对应@method注解，例如：GET/POST/PUT
$exceptions|接口异常错误码|数组|对应@exception注解
$version|接口版本号|字符串|对应@version注解
$projectName|接口项目名称|字符串|全局的接口项目名称
$isException|是否解析异常|布尔值|true/false，为真时表示解析接口文档异常，状态码填充在$description，异常信息填充在$descComment

如果需要自定义接口详情页的模板，可以参考上面的模板变量。

## 如何调整接口文档的分类？  
如果需要合并不同的接口文件的接口，展示在同一个分组文档，可以修改./public/docs.php文件，传入API_CATE_TYPE_API_CLASS_TITLE的划分方式。如：  
```php
    // 接口列表页，第2个构造参数不传，按原来默认的接口类方式分组
    //（或传入0，或\PhalApi\Helper\ApiList::API_CATE_TYPE_API_CLASS_NAME）
    $apiList = new \PhalApi\Helper\ApiList($projectName);
    $apiList->render($listTpl);

    // 接口列表页，传入第2个参数，按接口模块名称分组
    $apiList = new \PhalApi\Helper\ApiList($projectName, \PhalApi\Helper\ApiList::API_CATE_TYPE_API_CLASS_TITLE);
    $apiList->render($listTpl);

    // 接口列表页，或直接传入1
    $apiList = new \PhalApi\Helper\ApiList($projectName, 1);
    $apiList->render($listTpl);
```
> 温馨提示：API_CATE_TYPE_API_CLASS_TITLE划分方式需要PhalApi 2.18.4 及以上版本支持。  


默认情况下，PhalApi框架自动生成的在线接口分类文档，其左侧接口菜单是按接口类名分组的，例如接口类名```App.Examples_CURD```。  

通常，这是可以满足接口分类展示的需求。但如果接口过多，或者需要以业务的方式进行分组显示和接口的分类划分，例如按功能模块进行划分，在下面例子中，有两个版本的日志API接口，分别放置在两个不同的Api接口文件和接口类中。这样，你就可以既能满足业务的分组方式，又能同时按技术编程上的风格进行分组管理，两者兼得。    

```bash
./src/app/Api/Examples/Log.php
./src/app/Api/Examples/Log2.php
```

对应的代码分别是：  
```php
$ cat ./src/app/Api/Examples/Log.php
<?php
namespace App\Api\Examples;
use PhalApi\Api;

/**
 * 日志
 */
class Log extends Api {
    /**
     * 写入日志
     * @desc 演示日志操作，包括写系统异常类日志、业务纪录类日志、开发调试类日志
     */
    public function run() {
    }
}

$ cat ./src/app/Api/Examples/Log2.php
<?php
namespace App\Api\Examples;

use PhalApi\Api;

/**
 * 日志
 */
class Log2 extends Api {

    /**
     * 写入日志V2
     * @desc 此接口，用于演示合并接口分类的效果
     */
    public function run() {
    }
}
```

刷新接口列表，即可以看到：  
![](/images/20220809-204539.png)   

而不会再出现重复的两个日记分类菜单：  
![](/images/20220809-204944.png)  



