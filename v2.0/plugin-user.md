# 内置插件: User用户插件

User用户插件PhalApi内置插件，可以实现前台用户的注册、登录、会话检测、以及运营平台的统计、用户管理等功能。为应用的统一用户管理提供了完整的接口、后台和数据库。  

## 应用市场下载链接
默认已安装，如果需要单独安装，或单独升级User用户插件，可前往应用市场[免费下载 User用户插件](http://www.yesdev.cn/phalapi-user)。  

## user的DI服务
在User插件的启动文件中，已经注册了```\PhalApi\DI()->user```服务，

```php
$di->user = new \App\Common\User\User();
```

所以，```\PhalApi\DI()->user```服务提供了以下接口：  
 + ```\PhalApi\DI()->user->isLogin()```，是否已登录
 + ```\PhalApi\DI()->user->getProfile()```，获取当前用户的个人资料，返回一个数组
 + ```\PhalApi\DI()->user->id```，当前用户的ID，没有时为NULL
 + ```\PhalApi\DI()->user->username```，当前用户的账号，没有时为NULL
 + ```\PhalApi\DI()->user->nickname```，当前用户的昵称，没有时为NULL
 + ```\PhalApi\DI()->user->$name```，以此类推，获取用户的其他字段信息

## User用户插件配置

```php
<?php
/**
 * 用户插件
 */
return array(
    'common_salt' => '*#&FD)#f34', // 公共盐值，设定后不可修改，否则会导致用户的密码失效
    'max_expire_time' => 2592000,    //一个月，登录token有效时间
);
```

## User用户插件前台接口

 + 检测登录状态：App.User_User.CheckSession
 + 登录接口：App.User_User.Login
 + 获取我的个人信息：App.User_User.Profile
 + 注册账号：App.User_User.Register

![](http://cdn7.okayapi.com/yesyesapi_20200331131503_2a94340ae0b02273febf40ba39f905b2.png)

后面会继续升级完善，补充更多接口。  

## User用户插件运营平台管理

首页用户注册统计：  
![](http://cdn7.okayapi.com/yesyesapi_20200331131856_5363b9786cfcebe7b344745d1c2127d7.png)

用户管理：  
![](http://cdn7.okayapi.com/yesyesapi_20200331131605_f1655e5be028aa93c218b176714717ce.png)

后续会继续升级完善，补充更多功能。  


