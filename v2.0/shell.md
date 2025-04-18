# 脚本命令的使用

自动化是提升开发效率的一个有效途径。PhalApi致力于简单的接口服务开发，同时也致力于通过自动化提升项目的开发速度。为此，生成单元测试骨架代码、生成数据库建表SQL这些脚本命令。应用这些脚本命令，能快速完成重复但消耗时间的工作。下面将分别进行说明。  

# 1、phalapi-buildcode命令

## 生成PHP代码骨架

其使用说明是：  
```bash
$ ./bin/phalapi-buildcode 
Wecome to use ./bin/phalapi-buildcode command tool v0.0.1

Example:  ./bin/phalapi-buildcode --a User/Reg

Usage:  Command [options] [arguments]
  --a          创建一个API层文件
  --d          创建一个Domain层文件
  --m          创建一个Model层文件
```

> 温馨提示：./bin/phalapi-buildcode 需要PhalApi 2.19.0 及以上版本。  

## 运行效果

例如，生成一个PHP接口骨架文件。  
```bash
$ ./bin/phalapi-buildcode --a User/Reg
Api file created successfully.
```

会生成一个新的PHP接口文件 ```src/app/Api/User/Reg.php```，其PHP代码内容类似：  
```php
<?php
namespace App\Api\User;

use PhalApi\Api;

/**
 * Reg 接口模块名称
 */
class Reg extends Api {

    // 接口参数规则
    public function getRules() {
        return array(
           'doSth' => array(
            ),
        );
    }

    /**
     * 新接口标题
     * @desc 接口功能描述
     */
    public function doSth() {
        return array();
    }
}
```

成功生成新的接口文件后，刷新访问接口列表页，可以看到会出现一个新的接口模块。  
![](/images/20221202-162934.png)  

除了可以生成API接口PHP文件，此脚本还可以用于生成Domain和Model文件。当PHP文件已存在时，则不会重复创建也不会覆盖。  

![](/images/20221202-163403.png)  


# 2、phalapi-buildtest命令

当需要对某个类进行单元测试时，可使用phalapi-buildtest命令生成对应的单元测试骨架代码。  


## 生成单元测试代码骨架

其使用说明如下：  

