# 运行Hello World

此文章假设你已成功安装PhalApi2项目，如果尚未安装，可阅读[下载与安装](http://docs.phalapi.net/#/v2.0/download-and-setup)。  

# 编写第一个接口

在PhalApi 2.x 版本中，项目源代码放置在/path/to/PhalApi2/src目录中。里面各个命名空间对应一个子目录，默认命名空间是app，里面主要有Api、Domain、Model这三个目录以及存放函数的functions.php文件。例如像是这样的目录结构：  
```bash
./src/
└── app
    ├── Api # 放置接口源代码，相当于控制器层
    ├── Common # 公共代码目录，放置工具等
    ├── Domain # 领域业务层，负责业务逻辑和处理
    ├── functions.php
    └── Model # 数据源层，负责数据持久化存储及操作
```

当需要新增一个接口时，先要在Api层添加一个新的接口文件。例如对于Hello World示例，可以使用你喜欢的编辑器创建一个./src/app/Api/Hello.php文件，并在里面放置以下代码。  
```php
// 文件 ./src/app/Api/Hello.php
<?php
namespace App\Api;

use PhalApi\Api;

/**
 * HelloWorld接口
 */
class Hello extends Api {

    public function getRules() {
        return array(
            'world' => array(
                'username' => array('name' => 'username', 'desc' => '账号名称'),
            ),
        );
    }

    /**
     * 接口标题名称
     * @desc 接口功能描述
     */
    public function world() {
        return array('content' => 'Hello ' . $this->username);
    }
}
```

> 温馨提示：本次源代码有标注行号，只为首次介绍说明。后续文档不会再标注代码行号，方便读者快速复制源代码。  

编写接口时，需要特别注意：  

 + 1、默认所在命名空间必须为```App\Api``` (第2行)
 + 2、具体实现的接口类必须是```PhalApi\Api```的子类 （第4行、第9行）
 + 3、定义接口方法，必须为public访问权限  （第23行）
 + 4、接口参数，放置在getRules()函数方法中  （第11行）
 + 5、返回业务的数据，对应data返回字段，推荐返回对象结构，方便扩展 （第24行）

# 访问接口

 通常情况下，建议可访问的根路径设为/path/to/PhalApi2/public。若未设置根目录为public目录，此时接口访问的URL格式为：```接口域名/public/?s=Namespace.Class.Action```。其中，s参数用于指定待请求的接口服务，由三部分组成。分别是：    

组成部分|是否必须|默认值|说明
---|---|---|---
Namespace|可选|App|Api命名空间前缀，多级命名空间时用下划线分割，缺省命名空间为App
Class|必须|无|待请求的接口类名，通常首字母大写，多个目录时用下划线分割
Action|必须|无|待请求的接口类方法名，通常首字母大写。若Class和Action均未指定时，默认为Site.Index

> 温馨提示：s参数为service参数的缩写，即使用```?s=Class.Action```等效于```?service=Class.Action```，两者都存在时优先使用service参数。

例如，上面新增的Hello World接口的访问链接为：  
```
http://dev.phalapi.net/?s=Hello.World
```

或者可以使用完整的写法，带上命名空间App：  
```
http://dev.phalapi.net/?s=App.Hello.World
```

# 接口返回

默认情况下，接口的结果以JSON格式返回，并且返回的顶级字段有状态码ret、业务数据data，和错误提示信息msg。其中data字段对应接口类方法返回的结果。如Hello Wolrd示例中，返回的结果是：  
```
{"ret":200,"data":{"title":"Hello World!"},"msg":""}
```

JSON可视化后是：  
```
{
    "ret": 200,
    "data": {
        "title": "Hello World!"
    },
    "msg": ""
}
```

# 目录结构

PhalApi 开源框架的项目目录结构如下，

```
./phalapi
├── README.md # 简介
├── bin # 脚本目录
├── config # 配置目录
│   ├── app.php # 应用配置
│   ├── dbs.php # 数据库配置
│   ├── di.php # 依赖服务配置
│   └── sys.php #系统配置
├── data # 数据库
│   └── phalapi.sql # 数据库安装时的文件
├── language # 翻译包
├── public # 对外访问的目录
│   ├── docs # 离线生成的HTML接口文档
│   ├── docs.php # 在线版接口文档访问入口
│   ├── index.php
│   ├── init.php # 全局初始化文件
│   ├── static # 静态资源
│   ├── uploads # 上传目录（需要有写入权限）
│   └── phalapi_logo.png # logo图片
├── runtime # 运行目录
│   ├── cache # 文件缓存
│   └── log # 文件日志
├── sdk # SDK包
├── src # 项目源代码，非常重要
│   ├── app # 接口源代码（遵循ADM模式）
│   │   ├── Api # 放置接口源代码，相当于控制器层
│   │   ├── Common # 公共代码目录，放置工具等
│   │   ├── Domain # 领域业务层，负责业务逻辑和处理
│   │   ├── functions.php # 公共函数库
│   │   └── Model # 数据源层，负责数据持久化存储及操作
│   └── view # 页面模板目录（如接口文档）
├── tests # 单元测试
└── vendor # composer包，不需要手动修改，通过composer install/update可进行安装和更新
```



### 恭喜！你已顺便完成PhalApi 2.x 简单的接口开发了！  

