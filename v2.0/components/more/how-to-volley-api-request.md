# 前言

在某些后台管理系统的演示站中，用户登录后，只能体验功能和查看演示数据，禁止写入操作。

具体是怎么实现的呢？

有多种方法。可以在前端写操作的时候进行判断和拦截，也可以在后端请求写操作接口的时候进行拦截。出于安全考虑，在后端进行拦截是相对合理的。

下面在phalapi的后端，拦截单个或者多个指定类型的接口请求。

# 实现

新建“phalapi/bin/inner_auth.php”

首先获取接口请求的服务名称，格式类似“Manage.Log_Update.CreateData”

其中，结尾的`CreateData`，就是请求的方法名。

客户端通过这个接口，进行数据的写入操作。

我们要在后台程序的入口，对所有写入操作的方法，进行拦截。



> 这里无法通过抛出PhalApi\Exception系列的异常，中断请求并返回错误信息。



针对开放接口，有 3 种方法可以重新改写返回的结构。

## 方法1

```php
<?php

/**
 * 整站读写权限控制
 * 演示站可在init入口文件内调用此功能，禁止用户进行写操作
 * @author feiYun
 */

use function \PhalApi\DI;

// 获取接口请求服务名称
$service = DI()->request->getService();
$method = substr($service, strripos($service, ".") + 1);   //获取接口服务方法

//判断全部的写入操作接口
switch ($method) {
    case 'CreateData':
    case 'DeleteDataIDs':
    case 'UpdateData':
        // 改写返回的结构
        DI()->response->setRet(400); //手动设置ret状态码
        DI()->response->setMsg('不可进行写入操作');  //手动设置msg提示消息
        DI()->response->setData(null);  //手动设置返回值
        DI()->response->output();  //返回内容
        exit();  //中断执行

        break;
    default:
}
```

如果你还编写有其他`写操作`相关的接口，如改密接口等，可以将相关的接口名，都加入到switch判断里。 

## 方法2

```php
// 改写返回的结构
$pai = new \PhalApi\PhalApi();
$res = $pai->response();

$res->setRet(400)->setMsg('不可进行写入操作')->setData(null)->output();
exit();  //中断执行
```

## 方法3

```php
// 改写返回的结构
$res = new \PhalApi\Response\JsonResponse();

$res->setRet(400)->setMsg('不可进行写入操作')->setData(null)->output();
exit();  //中断执行
```

# 调用

在“phalapi/public/init.php”入口文件中，加入调用代码

```php
// 整站权限控制：禁止写操作 By feiYun
include API_ROOT . '/bin/inner_auth.php';
```

当你需要开启整站禁止写操作时，即可调用上述代码来实现。

前端进行写入操作的时候，会直接报400错误并给出提示信息，达到禁止用户进行写操作的目的。