![](http://cdn7.phalapi.net/20170725232117_3fb828887ae30e22c8d4f02aa5d9aa26)  
 
  
其中，

 + **第一个参数file_path**  是待测试的源文件相对/绝对路径 。 
 + **第二个参数class_name**  是待测试的类名。  
 + **第三个参数bootstrap**  是测试启动文件，通常是/path/to/phalapi/tests/bootstrap.php文件。  
 + **第四个参数author** 你的名字，默认是dogstar。  
   
通常，可以先写好类名以及相应的接口，然后再使用此脚本生成单元测试骨架代码。以默认接口服务```Site.Index```接口服务为例，当需要为其生成单元测试骨架代码时，可以执行以下命令。  
```bash
$ ./bin/phalapi-buildtest ./src/app/Api/Site.php App\\Api\\Site > ./tests/app/Api/Site_Test.php
```
  
最后，需要将生成好的骨架代码，重定向保存到你要保存的位置。通常与产品代码对齐，并以“{类名} + _Test.php”方式命名，如这里的app/Api/Site_Test.php。  

## 运行效果

生成的单元测试骨架代码类似如下：  
```php
<?php

//require_once dirname(__FILE__) . '/bootstrap.php';

if (!class_exists('App\\Api\\Site')) {
    require dirname(__FILE__) . '/./src/app/Api/Site.php';
}

/**
 * PhpUnderControl_App\Api\Site_Test
 *
 * 针对 ./src/app/Api/Site.php App\Api\Site 类的PHPUnit单元测试
 *
 * @author: dogstar 20170725
 */

class PhpUnderControl_AppApiSite_Test extends \PHPUnit_Framework_TestCase
{
    public $appApiSite;

    protected function setUp()
    {
        parent::setUp();

        $this->appApiSite = new App\Api\Site();
    }

    ... ...
```

简单修改后，便可运行。 


# 3、phalapi-buildsqls命令

当需要创建数据库表时，可以使用phalapi-buildsqls脚本命令，再结合数据库配置文件./config/dbs.php即可生成建表SQL语句。此命令在创建分表时尤其有用。  

## 生成建表SQL语句

其使用说明如下：  

![](http://cdn7.phalapi.net/20170725232919_e6d034485ed2c5f208d6e5b6c34ae555)  

  
其中，

 + **第一个参数dbs_config** 是指向数据库配置文件的路径，如./Config/dbs.php，可以使用相对路径。  
 + **第二个参数table**  是需要创建sql的表名，每次生成只支持一个。  
 + **第三个参数engine**  可选参数，是指数据库表的引擎，MySQL可以是：Innodb或者MyISAM。  
 + **第四个参数sqls_folder** 可选参数，SQL文件的目录路径。
  
## 运行效果 
在执行此命令先，需要提前先将建表的SQL语句，排除除主键id和ext_data字段，放置到./data目录下，文件名为：{表名}.sql。  
  
例如，我们需要生成10张user_session用户会话分表的建表语句，那么需要先添加数据文件./data/user_session.sql，并将除主键id和ext_data字段外的其他建表语句保存到该文件。   
```sql
      `user_id` bigint(20) DEFAULT '0' COMMENT '用户id',
      `token` varchar(64) DEFAULT '' COMMENT '登录token',
      `client` varchar(32) DEFAULT '' COMMENT '客户端来源',
      `times` int(6) DEFAULT '0' COMMENT '登录次数',
      `login_time` int(11) DEFAULT '0' COMMENT '登录时间',
      `expires_time` int(11) DEFAULT '0' COMMENT '过期时间',
```
  
然后，进入到项目根目录，执行命令：  
```bash
$ php ./bin/phalapi-buildsqls ./config/dbs.php user_session
```
  
正常情况下，会看到生成好的SQL语句，类似下面这样的输出。    
```sql
CREATE TABLE `phalapi_user_session_0` (
      `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
      `user_id` bigint(20) DEFAULT '0' COMMENT '用户id',
      `token` varchar(64) DEFAULT '' COMMENT '登录token',
      `client` varchar(32) DEFAULT '' COMMENT '客户端来源',
      `times` int(6) DEFAULT '0' COMMENT '登录次数',
      `login_time` int(11) DEFAULT '0' COMMENT '登录时间',
      `expires_time` int(11) DEFAULT '0' COMMENT '过期时间',
      `ext_data` text COMMENT 'json data here',
      PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `phalapi_user_session_1` (
      `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
      ... ...
      `ext_data` text COMMENT 'json data here',
      PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `phalapi_user_session_2` ... ...
CREATE TABLE `phalapi_user_session_3` ... ...
CREATE TABLE `phalapi_user_session_4` ... ...
CREATE TABLE `phalapi_user_session_5` ... ...
CREATE TABLE `phalapi_user_session_6` ... ...
CREATE TABLE `phalapi_user_session_7` ... ...
CREATE TABLE `phalapi_user_session_8` ... ...
CREATE TABLE `phalapi_user_session_9` ... ...
```
  
最后，便可把生成好的SQL语句，导入到数据库，完成建表的操作。  

## 注意事项

值得注意的是，生成的SQL建表语句默认会带有自增ID主键id和扩展字段ext_data这两个字段。所以保存在./data目录下的建表语句可省略主键字段，以免重复。    
```sql
      `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
      ... ...
      `ext_data` text COMMENT 'json data here',
```

# 4、生成数据库字典

## phalapi_build_database_wiki.php脚本    

使用以下脚本命令，可以直接根据数据库配置文件```./config/dbs.php```生成对应数据库的数据库字典。  

```bash
$ php ./bin/phalapi_build_database_wiki.php
```

运行结果类似：  
```bash
开始生成数据库字典文件 phalapi ... 
/path/to/phalapi//data/phalapi_database_wiki.md 已保存！
```

成功生成保存后，可直接查看对应的数据库字典markdown文件，内容类似如下：  
```markdown
## phalapi_user表结构 
字段|类型|默认值|是否允许为NULL|索引|注释  
---|---|---|---|---|---  
id|int(10) unsigned||不为NULL|PRI|UID  
username|varchar(100)||不为NULL|UNI|用户名  
nickname|varchar(50)||允许NULL||昵称  
password|varchar(64)||不为NULL||密码  
salt|varchar(32)||允许NULL||随机加密因子  
reg_time|int(11)|0|允许NULL||注册时间  
avatar|varchar(500)||允许NULL||头像  
mobile|varchar(20)||允许NULL||手机号  
sex|tinyint(4)|0|允许NULL||性别，1男2女0未知  
email|varchar(50)||允许NULL||邮箱  
```

数据库字典，通过在线方式查看，效果类似：  
![](/images/db-wiki-20250331-110942.png)  

通过此命令，可以快速生成数据库字典，减少人工整理的成本，提高开发、沟通和交付效率。  

> 温馨提示：此脚本发布于PhalApi 2.23.3版本。 

# 5、phalapi-cli命令

此脚本可用于在命令行终端，直接运行接口服务，也可用于作为命令行终端应用的执行入口。

## 执行接口

如果未指定需要运行的接口服务名称，将会得到以下的使用说明提示：      
```bash
$ ./bin/phalapi-cli
Usage: ./bin/phalapi-cli [options] [operands]

Options:
  -s, --service <arg>  接口服务
  -h, --help           查看帮助信息


Service:   
缺少service参数，请使用 -s 或 --service 指定需要调用的API接口。
```

## 运行效果

以 App.Hello.World 接口为例，执行方式如下：  

```
$ ./bin/phalapi-cli -s App.Hello.World   

Service: App.Hello.World
{
    "ret": 200,
    "data": {
        "content": "Hello World!"
    },
    "msg": ""
}
```

> 温馨提示：为方便查看接口执行结果，进行了JOSN美化格式输出显示。  

如果想查看帮助提示信息，可以在指定了接口服务后，使用```-h```参数。例如：  

```bash
$ ./bin/phalapi-cli -s App.Examples_Rule.SexEnum -h
Usage: ./bin/phalapi-cli [options] [operands]

Options:
  -s, --service <arg>  接口服务
  -h, --help           查看帮助信息
  --sex [<ENUM>]       性别，female为女，male为男。
```

如果缺少必要的接口参数，则会进行提示。例如：  
```bash
$ php ./bin/phalapi-cli --service App.User_User.Register
Usage: ./bin/phalapi-cli [options] [operands]

Options:
  -s, --service <arg>  接口服务
  -h, --help           查看帮助信息
  --username <arg>     必须；账号，账号需要唯一
  --password <arg>     必须；密码
  --avatar [<arg>]     默认 ；头像链接
  --sex [<INT>]        默认 0；性别，1男2女0未知
  --email [<arg>]      默认 ；邮箱
  --mobile [<arg>]     默认 ；手机号


Service: App.User_User.Register
缺少username参数，请使用 --username 指定：账号，账号需要唯一
```

![](/images/20221208-174039.png)  

> 温馨提示：phalapi-cli 会对接口参数的类型、是否必须、默认值等进行说明和提示。      

## 扩展帮助说明  

如果需要定制你的命令脚本的帮助说明，可以重载```PhalApi\CLI\Lite::getHelpText($text)```方法。例如，修改```./bin/phalapi-cli```脚本，改为：  
```php
#!/usr/bin/env php
<?php
require_once dirname(__FILE__) . '/../public/init.php';

class MyCLI extends PhalApi\CLI\Lite {

    // 自定义帮助说明
    protected function getHelpText($text) {
        // 在原有的帮助说明，后面追加自己的文字  
        $context = "--- 自定义的帮助说明 ---" . PHP_EOL;
        
        return $text . PHP_EOL . $context;
    }
}

$cli = new MyCLI();
$cli->response();

```

执行后效果是：  
```bash
$ php ./bin/phalapi-cli
Usage: ./bin/phalapi-cli [options] [operands]

Options:
  -s, --service <arg>  接口服务
  -h, --help           查看帮助信息


--- 自定义的帮助说明 ---

Service: 
缺少service参数，请使用 -s 或 --service 指定需要调用的API接口
```


### 扩展接口命令列表

可以重载扩展 ```PhalApi\CLI\Lite::getServiceList()```方法。返回一个数组，在里面配置：  
```
array(
  编号 => array('service接口服务名称', '功能说明'),
)
```

例如，  
```php
class MyCLI extends PhalApi\CLI\Lite {

    // 提供接口列表，service -> 接口功能说明
    protected function getServiceList() {
        return array(
            1 => ['App.Hello.World', '演示接口'],
        );
    }
}

```

运行效果是：  
```bash
$ ./bin/phalapi-cli
Usage: ./bin/phalapi-cli [options] [operands]

Options:
  -s, --service <arg>  接口服务
  -h, --help           查看帮助信息


--- 自定义的帮助说明 ---

Service: 
1)  App.Hello.World       演示接口

缺少service参数，请使用 -s 或 --service 指定需要调用的API接口。
```

然后，可以使用快速编号执行对应的接口命令，如：  
```bash
$ ./bin/phalapi-cli -s 1

Service: App.Hello.World
{
    "ret": 200,
    "data": {
        "content": "Hello World!"
    },
    "msg": ""
}
```

### 扩展公共命令参数  

可以加工处理以下方法：  
```
    // 完成命令行参数获取后的操作，方便追加公共参数
    protected function afterGetOptions($options) {
        return $options;
    }
```

## 注意事项

需要注意的是，要先确保在composer.json文件内有以下配置：

```
{
    "require": {
        "phalapi/cli": "^3.0"
    }
}
```
并确保已经成功安装phalapi/cli。  

> phalapi/cli扩展地址：[https://github.com/phalapi/cli](https://github.com/phalapi/cli)。  
> 2022年11月23号，此扩展发布更新了v3.1.0 版本。  

## 参考和依赖  

phalapi/cli使用了[GetOpt.PHP](https://github.com/getopt-php/getopt-php)进行命令参数的获取的解析。  

关于更多关于php处理命令行参数，或者需要定制自己和升级命令行处理的参数格式，可以参考[GetOpt.php的官方文档-Example](http://getopt-php.github.io/getopt-php/example.html)。   


# 6、生成Model源代码  

## 一键生成全部DataModel源代码

如果项目本来已经有数据库表，或者新项目时设计好了一批数据库表，这时，可以使用脚本```./bin/phalapi_build_data_model.php```迅速一键生成全部的DataModel源代码。  

这将能极大提升开发的效率。  

## bin/phalapi_build_data_model.php脚本说明

```
$ php ./bin/phalapi_build_data_model.php 

Usage:
./bin/phalapi_build_data_model.php <dbs_config> [table] [project=app]

Options:
    dbs_config        Require. Database config file name, such as dbs.php
    table             NOT Require. Table name, default is ALL tables
    project           NOT require. Project name to save PHP code, default is app

Demo:
    ./bin/phalapi_build_data_model.php dbs.php 
```

第一个参数是指使用哪份数据库配置，第二个参数是指为哪张表生成代码（不指定时生成全部表的代码），第三个参数是指需要保存在哪个项目。  

以下是一个运行的示例，例如：
```
$ php ./bin/phalapi_build_data_model.php dbs2.php phalapi_curd
开始处理表：phalapi_curd ...
Model代码已生成到：/Users/dogstar/projects/github/phalapi/bin/../src/app/Model/Curd.php ...
Model基类代码已生成到：/Users/dogstar/projects/github/phalapi/bin/../src/app/Model/Base.php ...
```

查看新生成的文件：./src/app/Model/Curd.php，有以下代码：  
```php
<?php
namespace App\Model;

class Curd extends Base {

    public function getTableName($id) {
        return 'curd';
    }
}
```

有多少张表，就会有多少份对应的类文件。类文件存在时不会覆盖原有文件。  

类似效果如下：  
![](http://cd8.yesapi.net/yesyesapi_20200701102842_82fc40082119847d4e503990b1f1bb2b.png)

此外，最后还会生成一个Model基类文件，方便切换数据库，或进行通用的操作封装。  

```php
<?php
namespace App\Model;

/**
 * 连接其他数据库
 * - 当需要连接和操作其他数据库时，请在Model继续此基类，以便切换数据库
 * - 或在此基类进行通用操作的封装
 */
class Base extends \PhalApi\Model\DataModel {

    /**
     * 切换数据库
     * @return \PhalApi\Database\NotORMDatabase
     */
    protected function getNotORM() {
        return \PhalApi\DI()->notorm;
    }
}
```

> 温馨提示：此脚本发布于PhalApi 2.15.0版本。  



# 统一注意事项

在使用这些脚本命令前，需要注意以下几点。  

## 执行权限

第一点是执行权限，当未设置执行权限时，脚本命令会提示无执行权限，类似这样。  
```bash
$ ./phalapi/bin/phalapi-buildtest 
-bash: ./phalapi/bin/phalapi-buildtest: Permission denied
```
那么需要这样设置脚本命令的执行权限。  
```bash
$ chmod +x ./phalapi/bin/phalapi-build*
```
  
## 编码问题

其次，对于Linux平台，可能会存在编码问题，例如提示：  
```bash
$ ./phalapi/bin/phalapi-buildtest 
bash: ./phalapi/bin/phalapi-buildtest: /bin/bash^M: bad interpreter: No such file or directory
```
这时，可使用dos2unix命令转换一下编码。  
```bash
$ dos2unix ./phalapi/bin/phalapi-buildtest*
dos2unix: converting file ./phalapi/bin/phalapi-buildsqls to Unix format ...
dos2unix: converting file ./phalapi/bin/phalapi-buildtest to Unix format ...
```

## 软链

最后一点是，在任意目录位置都是可以使用这些命令的，但会与所在的项目目录绑定。通常，为了更方便使用这些命令，可以将这些命令软链到系统命令下。例如：  
```bash
$ sudo ln -s /path/to/phalapi/bin/phalapi-buildsqls /usr/bin/phalapi-buildsqls
$ sudo ln -s /path/to/phalapi/bin/phalapi-buildtest /usr/bin/phalapi-buildtest
```

# 编写你的脚本和定时任务

很多时候，你需要编写自己的脚本、命令和定时任务。例如：手动执行脚本进行业务的处理，配置crontab定时任务执行数据统计。  

当需要编写CLI命令终端的脚本时，可以统一放置在 ```./bin``` 目录下。其模板类似如下：  

```php
/**
 * XXXX脚本命令
 * @author dogstar 2022-02-22
 */

// 统一引入初始化文件
require_once dirname(__FILE__) . '/../public/init.php';

// 根据需要判断命令参数
if ($argc < 2) {
    echo "Usage: {$argv[0]} <xxx>" . PHP_EOL;
    echo "请输入必要的参数。" . PHP_EOL;
    echo PHP_EOL;
    exit;
}

// 参数获取
$xxx = trim($argv[1]);

// TODO: 业务处理

// 结果输出

echo "执行完毕！" . PHP_EOL;

```

> 假设保存的脚本文件是：bin/expire_out_warn.php  

如果需要配置crontab定时计划任务，可以参考以下配置：  

```bash
$ crontab -e
#0 16 * * * /usr/bin/php /path/to/phalapi/bin/expire_out_warn.php >> /var/log/phalapi/crontab/expire_out_warn.log 2>&1
```

你也可以手动在命令终端执行，例如：  

```bash
$ cd /path/to/phalapi
$ php ./bin/expire_out_warn.php
```
