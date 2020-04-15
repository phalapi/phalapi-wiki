# How to Request API

## Request under HTTP

For PhalApi, the default communicate protocol is HTTP. According to the specific implementation of the API service, we could use GET or POST to request.

## Request Access Point

As mentioned earlier, PhalApi recommends setting the system's externally accessible root directory to /path/to/phalapi/public. PhalApi's unified access entry file is /path/to/phalapi/public/index.php.   

When your domain is: dev.phalapi.net, and set the root folder to public, the accessible URL is:   
```
http://dev.phalapi.net
```

When the domain name and the root directory are not configured, the URL accessed is (obviously longer and less elegant):
```
http://localhost/phalapi/public/index.php
```

If it is not installed, please read [Download and Install](http://docs.phalapi.net/#/v2.0/download-and-setup).   

## How to specify the API service to be requested?

By default, you can specify the 's' parameter when requesting. When 's' is not transmitted, the default API service is used: 'App.Site.Index'. The following three methods are equivalent, and all request the default API service.

 + No 's' parameter
 + ?s=Site.Index, omit the Namespace, use App by default
 + ?s=App.Site.Index, with namespace prefix

 In other words, when requesting API services other than the default interface service, the format can be one of two:  

 + ?s=Class.Action
 + Or: ?s=Namespace.Class.Action

'Namespace' represents the namespace prefix, 'Class' is the name of the API service class, and 'Action' is the name of the API service method. These three are usually capitalized and separated by English dots. The final class method is: Namespace/Api/Class::Action().   

> Tips: 's' is the abbreviation of service parameter, ```?s=Class.Action``` equals to ```?service=Class.Action```, when both are present, the service parameter is used first. 

需要注意的是: 如果Api内有多级目录, 则Class类名及目录之间使用下划线连接, 并且类名中不能出现下划线. 例如对于接口文件Namespace/Api/Folder/Class::Action()对应的接口服务名称是: ?s=Namespace.Folder_Class.Action.   

> Tips: When there is a multi-level directory on the interface, use an underscore to connect the directory and the class name.

### About Namespace

Namespace是指命名空间中```/Api/```的前半部分. 并且需要在根目录下的composer.json文件中进行autoload的注册, 以便能正常自动加载类文件. 如默认已经注册的App命名空间:   
```
{
    "autoload": {
        "psr-4": {
            "App\\": "src/app"
        }
    }
}
```
When there are sub-namespaces in the namespace, the underscore is used when requesting. Conversely, when there is no multi-level namespace, the namespace should not contain underscores.

### About Class

Class接口服务类名是指命名空间中```/Api/```的后半部分, 并且必须是[PhalApi/Api](https://github.com/phalapi/kernal/blob/master/src/Api.php)的子类. 当命名空间存在子命名空间时, 在请求时同样改用下划线分割. 类似的, 当不存在多级命名空间时, 命名空间不应该含有下划线.   

### About Action

待请求的Action, 应该是public访问级别的类方法, 并且不能是[PhalApi/Api](https://github.com/phalapi/kernal/blob/master/src/Api.php)已经存在的方法. 

### Examples

以下是一些综合的示例.   

PhalApi 2.x 请求的s参数|对应的文件|执行的类方法
---|---|---
无|./src/app/Api/Site.php|App\Api\Site::Index()
?s=Site.Index|./src/app/Api/Site.php|App\Api\Site::index()
?s=Weibo.Login|./src/app/Api/Weibo.php|App\Api\Weibo::login()
?s=User.Weibo.Login|./src/user/Api/Weibo.php|User\Api\Weibo::login()
?s=Company_User.Third_Weibo.Login|./src/company_user/Api/Third/Weibo.php|Company\User\Api\Third\Weibo::login()

上面示例中假设, 已经在composer.json中配置有:   
```
{
    "autoload": {
        "psr-4": {
            "App\\": "src/app",
            "User\\": "src/user",
            "Company\\User\\": "src/company_user"
        }
    }
}
```

## Turn on URI routing matching

> 注意！本功能需要PhalApi 2.7.0 及以上版本方可支持. 

任何情况下, PhalApi都会优先通过service参数, 其次是s参数（也就是service的短参数）来定位当前客户端请求的是哪一个接口服务.   

当客户端未提供service参数, 亦未提供s参数时, 可以通过开启```sys.enable_uri_match```尝试进行URI路由匹配. 

Let's take a few examples to understand the access effect after turning on URI routing matching.The following effects are equivalent.

```
# Specify by service
http://dev.phalapi.net/?service=App.Usre.Login

# After turning on URI routing matching
http://dev.phalapi.net/App/User/Login

# Default App Namespace
http://dev.phalapi.net?s=App.Usre.Login

# After turning on URI routing matching
http://dev.phalapi.net/User/Login

```

原理很简单, 当未提供service参数和s参数时, 并且是开启```sys.enable_uri_match```后, 客户端可以通过```/Namespace/Class/Action```这样的URI访问接口服务. 

除了要在./config/sys.php修改enable_uri_match配置为true外, 还需要同步进行Rewrite规则配置, 以便让你的服务在未找到文件时把请求转发给index.php处理. 参考以下Nginx配置: 

```
server {
    listen 80;
    server_name dev.phalapi.net;
    root /path/to/phalapi/public;
    charset utf-8;

    # Turn on URI routing matching
    location / {
        try_files $uri $uri/ $uri/index.php;
    }
    if (!-e $request_filename) {
        rewrite ^/(.*)$ /index.php last;
    }

    location ~ \.php$ {
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass 127.0.0.1:9000;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    }

    access_log logs/dev.phalapi.net.access.log;
    error_log logs/dev.phalapi.net.error.log;
}

```

### How do routes match?

After enabling route matching, and correctly configuring the Nginx or Apache Rewrite rules, the client can access the API service in the following ways:

 + Common path: ```/Namespace/Class/Action```
 + Common path, with 'GET' parameter: ```/Namespace/Class/Action?xx=123```
 + Common path, with index.php: ```/index.php/Namespace/Class/Action```
 + Common path, with index.php and 'GET' parameter: ```/public/index.php/Namespace/Class/Action?xx=123```

Similarly, if the Namespace is App, it can be ignored and not written, that is:

 + Default App, Common path: ```/Class/Action```
 + Default App, Common path, with 'GET' parameter: ```/Class/Action?xx=123```
 + Default App, Common path, with index.php: ```/index.php/Class/Action```
 + Default App, Common path, with index.php and 'GET' parameter: ```/public/index.php/Class/Action?xx=123```

The following is an example of the login API:

```
// Common path
http://dev.phalapi.net/App/User/Login

// Common path, with 'GET' parameter
http://dev.phalapi.net/App/User/Login?username=dogstar&password=123456

// Common path, with index.php
http://dev.phalapi.net/index.php/App/User/Login

// Common path, with index.php and 'GET' parameter（The entry file must be index.php, the previous directory path can be customized）
http://dev.phalapi.net/public/index.php/App/User/Login?username=dogstar&password=123456
```

## Extension: How to customize the delivery method of the API service?

虽然我们约定统一使用```?s=Namespace.Class.Action```的格式来传递接口服务名称, 但如果项目有需要, 也可以采用其他方式来传递. 例如类似于Yii框架的请求格式: ```?r=Namespace/Class/Action```.   

如果需要定制传递接口服务名称的方式, 可以重写[PhalApi\Request::getService()](https://github.com/phalapi/kernal/blob/master/src/Request.php)方法. 以下是针对改用斜杠分割, 并换用r参数名字的实现代码片段.   
```php
// 文件 ./src/app/Common/Request.php

<?php
namespace App\Common;

class Request extends \PhalApi\Request {

    public function getService() {
        // 优先返回自定义格式的接口服务名称
        $service = $this->get('r');
        if (!empty($service)) {
            $namespace = count(explode('/', $service)) == 2 ? 'App.' : '';
            return $namespace . str_replace('/', '.', $service);
        }

        return parent::getService();
    }
}
```

实现好自定义的请求类后, 需要在项目的DI配置文件[./config/di.php](https://github.com/phalapi/phalapi/blob/master/config/di.php)进行注册. 在最后的加上一行:   
```php
$di->request = new App\Common\Request();
```

At this time, the API service request can be made in a new way. That is: 

The original method| The current method
---|---
?s=Site.Index|?r=Site/Index   
?s=App.Site.Index|?r=App/Site/Index   
?s=Hello.World|?r=Hello/World  
?s=App.Hello.World|?r=App/Hello/World 


Here are a few notes:

 + 1. The rewritten method needs to be converted to the original API service format, namely: Namespace.Class.Action, be careful not to miss the Namespace.    
 + 2. In order to maintain compatibility, when the custom API service name parameter cannot be obtained, it should be returned ```parent::getService()```.   


If you want to beautify the URL routing, you can use it in conjunction with the redirect configuration.

Nginx configuration:   

```
if (!-e $request_filename) {
    rewrite ^/(.*)$ /index.php?r=$1 last;
}
```

Apache configuration:   
```
<IfModule mod_rewrite.c>
RewriteEngine on
RewriteCond %{REQUEST_FILENAME} !-d
RewriteCond %{REQUEST_FILENAME} !-f
RewriteRule ^(.*)$ index.php/?r=$1 [QSA,PT,L]
SetEnvIf Authorization "(.*)" HTTP_AUTHORIZATION=$1
</IfModule>
```

IIS configuration:   
```
<?xml version="1.0" encoding="utf-8"?>
<configuration>
    <system.webServer>
        <rewrite>
            <rules>
                <rule name="Imported Rule 1" stopProcessing="true">
                    <match url="^(.*)$" ignoreCase="false" />
                    <conditions>
                        <add input="{REQUEST_FILENAME}" matchType="IsDirectory" ignoreCase="false" negate="true" />
                        <add input="{REQUEST_FILENAME}" matchType="IsFile" ignoreCase="false" negate="true" />
                    </conditions>
                    <action type="Rewrite" url="index.php/?r={R:1}" appendQueryString="true" />
                </rule>
            </rules>
        </rewrite>
    </system.webServer>
</configuration>
```

Final result is, when requesting: http://api.phalapi.net/user/login, it will change to: http://api.phalapi.net/?r=user/login, then trigger the above expansion rule, finally equals to: http://api.phalapi.net/?s=user.login
  
Do you find it fun? You can try it out right away. Customize your favorite request method.
