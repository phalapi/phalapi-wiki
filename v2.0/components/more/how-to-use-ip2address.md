# 如何将ip地址转换成ip归属地
在一些管理系统的登录注册功能和日志记录功能中，需要根据用户的ip地址，获得ip归属地。
有两种方法能实现。

phalapi框架的[工具和杂项](http://docs.phalapi.net/#/v2.0/tool)里，提供了获取客户端IP地址的方法。
```php
$ip = \PhalApi\Tool::getClientIp();
```

## 常规curl方式

将`ipToArea()`方法，放在框架的公共函数里

```php
// phalapi/src/app/functions.php

/**
 * 太平洋IP地址库API接口
 */
function ipToArea($ip = "")
{
    $ch = curl_init();
    $url = 'https://whois.pconline.com.cn/ipJson.jsp?ip=' . $ip;
    //用curl发送接收数据
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    //请求为https
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
    curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false);
    $location = curl_exec($ch);
    curl_close($ch);
    //转码
    $location = mb_convert_encoding($location, 'utf-8', 'GB2312');
    //var_dump($location);
    //截取{}中的字符串
    $location = substr($location, strlen('({') + strpos($location, '({'), (strlen($location) - strpos($location, '})')) * (-1));
    //将截取的字符串$location中的‘，’替换成‘&’   将字符串中的‘：‘替换成‘=’
    $location = str_replace('"', "", str_replace(":", "=", str_replace(",", "&", $location)));
    //php内置函数，将处理成类似于url参数的格式的字符串  转换成数组
    parse_str($location, $ip_location);
    return $ip_location['addr'];
}
```

调用：
```php
// phalapi/src/manage/Api/Admin/Administer.php

$newData['reg_ip'] = \PhalApi\Tool::getClientIp();
$newData['reg_location'] = \App\ipToArea($newData['reg_ip']);
```

这种方法依赖第三方地址库。而且每次进行curl请求的时候，由于是同步请求，会有明显的卡顿/延迟。
建议放在[MQ异步队列](http://docs.phalapi.net/#/v2.0/mq-gearman)里执行，避免阻塞。

## IP地址转换插件

phalapi框架有一个隐藏插件[phalapi-ip2address](https://packagist.org/packages/yfanlu/phalapi-ip2address)，在官方文档里没有列出，但是实际上可用。是由用户@yfanlu 开发的。

文档说明里，只有简单一句话：PhalApi 2.x ip扩展，使用qqwry.dat数据库。

具体怎么用呢？
对于composer不熟悉的我来说，调用这个插件还颇费周折。
下面分享我的琢磨过程吧。

首先引用插件：
```
composer require yfanlu/phalapi-ip2address
```

检查文件，发现类库会安装到`phalapi/vendor/yfanlu/phalapi-ip2address`这个目录。

接下来怎么调用这个类库呢？不知道。

由于phalapi框架提供了[官方和第三方扩展类库](http://docs.phalapi.net/#/v2.0/library)，先去看看别的类库都是如何调用的。

经过观察和思考，发现很多类库在使用composer引用以后，都要在`phalapi/config/app.php`里进行配置。

查看`phalapi/vendor/yfanlu/phalapi-ip2address/src/Lite.php`的代码，发现该库好像是不需要什么配置的。

然后还发现，很多类库都要注册DI服务。进入开发手册的[DI服务汇总](http://docs.phalapi.net/#/v2.0/di)，并没有找到如何注册自定义的扩展库。也没发现能用得上的线索。

怎么办呢？
扩展库里有一个[xuepengdong/phalapiredis](https://github.com/xuepengdong/phalapiredis)。提供了详细的安装步骤。
其注册是这样的：
```php
// 惰性加载Redis
$di->redis = function () {
    return new \Xuepengdong\Phalapiredis\Lite(\PhalApi\DI()->config->get("app.redis.servers"));
};
```

先照猫画虎，尝试注册DI：
```php
// phalapi/config/di.php

$di->ip2address = function () {
    return new \yfanlu\phalapi-ip2address\Lite.php();
};
```

代码写好以后，就发现VSCode编译器给这一行打上了红色的波浪线，预示着存在错误。
果然，在业务中调用，报错了：
```
Uncaught Error: Class 'yfanlu\\phalapi' not found 
```

直接提示类不存在，那么很可能是路径不正确。
继续查看目录源码，发现目录下有个`composer.json`文件。
里面有这样一段配置：
```json
// phalapi/vendor/yfanlu/phalapi-ip2address/composer.json

"autoload": {
        "psr-4": {
            "PhalApi\\Ip2address\\": "src"
        }
}
```

这个路径不知道能不能用。来试试：
```php
// phalapi/config/di.php

$di->ip2address = function () {
    return new \PhalApi\Ip2address\Lite();
};
```

这下编译器没报错，右键菜单也能跳转到该类，兴许能用呢。

接下来写调用代码：
```php
// phalapi/src/manage/Api/System/Test.php

$ip = \PhalApi\Tool::getClientIp();
return \PhalApi\DI()->ip2address->getlocation($ip); 
```

请求接口，返回如下内容：
```json
{"ret": 200,
 "data": {
      "ip": "106.2.92.34",
      "beginip": "106.2.90.0",
      "endip": "106.2.106.255",
      "country": "河南省郑州市",
      "area": "电信"
  },
 "msg": ""
}
```

大功告成。原来DI服务的注册路径，藏在`composer.json`的psr-4里面。
学会这一招，就可以去测试[Packagist](https://packagist.org/)这个网站里，其他的composer类库是否能在phalapi里调用了。

因为是直接从本地数据库查询的数据，使用这个插件获取ip地址归属地的速度，比curl的方式要快1秒以上。
[纯真 IP 地址数据库](https://gitee.com/gai871013/ip-location)`qqwry.dat`收集了包括中国电信、中国移动、中国联通、长城宽带、聚友宽带等 ISP 的 IP 地址数据，包括网吧数据，没有错误数据的 QQ IP。

By feiYun 2023-06-13 00:56:10

