# 下载与安装

PhalApi 2.x 与PhalApi 1.x 系列一样，要求PHP >= 5.3.3。

# 快速安装

PhalApi 2.x 版本的安装很简单。有以下两种方式。

## composer一键安装

### 安装Composer

如果还没有安装 Composer，你可以按 getcomposer.org 中的方法安装。 在 Linux 和 Mac OS X 中可以运行如下命令：

```bash
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
```

> 温馨提示：关于composer的使用，请参考[Composer 中文网 / Packagist 中国全量镜像](http://www.phpcomposer.com/)。

推荐使用阿里云镜像，全局配置：  
```bash
$ composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/
```

### 安装PhalApi 2.x

使用composer创建项目的命令，可实现一键安装。

```bash
$ composer create-project phalapi/phalapi
```

## docker安装

请参考教程：[使用Docker快速部署你的Phalapi项目](https://blog.csdn.net/shuxnhs/article/details/108862265)。  

## 手动下载安装

或者，也可以进行手动安装。首先下载[phalapi](https://github.com/phalapi/phalapi/tree/master-2x)项目**master-2x分支**源代码。下载解压后，进行可选的composer更新，即：  
```bash
$ composer update
```

> 温馨提示：为提高友好度，phalapi中已带有缺省vendor安装包，从而减轻未曾接触过composer开发同学的学习成本。即便composer安装失败，也可正常运行PhalApi 2.x。  

## 宝塔一键安装部署

> BT宝塔安装链接及教程：[https://www.bt.cn/new/download.html](https://www.bt.cn/new/download.html)  


如何在宝塔上，一键安装部署PhalApi开源接口框架？

 + 第一步，进入你的宝塔 - 软件商店。
 + 第二步，切换到：一键部署；
 + 第三步，搜索 phalapi；
 + 第四步，点击 一键部署；

在安装界面，根据提示，填入你的接口域名，例如这里是：myapi.phalapi.net，以及你的新建接口数据库的初始名称和数据库密码。点击【提交】。  

![](/images/a6c8-e0946ca1eb5d.png)  

> 温馨提示：宝塔安装的PhalApi版本，当前为v2.23.0，或以宝塔上最新的版本为准。  


# 配置

## Nginx配置

如果使用的是Nginx，可参考以下配置。  
```
server {
    listen 80;
    server_name dev.phalapi.net;
    root /path/to/phalapi/public;
    charset utf-8;

    location / {
        index index.php index.html;
    }

    # 开启URI路由匹配
    # location / {
    #       try_files $uri $uri/ /?$args;
    # }
    # if (!-e $request_filename) {
    #        rewrite ^/(.*)$ /index.php last;
    # }

    location ~ \.php$ {
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass 127.0.0.1:9000;
        #fastcgi_pass unix:/var/run/php-fpm/php-fpm.sock; # 根据需要选择配置
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    }

    access_log logs/dev.phalapi.net.access.log;
    error_log logs/dev.phalapi.net.error.log;
}
```


重启Nginx并配置本地HOSTS后，可通过以下链接，访问默认接口服务。  
```
http://dev.phalapi.net
```

> 温馨提示：推荐将访问根路径指向/path/to/phalapi/public。后续开发文档中，如无特殊说明，均约定采用此配置方式。

## Apache配置

如果使用的是Apache，可参考以下配置。目录结构：  
```
htdocs
├── phalapi
└── .htaccess
```

.htaccess内容：  
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

上面配置是针对特定域名的配置，以下是通用配置。

```
<IfModule mod_rewrite.c>
    RewriteEngine On
    RewriteBase /
    RewriteRule ^index\.php$ - [L]
    RewriteCond %{REQUEST_FILENAME} !-f
    RewriteCond %{REQUEST_FILENAME} !-d
    RewriteRule . /index.php [L]
</IfModule>
```
## XAMPP配置

如果使用的是XAMPP集成环境，只需要将项目源代码phalapi整个目录复制到xampp的htdocs目录下即可。打开XAMPP控制面板并启动Apache后，便可通过以下链接，访问默认接口服务。  
```
http://localhost/phalapi/public/
```

## 宝塔配置

安装前，请把 PhalApi 整个项目的源代码，解压放到 /www/wwwroot 目录，例如解压后目录为：/www/wwwroot/phalapi。  

进入宝塔后，点击：【网站】-【添加站点】：  
![](/images/20200107095815.png) 

在域名中输入自己的域名，例如：dev.phalapi.net，然后点【提交】。    

> 温馨提示：域名自定义，选择phalapi所在的public为根目录。  

![](/images/20240610-171716.png)  





# 访问

## 首页
安装好后，可以访问首页，例如：http://demo.phalapi.net/ 。  

![](/images/2022-11-12T09-54-16.420Z.png)  

## 接口列表页
以及在线接口文档列表页等，例如：http://demo.phalapi.net/docs.php 。  
![](/images/2022-11-25T09-56-51.150Z.png)  

## 接口详情页  

接口详情页，例如：http://demo.phalapi.net/docs.php?service=App.Hello.World&detail=1&type=fold 。  

![](/images/2022-11-25T10-03-34.983Z.png)  
    
## Hello World接口

请求Hello World接口，例如：  
```
http://demo.phalapi.net/?service=App.Hello.World&detail=1&type=fold
```

接口返回：  
```json
{"ret":200,"data":{"content":"Hello World!"},"msg":""}
```

格式化JSON后：  
```json
{
    "ret": 200,
    "data": {
        "content": "Hello World!"
    },
    "msg": ""
}
```

运行截图，  
![](/images/20221125-180149.png)  


> 演示环境：[http://demo.phalapi.net/](http://demo.phalapi.net/)。        

# 如何升级PhalApi 2.x框架？

在composer的管理下，升级PhalApi 2.x 版本系列非常简单。只需要修改composer.json文件，指定相应的版本即可。PhalApi的框架内核项目在[phalapi/kernal](https://github.com/phalapi/kernal)，你可以指定版本，也可以跟随最新版本。

例如，当需要指定PhalApi 2.0.1版本时，可以这样配置：
```json
{
    "require": {
        "phalapi/kernal": "2.0.1"
    }
}
```

当需要保持最新版本时，则可以改成： 
```json
{
    "require": {
        "phalapi/kernal": "2.*.*"
    }
}
```

这样，当PhalApi 2.x 有版本更新时，只需执行composer更新操作即可。对应命令操作为：  
```bash
$ composer update
```

至此，升级完毕！

#### 温馨提示：关于composer版本的说明，可参考[Composer中文文档 - 包版本](http://docs.phpcomposer.com/01-basic-usage.html#Package-Versions)。

  
