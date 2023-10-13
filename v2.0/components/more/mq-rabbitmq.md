
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

### 服务管理
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

重启服务
```
sudo systemctl restart rabbitmq-server
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

可以通过扩展类库的方式来调用。
不过目前 phalapi2.x 版本还没有相应的扩展库。
你也可以在第三方框架如`gatewayWorker`中调用。

参考：[workerman/rabbitmq异步消息队列组件](https://www.workerman.net/doc/workerman/components/workerman-rabbitmq.html)

下面是在gatewayWorker中调用RabbitMQ的示例代码：
```php
/**
 * 异步保存日志
 *
 * @param string $msg 日志内容，支持普通字符串或数组格式
 * @param string $level 日志级别：logd(调试)/loge(错误)/logw(警告)/logi(信息)
 * @return void
 */
function log_asyn($msg, $level = 'logd')
{
    // 生产端send.php
    $queue_name = 'saveLog';   // 队列名称
    (new Client($this->options))->connect()->then(function (Client $client) {
        return $client->channel();
    })->then(function (Channel $channel)use ($queue_name) {
        /**
         * 创建队列(Queue)
         * name: ceshi         // 队列名称
         * passive: false      // 如果设置true存在则返回OK，否则就报错。设置false存在返回OK，不存在则自动创建
         * durable: true       // 是否持久化，设置false是存放到内存中RabbitMQ重启后会丢失,
         *                        设置true则代表是一个持久的队列，服务重启之后也会存在，因为服务会把持久化的Queue存放在硬盘上，当服务重启的时候，会重新加载之前被持久化的Queue
         * exclusive: false    // 是否排他，指定该选项为true则队列只对当前连接有效，连接断开后自动删除
         *  auto_delete: false // 是否自动删除，当最后一个消费者断开连接之后队列是否自动被删除
         */
        return $channel->queueDeclare($queue_name, false, true, false, false)->then(function () use ($channel) {
            return $channel;
        });
    })->then(function (Channel $channel) use ($queue_name,$msg, $level) {
        // echo "保存日志" . "\n";

        /**
         * 发送消息
         * body 发送的数据
         * headers 数据头，建议 ['content_type' => 'text/plain']，这样消费端是springboot注解接收直接是字符串类型
         * exchange 交换器名称
         * routingKey 路由key
         * mandatory
         * immediate
         * return bool|PromiseInterface|int 
         */
        $body = json_encode(array(
            'content' => $msg,
            'level' => $level,
        ));
        return $channel->publish($body, ['content_type' => 'text/plain'], '', $queue_name)->then(function () use ($channel) {
            return $channel;
        });
    })->then(function (Channel $channel) {
        //echo " [x] Sent 'Hello World!'\n";
        $client = $channel->getClient();
        return $channel->close()->then(function () use ($client) {
            return $client;
        });
    })->then(function (Client $client) {
        $client->disconnect();
    });
}
```

消费端示例：
```php
$tool = new Tool();
$options = array(
    'host' => '127.0.0.1',
    'port' => '5672',
    'user' => 'admin',
    'password' => 'admin',
    'debug' => true,
);

// 消费端receive.php
(new Client($options))->connect()->then(function (Client $client) {
    return $client->channel();
})->then(function (Channel $channel) {
    /**
     * 创建队列(Queue)
     * name: ceshi         // 队列名称
     * passive: false      // 如果设置true存在则返回OK，否则就报错。设置false存在返回OK，不存在则自动创建
     * durable: true       // 是否持久化，设置false是存放到内存中RabbitMQ重启后会丢失,
     *                        设置true则代表是一个持久的队列，服务重启之后也会存在，因为服务会把持久化的Queue存放在硬盘上，当服务重启的时候，会重新加载之前被持久化的Queue
     * exclusive: false    // 是否排他，指定该选项为true则队列只对当前连接有效，连接断开后自动删除
     *  auto_delete: false // 是否自动删除，当最后一个消费者断开连接之后队列是否自动被删除
     */
    $queue_name = 'saveLog';   // 队列名称
    return $channel->queueDeclare($queue_name, false, true, false, false)->then(function () use ($channel) {
        return $channel;
    });
})->then(function (Channel $channel) use (&$tool) {
    $queue_name = 'saveLog';   // 队列名称
    $channel->consume(
        function (Message $message, Channel $channel, Client $client) use (&$tool) {
            echo "保存日志：", $message->content, "\n";

            // 这里执行异步保存日志的代码。
            
        },
        $queue_name,
        '',
        false,
        true
    );

});
```


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

