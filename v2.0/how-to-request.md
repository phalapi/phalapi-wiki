# How to Request API

## Request under HTTP/HTTPS

For PhalApi, the default communicate protocol is HTTP/HTTPS. According to the specific implementation of the API service, we could use GET or POST to request.

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

It should be noted that if there are multiple levels of directories in Api, the underline connection is used between the Class name and the directory, and no underscores can appear in the class name. For example, for interface files 'Namespace/Api/Folder/Class::Action()' the corresponding interface service name is: '?s=Namespace.Folder_Class.Action'.   

> Tips: When there is a multi-level directory on the interface, use an underscore to connect the directory and the class name.

### About Namespace

Namespace refers to the first half of ```/Api/``` in the namespace. And it needs to register autoload in the composer.json file in the root directory, so that the class file can be automatically loaded normally. For example, the registered app Namespaces:
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

Class refers to the last half of ```/Api/``` in the namespace. And it must be the subclass of [PhalApi/Api](https://github.com/phalapi/kernal/blob/master/src/Api.php). When there are sub-namespaces in the namespace, underscores are also used when requesting. Similarly, when there is no multi-level namespace, the namespace should not contain underscores.

### About Action

The Action to be requested should be a class method of public access level, and cannot be a existing method in[PhalApi/Api](https://github.com/phalapi/kernal/blob/master/src/Api.php). 

### Examples

Here are some comprehensive examples. 

PhalApi 2.x 's' parameter|File|Action Class Method
---|---|---
Nil|./src/app/Api/Site.php|App\Api\Site::Index()
?s=Site.Index|./src/app/Api/Site.php|App\Api\Site::index()
?s=Weibo.Login|./src/app/Api/Weibo.php|App\Api\Weibo::login()
?s=User.Weibo.Login|./src/user/Api/Weibo.php|User\Api\Weibo::login()
?s=Company_User.Third_Weibo.Login|./src/company_user/Api/Third/Weibo.php|Company\User\Api\Third\Weibo::login()

The above example assumes that already configured in composer.json:
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

> Note! This feature requires PhalApi 2.7.0 and above.

In any case, PhalApi will give priority to the service parameter, followed by the s parameter (the short parameter of service) to locate which API service is currently requested by the client. 

When the client does not provide the service parameter or the s parameter, we can try to match the URI route by turning on ```sys.enable_uri_match```.

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

The principle is very simple, when the service parameter and s parameter are not provided, and after ```sys.enable_uri_match``` is turned on, the client can access the API service through a URI like ```/Namespace/Class/Action```.

In addition to modifying the enable_uri_match configuration to true in ./config/sys.php, we also need to synchronize the Rewrite rule configuration so that the service forwards the request to index.php for processing when it does not find a file. Refer to the following Nginx configuration:
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

Although we agreed to use the format ```?s=Namespace.Class.Action``` to pass the API service name, if the project needs it, it can also be passed in other ways. For example, it is similar to the Yii framework request format: ```?r=Namespace/Class/Action```.   

If we want to customize the way to pass the interface service name, we can rewrite the method[PhalApi\Request::getService()](https://github.com/phalapi/kernal/blob/master/src/Request.php). The following is a code snippet for changing to slash splitting and using r parameter names.

```php
// File ./src/app/Common/Request.php

<?php
namespace App\Common;

class Request extends \PhalApi\Request {

    public function getService() {
        // Give priority to the API service name in a custom format
        $service = $this->get('r');
        if (!empty($service)) {
            $namespace = count(explode('/', $service)) == 2 ? 'App.' : '';
            return $namespace . str_replace('/', '.', $service);
        }

        return parent::getService();
    }
}
```
After the custom request class is implemented, it needs to be registered in the DI configuration file of the project [./config/di.php](https://github.com/phalapi/phalapi/blob/master/config/di.php). Add one line at the end of the file:   
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
