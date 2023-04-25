# DI服务汇总及核心思想

# DI服务初始化
全部依赖注入的资源服务，都位于```./config/di.php```文件内。  

## DI基本使用和注册

默认情况下，会进行基本注册如下：  

```php
use PhalApi\Config\FileConfig;
use PhalApi\Logger;
use PhalApi\Logger\FileLogger;
use PhalApi\Database\NotORMDatabase;

/** ------- 中间代码省略 ------- **/

$di = \PhalApi\DI();

// 配置
$di->config = new FileConfig(API_ROOT . '/config');

// 调试模式，$_GET['__debug__']可自行改名
$di->debug = !empty($_GET['__debug__']) ? true : $di->config->get('sys.debug');

// 日记纪录
$di->logger = new FileLogger(API_ROOT . '/runtime', Logger::LOG_LEVEL_DEBUG | Logger::LOG_LEVEL_INFO | Logger::LOG_LEVEL_ERROR);

// 数据操作 - 基于NotORM
$di->notorm = new NotORMDatabase($di->config->get('dbs'), $di->debug);
```

## 定制注册

可以根据项目的需要，进行定制化的注册，只需要把下面的注释去掉即可。  

```php
// 签名验证服务
// $di->filter = new \PhalApi\Filter\SimpleMD5Filter();

// 缓存 - Memcache/Memcached
// $di->cache = function () {
//     return new \PhalApi\Cache\MemcacheCache(DI()->config->get('sys.mc'));
// };

// 支持JsonP的返回
// if (!empty($_GET['callback'])) {
//     $di->response = new \PhalApi\Response\JsonpResponse($_GET['callback']);
// }
```

如果需要更多的DI服务，也可以参考并使用下面的DI服务资源一览表。  

# DI服务资源一览表

假设，我们已有：  
```php
$di = \PhalApi\DI();
```

则：  

