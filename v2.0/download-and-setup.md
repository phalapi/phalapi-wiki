# Download and Installation

The same as PhalApi 1.x series, PhalApi 2.x requies PHP >= 5.3.3.

## Quick Install

The Install progress for PhalApi 2.x is easy, there are two methods.

### Install by composer

#### Install Composer

If you have not installed Composer, you can install it by the method in getcomposer.org. The following commands can be run in Linux and Mac OS X:

```bash
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
```

<!-- > 温馨提示：关于composer的使用,请参考[Composer 中文网 / Packagist 中国全量镜像](http://www.phpcomposer.com/). -->

#### Install PhalApi 2.x

One-click installation can be achieved by using the command of composer to create a project.

```bash
$ composer create-project phalapi/phalapi
```

### Download and Install manually

Alternatively, manual installation is also possible. Download [phalapi](https://github.com/phalapi/phalapi/tree/master-2x) Project**master-2x branch** Source code. After downloading and unzipping, perform an optional composer update:

```bash
$ composer update
```
 
> Tips: In order to improve the friendliness, phalapi already comes with a default vendor installation package, so as to reduce the learning cost of developers who have not contacted composer development befor. Even if the composer installation fails, PhalApi 2.x can be run normally.

## Config

### Nginx Configuration

If you are using Nginx, you can refer to the following configuration.

```
server {
    listen 80;
    server_name dev.phalapi.net;
    root /path/to/phalapi/public;
    charset utf-8;

    location / {
        index index.php;
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


After restarting Nginx and configuring local HOSTS, you can access the default API service through the following link.

```
http://dev.phalapi.net
```

> Tips: It is recommended to point the root path of the visit to /path/to/phalapi/public. In the subsequent development documents, unless otherwise specified, this configuration method is agreed.

### Apache Configuration

If you are using Nginx, you can refer to the following configuration. Folder structure:
```
htdocs
├── phalapi
└── .htaccess
```

Content of ".htaccess":

```
<IfModule mod_rewrite.c>
    RewriteEngine on
    RewriteBase /

    RewriteCond %{HTTP_HOST} ^dev.phalapi.net$

    RewriteCond %{REQUEST_FILENAME} !-f
    RewriteCond %{REQUEST_FILENAME} !-d

    RewriteCond %{REQUEST_URI} !^/phalapi/public/
    RewriteRule ^(.*)$ /phalapi/public/$1
    RewriteRule ^(/)?$ index.php [L]
</IfModule>
```

### XAMPP Configuration

If you are using XAMPP integrated environment, you only need to copy the entire directory of PhalApi project source code to htdocs directory of XAMPP. After opening the XAMPP control panel and starting Apache, you can access the default API service through the following link.
```
http://localhost/phalapi/public/
```

No matter what configuration you are using from above, under normal circumstances, you can see output similar to this when accessing the default API service:

```
{
    "ret": 200,
    "data": {
        "title": "Hello PhalApi",
        "version": "2.0.1",
        "time": 1501079142
    },
    "msg": ""
}
```

Running result, screenshot is as follow:

![](http://cdn7.phalapi.net/20170726223129_eecf3d78826c5841020364c852c35156)


By now, the installation is complete!


## How to upgrade PhalApi 2.x framework？

Under composer environment, it is very simple to upgrade the PhalApi 2.x framework. Just modify the composer.json file and specify the corresponding version.
PhalApi's framework kernel project is at[phalapi/kernal](https://github.com/phalapi/kernal), You can specify the version, or you can follow the latest version.

For example, when you need to specify PhalApi version 2.0.1, you can configure it like this:
```
{
    "require": {
        "phalapi/kernal": "2.0.1"
    }
}
```

When you need to keep the latest version, you can change to:
```
{
    "require": {
        "phalapi/kernal": "2.*.*"
    }
}
```

In this way, when PhalApi 2.x is updated, you only need to perform the composer update operation. The corresponding command operation is:

```bash
$ composer update
```

By now, the upgrade is complete!

<!-- #### 温馨提示：关于composer版本的说明,可参考[Composer中文文档 - 包版本](http://docs.phpcomposer.com/01-basic-usage.html#Package-Versions). -->


