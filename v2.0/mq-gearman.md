# MQ队列

PhalApi可以轻松与各MQ队列进行整合使用。  

> 在API接口同步请求过程中，不适合处理耗时过长、或者一直轮询的工作。此时，可以结合MQ异步队列任务进行后台处理。

## Gearman安装
待补充

## Gearman整合

[PhalApi+Gearman，接口MQ异步队列任务的完整开发教程](https://blog.csdn.net/qq_17324713/article/details/127412209)

下面以Gearman队列为例，讲解如何进行整合、开发和使用。  

### 在Api层写入队列

通常，是在Api层把需要处理的数据，写入到队列。例如：   
```php
<?php
namespace App\Api;
use PhalApi\Api;

/**
 * 计划任务
 */
class AppTask extends Api {
    public function push() {
        $rs = ['err_code' => 0, 'err_msg' => ''];

        // 在你需要的地方，写入队列
        $data = [
            'user_id' => 1,
            'time' => time(),
        ];
        $gmclient= new \GearmanClient();
        $gmclient->addServer();
        $gmclient->doBackground("after_app_task_push", json_encode($data));

        return $rs;
    }
}
```

### 在bin目录里编写MQ消费脚本

接下来，切换到后台CLI模式，在bin目录下编写MQ消费脚本。 

例如：```./bin/gearman_client_after_app_task_push.php```脚本代码如下：  

```php
<?php
/**
 * MQ任务
 */
require_once dirname(__FILE__) . '/../public/init.php';

// 创建对象
$gmworker= new GearmanWorker();

// 添加服务
$gmworker->addServer();

// 注册回调函数
$gmworker->addFunction("after_app_task_push", "gearman_client_after_app_task_push");

print "开始等待队列……\n";
while($gmworker->work())
{
    if ($gmworker->returnCode() != GEARMAN_SUCCESS)
    {
        echo "return_code: " . $gmworker->returnCode() . "\n";
        break;
    }
}

// 编写你的回调处理函数
function gearman_client_after_app_task_push($job)
{
    // 获取提交数据
    $workload= $job->workload();
    $workload = json_decode($workload, true);

    $user_id = $workload['user_id'];

    echo "user_id: {$user_id} ...\n";

    return true;
}
```

### 执行

编写完成后，可直接执行，以便测试。  

```
php ./bin/gearman_client_after_app_task_push.php
```

测试通过没问题后，便可放到后台执行。使用```nohub```命名：  
```
nohub php /path/to/phalapi/bin/gearman_client_after_app_task_push.php >> /path/to/phalapi/bin/gearman_client_after_app_task_push.log 2>&1 &
```

### 守护进程与停止脚本

可以加一个守护进程的脚本```./bin/gearman_client_deamon.sh```：   
```bash
#!/bin/bash
# gearman守护进程

# 当前数量
cur_client_num=`ps -ef| grep gearman_client_after_app_task_push.php |grep -v grep|wc -l`

# 最大数量
MAX_CLIENT_NUM=20

source /etc/environment

for((i=$cur_client_num;i<$MAX_CLIENT_NUM;i++));
do
    nohub php /path/to/phalapi/bin/gearman_client_after_app_task_push.php >> /path/to/phalapi/bin/gearman_client_after_app_task_push.log 2>&1 &
done
```

再加一个停止的脚本```./bin/gearman_client_deamon.sh```：  
```bash
#!/bin/bash

kill `ps -ef| grep gearman_client_after_app_task_push.php |grep -v grep | awk '{print $2}'`
```

## RabbitMQ整合

### CentOS7安装RabbitMQ

#### 安装 lrzsz 
文件拉取工具，方便上传本地文件。
```
yum -y install lrzsz
```

#### 下载erlang
查看安装的[RabbitMQ与erlang的版本对应关系](http://www.rabbitmq.com/which-erlang.html)。
使用 wget 命令，例如：我的 Linux 系统是 CentOS7 ，使用的RabbitMQ是3.8.9，erlang是23.x（官方组合）。
这三者的版本号，必须相匹配。

```
wget -P /home/download https://github.com/rabbitmq/erlang-rpm/releases/download/v23.0/erlang-23.0-1.el7.x86_64.rpm
```

> 虚拟机可能报错”无法建立 SSL 连接“，此时需要将 https 替换为 http，再试一次，如果还是无法下载，那么只能通过本地上传的方式处理

#### 安装 Erlang
```
sudo rpm -Uvh /home/download/erlang-23.0-1.el7.x86_64.rpm
```

#### 安装 socat
```
sudo yum install -y socat
```

#### 下载rpm安装包
```
wget -P /home/download https://github.com/rabbitmq/rabbitmq-server/releases/download/v3.8.9/rabbitmq-server-3.8.9-1.el7.noarch.rpm
```

#### 安装RabbitMQ
```
sudo rpm -Uvh /home/download/rabbitmq-server-3.8.9-1.el7.noarch.rpm
```

### 启动和关闭
启动服务
```
sudo systemctl start rabbitmq-server
```

查看状态
```
sudo systemctl status rabbitmq-server
```

停止服务
```
sudo systemctl stop rabbitmq-server
```

设置开机启动
```
sudo systemctl enable rabbitmq-server
```

### 开启web管理插件

#### 开启插件
```
rabbitmq-plugins enable rabbitmq_management
```

说明：rabbitmq有一个默认的guest用户，但只能通过localhost访问，所以需要添加一个能够远程访问的用户。

#### 添加用户
测试账号和密码都是admin，你也可以设置为其他内容。
```
rabbitmqctl add_user admin admin
```

#### 为用户分配操作权限
```
rabbitmqctl set_user_tags admin administrator
```

#### 为用户分配资源权限
```
rabbitmqctl set_permissions -p / admin ".*" ".*" ".*"
```

#### 查看vhost（/）允许哪些用户访问
```
rabbitmqctl list_permissions -p /
```

#### 查看用户列表
```
rabbitmqctl list_users
```

### 添加防火墙规则
RabbitMQ 服务启动后，还不能进行外部通信，需要将端口添加到防火墙

#### 开放4个端口
```
sudo firewall-cmd --zone=public --add-port=4369/tcp --permanent
sudo firewall-cmd --zone=public --add-port=5672/tcp --permanent
sudo firewall-cmd --zone=public --add-port=25672/tcp --permanent
sudo firewall-cmd --zone=public --add-port=15672/tcp --permanent
```

#### 重启防火墙
```
sudo firewall-cmd --reload
```

#### 放行云服务器端口
腾讯云的云服务器的实例——安全组，添加入站规则：放行5672和15672端口

### 浏览器访问测试
浏览器输入：http://ip:15672，例如：http://192.168.235.102:15672，
输入前面设置的访问用户与密码，即可访问后台。


### 调用RabbitMQ

待补充。

## NSQ整合

待补充。


## 常见问题

### 运行日志有必要放在队列里保存吗？
日志保存的操作在大多数情况下，不需要放在队列里处理。原因如下:
1. 日志保存通常是一个相对简单的操作,不会占用太多资源。直接同步执行不会对系统性能产生较大影响。
2. 日志记录的目的通常是追踪问题或记录用户行为,需要及时入库。如果放入队列延后执行,可能会导致日志保存滞后,达不到预期效果。
3. 只有在日志量非常大的情况下,日志保存操作对数据库造成很大压力,可能会引起性能问题。这种情况下,使用队列进行异步处理会有优势。例如可以先写入队列,然后后台从队列中批量获取日志写入数据库。
4. 即使在日志量大的情况,也需要对系统性能影响进行评估后，再决定是否使用队列。如果日志保存操作不会对关键请求流程产生明显影响,直接同步执行也可以接受。

综上,日志保存操作一般情况下不需要使用队列异步处理。只有当日志量极大,日志操作会严重影响系统性能时,才有必要考虑使用队列进行异步批量保存来优化流程。
但如果系统使用队列架构,并且日志量不大,使用队列进行日志保存也无妨,不会有较大影响。只是引入额外的系统复杂性,需要权衡效益。

简单来说,日志保存是否放入队列处理取决于:
1. 日志量大小,是否会影响关键请求流程的性能;
2. 系统是否本来采用队列架构;
3. 异步处理的优势是否超过增加的系统复杂性。