服务名称|是否启动时自动注册|是否必须|接口/类|作用说明
---|---|---|---|---
$di->config|否|是|[PhalApi\Config](https://github.com/phalapi/kernal/blob/master/src/Config.php)|配置：负责项目配置的读取，需要手动注册，指定存储媒介，默认是[PhalApi\Config\FileCache](https://github.com/phalapi/kernal/blob/master/src/Cache/FileCache.php)
$di->logger|否|是|[PhalApi\Logger](https://github.com/phalapi/kernal/blob/master/src/Logger.php)|日记纪录：负责日记的写入，需要手动注册，指定日记级别和存储媒介，默认是[PhalApi\Logger\FileLogger](https://github.com/phalapi/kernal/blob/master/src/Logger/FileLogger.php)
$di->request|是|是|[PhalApi\Request](https://github.com/phalapi/kernal/blob/master/src/Request.php)|接口参数请求：用于收集接口请求的参数
$di->response|是|是|[PhalApi\Response](https://github.com/phalapi/kernal/blob/master/src/Response.php)|结果响应：用于输出返回给客户端的结果，默认为[PhalApi\Response\JsonResponse](https://github.com/phalapi/kernal/blob/master/src/Response/JsonResponse.php)
$di->notorm|否|推荐|[PhalApi\Database\NotORMDatabase](https://github.com/phalapi/kernal/blob/master/src/Database/NotORMDatabase.php)|数据操作：基于NotORM的DB操作，需要手动注册，指定数据库配置
$di->cache|否|推荐|[PhalApi\Cache](https://github.com/phalapi/kernal/blob/master/src/Cache.php)|缓存：实现缓存读写，需要手动注册，指定缓存
$di->filter|否|推荐|[PhalApi\Filter](https://github.com/phalapi/kernal/blob/master/src/Filter.php)|拦截器：实现签名验证、权限控制等操作
$di->crypt|否|否|[PhalApi\Crypt](https://github.com/phalapi/kernal/blob/master/src/Crypt.php)|对称加密：实现对称加密和解密，需要手动注册
$di->curl|否|否|[PhalApi\CUrl](https://github.com/phalapi/kernal/blob/master/src/CUrl.php)|CURL请求类：通过curl实现的快捷方便的接口请求类，需要手动注册
$di->cookie|否|否|[PhalApi\Cookie](https://github.com/phalapi/kernal/blob/master/src/Cookie.php)|COOKIE的操作
$di->tracer|是|是|[PhalApi\Helper\Tracer](https://github.com/phalapi/kernal/blob/master/src/Helper/Tracer.php)|内置的全球追踪器，支持自定义节点标识  
$di->debug|否|否|boolean|应用级的调试开关，通常可从配置读取，为true时开启调试模式
$di->admin|是|是|[Portal\Common\Admin](https://github.com/phalapi/phalapi/blob/master-2x/src/portal/Common/Admin.php)|Portal运营平台登录的管理员会话
$di->error|否|否|[PhalApi\Error](https://github.com/phalapi/kernal/blob/master/src/Error.php)|错误处理
$di->dotenv|是|否|[Dotenv\Dotenv](https://github.com/vlucas/phpdotenv)|PHP dotenv


# DI核心思想解读


## 定义
### (1) 关于依赖注入

即控制反转，目的是了减少耦合性，简单来说就是使用开放式来获取需要的资源。

### (2) 关于资源

这里说的资源主要是在开发过程中使用到的资源，包括配置项；数据库连接、Memcache、接口请求等系统级的服务；以及业务级使用到的实例等。
  

引入依赖注入的目的不仅是为了增加一个类，而是为了更好的对资源进行初始化、管理和维护。下面将进行详细的说明。  

## 一个简单的例子

很多时候，类之间会存在依赖、引用、委托的关系，如A依赖B时，可以这样使用：
```php
class A {
    protected $b;
 
    public function __construct()
    {
        $this->b = new B();      
    }
}
```

这种方式在A内限制约束了B的实例对象，当改用B的子类或者改变B的构建方式时，A需要作出调整。这时可以通过依赖来改善这种关系：
```php
class A {
    protected $b;
 
    public function __construct($b)
    {
        $this->b = $b;       
    }
}
```

再进一步，可以使用DI对B的对象进行管理：
```php
class A {
    public function __construct()
    {       
    }
 
    public function doSth()
    {
        //当你需要使用B时
        $b = $di->get('B');
    }
}
```
这样的好处？  
 
一方面，对于使用A的客户（指开发人员），不需要再添加一个B的成员变量，特别不是全部类的成员函数都需要使用B类服务时。另一方面在外部多次初始化A实例时，可以统一对B的构建。

## 依赖注入的使用示例

为方便使用，调用的方式有：set/get函数、魔法方法setX/getX、类变量$di->X、数组$di['X']，初始化的途径有：直接赋值、类名、匿名函数。
```php
/** ------------------ 创建与设置 ------------------ **/
//获取DI
$di = \PhalApi\DI();
//演示的key
$key = 'demoKey';
 
/** ------------------ 设置 ------------------ **/
//可赋值的类型：直接赋值、类名赋值、匿名函数
$di->set($key, 'Hello DI!');
$di->set($key, 'Simple');
$di->set($key, function(){
    return new Simple();
});
//设置途径：除了上面的set()，你还可以这样赋值
$di->setDemoKey('Hello DI!');
$di->demoKey = 'Hello DI!';
$di['demoKey'] = 'Hello DI!';
 
/** ------------------ 获取 ------------------ **/
//你可以这样取值
echo $di->get('demoKey'), "\n";
echo $di->getDemoKey(), "\n";
echo $di->demoKey, "\n";
echo $di['demoKey']. "\n";
 
/**
 * 演示类
 */
class Simple
{
    public function __construct()
    {
    }
}
```

## 依赖注入的好处
### (1)减少对各个类编写工厂方法以单例获取的开发量

DI相当于一个容器，里面可以放置基本的变量，也可以放置某类服务，甚至是像文件句柄这些的资源。在这容器里面，各个被注册的资源只会存在一份，也就是当被注册的资源为一个实例对象时，其效果就等于单例模式。  

因此，保存在DI里面的类，不需要再编写获取单例的代码，直接通过DI获取即可。  

例如很多API的服务组件以及其他的一些类，都实现了单例获取的方式。分别如：  

微博接口调用：  
```php
<?php
class WeiboApi
{
    protected static $_instance = null;
 
    public static function getInstance()
    {
        if (!isset(self::$_instance)) {
            self::$_instance = new WeiboApi();
        }
        return self::$_instance;
    }
     
    //....
}
```

七牛云存储接口调用：
```php
class QiniuApi {
    private static $_instance = null; //实例对象
 
    public static function getInstance()
    {
        if (self::$_instance ===null) {
            self::$_instance = new QiniuApi();
        }
        return self::$_instance;
    }
}
```

QQ开放平台接口调用：
```php
class QQApi { 
    private static $_instance = null; //实例对象
 
    public static function getInstance()
    {
        if (self::$_instance ===null) {
            self::$_instance = new QQApi();
        }
        return self::$_instance;
    }
}
```

如果使用DI对上面这些服务进行管理，则上面三个类乃至其他的类对于单例这块的代码都可以忽略不写。注册代码如下：
```php
$di->sStockApi = '\WeiboApi'; // 寻找根命名空间的类
$di->sDioAopi = '\QiniuApi';
$di->sShopApi = '\QQApi';
```

上面是通过类名来进行延迟加载，但需要各个类提供public的无参数的构造函数。如果各个服务需要进行初始化，可以将初始化的工作放置在onInitialize()函数内，DI在对类实例化时会回调此函数进行初始化。

### (2)统一资源注册，便于后期维护管理

这里引入DI，更多是为了“一处创建，多处使用”， 而不是各自创建，各自使用。
####创建和使用分离

考虑以下场景：假设有这样的业务数据需要缓存机制，所以可注册一个实现缓存机制的实例：
```php
$di = \PhalApi\DI();

$di->set('cache', new \PhalApi\Cache\FileCache());
```
然后提供给多个客户端使用：
```php
$di['cache']->set('indexHtml', $indexContent);   //缓存页面
$di['cache']->set('config', $config);  //缓存公共配置
$di['cache']->set('artistList', $artistList);   //缓存数据
```
当需要切换到MC或者Redis缓存或者多层缓存时，只需要修改对缓存机制的注入即可，如：
```php
$config = array('host' => '127.0.0.1', 'port' => 6379);
$di->set('cache', new \PhalApi\Cache\RedisCache($config));
```
 
依赖注入的一个很大的优势就在于可以推迟决策，当需要用到某个对象时，才对其实例化。可以让开发人员在一开始时不必要关注过多的细节实现，同时也给后期的扩展和维护带来极大的方便。  

### (3)延迟式加载，提高性能

延迟加载可以通过DI中的类名初始化、匿名函数和参数配置（未实现）三种方式来实现。  

延迟加载有时候是非常有必要的，如在初始化项目的配置时，随着配置项的数据增加，服务器的性能也将逐渐受到影响，因为配置的内容可能是硬编码，可能来自于数据库，甚至需要通过接口从后台调用获取， 特别当很多配置项不需要使用时。而此时，支持延时加载将可以达到很好的优化，而不用担心在需要使用的时候忘记了初始化。从而很好的提高服务器性能，提高响应速度。  

如对一些耗时的资源先进行匿名函数的初始化：   
```php
$di['hightResource'] = function() {
    //获取返回耗性能的资源
    //return $resource; 
}
```

### (4)以优雅的方式取代滥用的全局变量

在我看来，PHP里面是不应该使用全局变量（global和$_GLOBALS），更不应该到处使用。  

用了DI来管理，即可这样注册：
```php
$di->set('debug', true);
```
然后这样使用：
```php
$debug = $di->get('debug');
```
也许有人会想：仅仅是换个地方存放变量而已吗？其实是换一种思想使用资源。  

以此延伸，DI还可用于改善优化另外两个地方：通过include文件途径对变量的使用和变量的多层传递。  

变量的多层传递，通俗来说就是漂洋过海的变量。  

> DI思想的来源与推荐参考 [Dependency Injection/Service Location](http://docs.phalconphp.com/en/latest/reference/di.html)  


# DI服务是否已注册的判断误区

### (1)错误的判断方法

当需要判断一个DI服务是否已被注册，出于常识会这样判断：  
```php
if (isset(\PhalApi\DI()->cache)) {
```
但这样的判断永远为false，不管注册与否。  
  
追其原因在于，DI类使用了魔法方法的方式来提供类成员属性，并存放于```PhalApi\DependenceInjection::$data```中。  
  
这就导致了如果直接使用isset(\PhalApi\DI()->cache)的话，首先不会触发魔法方法 ```PhalApi\DependenceInjection::__get($name)```的调用，其次也确实没有```PhalApi\DependenceInjection::$cache``` 这个成员属性，最终判断是否存在时都为false。  
  
简单来说，以下两种判断，永远都为false：  
```php
$di = \PhalApi\DI();

// 永远为false
var_dump(isset($di->XXX));
var_dump(!empty($di->XXX));
```

### (2)正确判断的写法：先获取，再判断

正确的用法应该是：  
```php
// 先获取，再判断
$XXX = $di->XXX;
var_dump(isset($XXX));
var_dump(!empty($XXX));
```  
 
