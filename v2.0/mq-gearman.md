# MQ队列

PhalApi可以轻松与各MQ队列进行整合使用。  

## Gearman整合

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
使用 wget 命令，例如：我的 Linux 系统是 CentOS7 ，使用的RabbitMQ是3.8.9，erlang是23.x（官方组合）
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
#### 启动服务
```
sudo systemctl start rabbitmq-server
```

#### 查看状态
```
sudo systemctl status rabbitmq-server
```

#### 停止服务
```
sudo systemctl stop rabbitmq-server
```

#### 设置开机启动
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

#### 添加4个端口
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
腾讯云的云服务器的实例——安全组，添加入站规则：放行5672端口和15672端口

### 浏览器访问测试
浏览器输入：http://ip:15672，例如：http://192.168.235.102:15672
输入访问用户admin与密码admin，即可访问。


### 调用RabbitMQ

待补充。

## NSQ整合

待补充。
