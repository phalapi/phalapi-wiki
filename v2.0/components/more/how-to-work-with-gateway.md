# 如何将phalapi和GatewayWorker结合使用

workman如何调用phalapi接口处理数据？
如何在phalapi接口中调用workman推送数据？

使用phalapi时，开发者最关心的是如何与其他框架或库进行整合，以实现功能互补和增强。

例如，要在phalapi项目中，实现websocket双向通信，就需要用到第三方库。

根据用户`@帅驴老刘` 在微信群的提示，phalapi和gateway结合使用，大致有以下两种方法：
- 可以把Gateway这个类稍加改造，集成到`$di`
- 也可以把Gateway这个类封装成一个Domain

这篇文章，将使用第2种方法，结合Layui前端框架，和workman文档、GatewayWorker文档、ChatGpt代码生成、websocket在线测试等工具，实现websocket双向通信。

> [GatewayWorker](https://www.workerman.net/doc/gateway-worker/)是基于[Workerman](https://www.workerman.net/doc/workerman/)开发的一个可分布式部署的TCP长连接框架，专门用于快速开发TCP长连接应用，例如app推送服务端、即时IM服务端、游戏服务端、物联网、智能家居等等。该框架的作者比较活跃，对社区的各种用户问题常常能给与及时回复。

> Workerman本身常驻内存，不依赖Apache、nginx、php-fpm这些容器，拥有超高的性能。同时支持TCP、UDP、UNIXSOCKET，支持长连接，支持Websocket、HTTP、WSS、HTTPS等通讯协议以及各种自定义协议。拥有定时器、异步socket客户端、异步Redis、异步Http、异步消息队列等众多高性能组件。

熟练掌握本文的方法以后，你可以调用wrokerman的所有类和组件，结合phalapi提供的功能，实现更强大的编程技术。

WorkerMan提供了Worker类、TcpConnection类、AsyncTcpConnection类、AsyncUdpConnection类、Timer定时器类、HTTP服务类，MYSQL组件、Redis组件、异步Http组件、异步消息队列组件、Crontab定时任务组件等。此外，还提供了HTTP协议、WebSocket协议以及非常简单的Text文本协议、可用于二进制传输的frame协议等。

# 开发环境及开发工具
- macOS + VSCode
- 宝塔Linux环境 + php7.4
- 腾讯云服务器 + 域名
- websocket在线测试工具

# 总体原则
- Phalapi项目与GatewayWorker独立部署，互不干扰
- 所有的业务逻辑都由网站前端页面post/get到Phalapi框架中完成
- GatewayWorker不接受客户端发来的数据，即GatewayWorker不处理任何业务逻辑，GatewayWorker仅仅当做一个单向的推送通道
- 仅当Phalapi框架需要向浏览器主动推送数据时，才在Phalapi框架中调用Gateway的API GatewayClient完成推送
- GatewayWorker通过异步http请求，和phalapi框架的api接口进行通信

# 下载
[GatewayWorker官方下载](https://www.workerman.net/download/GatewayWorker.zip)

将文件解压后，上传到phalapi同级目录。遵循上述原则，这两个框架是分开部署的

![](../../images/WX20230609-200414@2x.png)

# 安装Composer

在`GatewayWorker`目录，执行如下命令，安装composer.phar
```shell
curl -sS https://getcomposer.org/installer | php
```

执行install命令

```shell
php composer.phar install
```

更新目录和依赖

```shell
php composer.phar update
```

# websocket连接测试

由于源码下载下来后，默认的应用层协议是tcp协议，因此需要修改协议为websocket

打开文件`GatewayWorker/Applications/YourApp/start_gateway.php`，
修改`$gateway`进程地址

```php
$gateway = new Gateway("websocket://0.0.0.0:8282");
```

这里使用websocket协议，端口为8282

在宝塔或远程shell工具的命令行里，调用`php start.php start`，
启动GatewayWorker服务，这个服务是常驻在内存中的

在网上找一款`WebSocket在线测试工具`，输入云服务器的IP和socket端口号，进行连接测试，确保websocket连接成功。

如果连接不成功，请查询workman手册或者通过社区搜索解决。

连接日志：
```
你 22:20:21
等待服务器Websocket握手包...
你 22:20:21
收到服务器Websocket握手包.
服务器 22:20:21
Websocket连接已建立，正在等待数据...
服务器 22:20:21
Hello 7f0000010b5700000001\r\n
服务器 22:20:21
7f0000010b5700000001 login\r\n
```

# GatewayWorker设置

以下是主要的设置，供你参考
```php
////GatewayWorker/Applications/YourApp/start_gateway.php

// gateway 进程，这里使用websocket协议
$gateway = new Gateway("websocket://0.0.0.0:8282");

// 服务注册地址
$gateway->registerAddress = '127.0.0.1:1238';

// 心跳设置
// https://www.workerman.net/doc/gateway-worker/heartbeat.html
$gateway->pingInterval = 55;  //客户端连接 ？ 秒内，没有任何数据传输给服务端，则服务端认为对应客户端已经掉线，服务端关闭连接并触发onClose回调。
$gateway->pingNotResponseLimit = 1;  //0,服务端允许客户端不发送心跳;1,客户端必须定时发送数据给服务端，超时会关闭连接。

// $gateway->pingData = '{"type":"SERVER_HEARTBEAT"}';  // 服务端定时向客户端发送心跳数据。
```

# GatewayWorker业务代码

这一块比较重要，是实现websocket服务端业务的核心

```php
/////GatewayWorker/Applications/YourApp/Events.php
/////By feiYun 2023-06-08 17:46:18

use \GatewayWorker\Lib\Gateway;

/**
 * 主逻辑
 * 主要是处理 onConnect onMessage onClose 三个方法
 * onConnect 和 onClose 如果不需要可以不用实现并删除
 */
class Events
{

    /**
     * 当businessWorker进程启动时触发。每个进程生命周期内都只会触发一次
     * 无返回值，任何返回值都会被视为无效的
     * @param int $businessWorker 进程实例
     */
    public static function onWorkerStart($businessWorker)
    {
        echo "WorkerStart\n";
    }

    /**
     * 当客户端连接时触发
     * 如果业务不需此回调可以删除onConnect
     * 当有客户端连接时，将client_id返回，让mvc框架判断当前uid并执行绑定
     * 
     * @param int $client_id 连接id
     */
    public static function onConnect($client_id)
    {
        // debug
        echo "client:{$_SERVER['REMOTE_ADDR']}:{$_SERVER['REMOTE_PORT']} gateway:{$_SERVER['GATEWAY_ADDR']}:{$_SERVER['GATEWAY_PORT']}  client_id:$client_id onConnect:''\n";

        // 向当前client_id发送数据
        Gateway::sendToClient($client_id, json_encode(array(
            'type'      => 'SERVER_INIT',
            'client_id' => $client_id,
            'msg' => '握手成功',
            'timestamp' => time(),
        ), JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT));

        ////调用phalapi框架接口的GatewayClient，发送广播数据（这里要用定时器，等uid绑定成功后再发送广播）
        // $http = new Workerman\Http\Client();
        // $http->request('http://api.xxx.cn/?s=Manage.System_Websocket.SendBroadcast');
    }

    /**
     * 当客户端发来消息时触发
     * GatewayWorker建议不做任何业务逻辑，onMessage留空即可
     * 
     * @param int $client_id 连接id
     * @param mixed $message 具体消息
     */
    public static function onMessage($client_id, $message)
    {
        // debug
        echo "client:{$_SERVER['REMOTE_ADDR']}:{$_SERVER['REMOTE_PORT']} gateway:{$_SERVER['GATEWAY_ADDR']}:{$_SERVER['GATEWAY_PORT']}  client_id:$client_id session:" . json_encode($_SESSION) . " onMessage:" . $message . "\n";

        // 客户端传递的是json数据
        $message_data = json_decode($message, true);
        if (!$message_data) {
            return;
        }

        // 根据类型执行不同的业务
        switch ($message_data['type']) {
            case 'MANAGE_CONNECT':
                // 管理后台：握手成功
                break;
            case 'MANAGE_HEARTBEAT':
                // 管理后台：心跳
                break;
            default:

        }

        // 向当前client_id发送数据
        Gateway::sendToClient($client_id, json_encode(array(
            'type'      => $message_data['type'],
            'client_id' => $client_id,
            'timestamp' => time(),
        ), JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT));
    }

    /**
     * 当用户断开连接时触发
     * @param int $client_id 连接id
     */
    public static function onClose($client_id)
    {
        // debug
        echo "client:{$_SERVER['REMOTE_ADDR']}:{$_SERVER['REMOTE_PORT']} gateway:{$_SERVER['GATEWAY_ADDR']}:{$_SERVER['GATEWAY_PORT']}  client_id:$client_id onClose:''\n";

        ////调用phalapi框架接口的GatewayClient，发送广播数据
        // $http = new Workerman\Http\Client();
        // $http->request('http://api.xxx.cn/?s=Manage.System_Websocket.SendBroadcast');
    }
}

```

# GatewayWorker定时器

在API接口同步请求过程中，不适合处理耗时过长、或者一直轮询的工作。此时，可以结合定时器把这部分的业务，放在后台处理。

异步队列服务有很多种，如果您觉得Gearman的安装过程比较繁琐，可以试试使用[GatewayWorker定时器](https://www.workerman.net/doc/gateway-worker/timer.html)。

当后端在处理一些用时较长且不需即时回调的请求的时候，异步IO可以有效提高响应速度。
比如:后台发送邮件、发送短信验证码、存储行为日志等等。
一句话：GatewayWorker定时器主要用来处理异步并发，从而提高后台的性能。

除了定时器Timer，workerman还提供了[crontab组件](https://www.workerman.net/doc/workerman/components/crontab.html)，使用规则类似linux的crontab，支持秒级别定时。另外还提供了[global-timer](https://github.com/walkor/global-timer)

可在GatewayWorker的根目录，通过命令行安装crontab模块：
```
composer require workerman/crontab
```

第一种Timer和Crontab组件调用方法：
```php
// GatewayWorker/Applications/YourApp/Events.php

use Workerman\Lib\Timer;
use Workerman\Crontab\Crontab;

/**
 * 主逻辑
 * 主要是处理 onConnect onMessage onClose 三个方法
 * onConnect 和 onClose 如果不需要可以不用实现并删除
 */
class Events
{
    //定时器间隔
    protected static $time_interval = 10;
    //定时器(计时器的timerid，可以通过调用Timer::del($timerid)销毁这个计时器)
    protected static $timer_id = null;

    // Crontab定时器
    protected static $crontab = null;
    
    /**
     * 当businessWorker进程启动时触发。每个进程生命周期内都只会触发一次
     * 无返回值，任何返回值都会被视为无效的
     * @param int $businessWorker 进程实例
     */
    public static function onWorkerStart($businessWorker)
    {
        // 可以在这里为每一个businessWorker进程做一些全局初始化工作，例如设置定时器，初始化redis等连接等。
        // 不要在onWorkerStart内执行长时间阻塞或者耗时的操作，这样会导致BusinessWorker无法及时与Gateway建立连接，造成应用异常

        // debug
        echo "WorkerStart\n";

        // 进程启动时设置个定时器。Events中支持onWorkerStart需要Gateway版本>=2.0.4
        self::$timer_id = Timer::add(self::$time_interval, function () {
            echo date('Y-m-d H:i:s') . "\n";
        });

        // 每分钟的第1秒执行
        self::$crontab = new Crontab('1 * * * * *', function () {
            echo posix_getpid() . "\n";
        });
    }

    /**
     * 当businessWorker进程退出时触发。每个进程生命周期内都只会触发一次。
     * 无返回值，任何返回值都会被视为无效的
     * @param int $businessWorker 进程实例
     */
    public static function onWorkerStop($businessWorker)
    {
        // 可以在这里为每一个businessWorker进程做一些清理工作，例如保存一些重要数据等。
        // 注意：某些情况将不会触发onWorkerStop，例如业务出现致命错误FatalError，或者进程被强行杀死等情况。

        // 连接关闭时，删除对应连接的定时器
        self::$timer_id && Timer::del(self::$timer_id);

        // 销毁定时器
        self::$crontab && self::$crontab->destroy();
    }
    
}

```

由于BusinessWorker默认是4进程，因此这里的定时器到了设定时间会重复执行4次。
通过设置`$worker->count = 1;`可以让定时器到了设定时间只执行1次。

第二种调用方法，在`start_businessworker.php`里添加一个回调函数

```php
//GatewayWorker/Applications/YourApp/start_businessworker.php

use \Workerman\Timer;

$worker->onWorkerStart = function ($worker) {
    // 只在id编号为0的进程上设置定时器，其它1、2、3号进程不设置定时器
    if ($worker->id === 0) {
        Timer::add(10, function () {
            echo "4个worker进程，只在0号进程设置定时器\n";
        });
    } else {
        echo "worker->id={$worker->id}\n";
    }
};
```

第三种调用方法，创建一个独立的worker进程，来处理定时任务和队列任务。
推荐使用这种方法。

```php
// GatewayWorker/Applications/YourApp/start_worker.php

use Workerman\Worker;
use Workerman\Timer;

require_once __DIR__ . '/../../vendor/autoload.php';

$worker = new Worker("http://0.0.0.0:1258");

/**
 * worker独立进程，用来处理定时任务及队列任务等
 * @author By feiYun 2023-06-10 22:04:32
 * 
 */
$worker->onWorkerStart = function ($worker) {
    Timer::add(3, function () {
        echo posix_getpid() . "——" . date('Y-m-d H:i:s') . "\n";
    });
};

if (!defined('GLOBAL_START')) {
    Worker::runAll();
}
```


# GatewayWorker进程守护
在宝塔系统中，实现进程守护有多种方式。

宝塔的软件商店中，提供了进程守护管理器，能非常方便的实现Gateway进程守护。

在开启进程守护以前，需要先关闭GatewayWorker进程。
```
php start.php stop
```

然后在宝塔的软件商店中，安装`进程守护管理器`。

安装完成以后，进入服务管理菜单，检查SuperVisord服务是否已经启动。
服务启动后，进入守护进程管理菜单，添加Gateway守护进程。

- 名称：GateWayWorker
- 启动用户：默认root
- 进程数量：默认
- 启动优先级：默认
- 启动命令：`php start.php start`
- 进程目录：`/www/wwwroot/XXX/GatewayWorker/`

这里的启动命令，使用了debug方式启动。在项目正式上线以后，可改成daemon方式启动。
进程目录，要设置为GatewayWorker在服务器中的完整路径。

添加完成以后，在列表中启动该进程。
在该进程的运行日志区域，可以查看实时的debug日志。
接下来，重启宝塔服务器，检查该进程是否会自动重启。

开启进程守护以后，查看Gateway的运行日志就要在这个管理器里查看。
使用VSCode远程开发的时候，就再也无法在命令行里查看实时日志了。

因此，开发的时候，建议直接使用命令行来管理GatewayWorker。等项目上线后，再使用进程管理器。

# 将GatewayClient改造成Domain模块

[下载GatewayClient](https://github.com/walkor/GatewayClient)最新版，
将php单文件，移动到`phalapi/src/manage/Common/Gateway.php`

注意，这里我使用的命名空间是`manage`，并非默认的`api`

你在开发中，要将文件放在主业务的命名空间中

对该代码进行适当改造，以适应phalapi框架。
大致改动内容：
- 'use \Exception;'改为'use PhalApi\Exception\BadRequestException;'，并将相关的引用同步修改
- 注册中心的端口号，由1236改为1238，必须和'GatewayWorker/Applications/YourApp/start_gateway.php'里的地址和端口号一致

# 实现客户端ID绑定

接下来实现客户端ID绑定的Api接口。

新建Websocket类，编写代码
```php
//////phalapi/src/manage/Api/System/Websocket.php

namespace Manage\Api\System;

use PhalApi\Api;

use Manage\Common\Gateway;

use PhalApi\Exception\BadRequestException;

/**
 * 系统-Socket服务
 * @author feiYun
 */
class Websocket extends Api
{
    public function getRules()
    {
        return array(
            'bindUid' => array(
                'client_id' => array('name' => 'client_id', 'require' => true, 'desc' => 'websocket客户端ID'),
            ),
        );
    }


    /**
     * 将客户端ID和用户的ID进行绑定
     * @desc ws绑定用户，并发送一条测试消息
     * @method POST
     */
    public function bindUid()
    {
        \PhalApi\DI()->admin->check();   //检测用户是否登录，未登录则抛出异常

        // client_id与uid绑定
        $id = \PhalApi\DI()->admin->id;
        Gateway::bindUid($this->client_id, $id);   //无返回值

        // 测试：发送ws消息（正式环境可去掉）
        Gateway::sendToUid($id, json_encode(array(
            'type'      => 'PORTAL_BIND',
            'msg' => '用户ID绑定成功',
            'timestamp' => time(),
        ), JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT));   //无返回值
    }
}
```

# 前端javascript代码

```html
<button id="send">发送内容</button>
<button id="close">关闭连接</button>

<!-- https://github.com/gimite/web-socket-js -->
<script src="web_socket.js"></script>

<!-- js部分 -->
<script>
    var wsUrl = 'ws://127.0.0.1:8282';
    var ws = null; // WebSocket 对象
    var heartbeatTimer = null; // 客户端 心跳定时器
    var isReconnect = true; // 是否自动重连

    // 创建 WebSocket 连接
    function createWebSocket() {
        if ("WebSocket" in window) {
            ws = new WebSocket(wsUrl);

            // WebSocket 打开事件
            ws.onopen = function () {
                console.log("WebSocket 握手成功");

                // 当WebSocket通道连接成功后，自动给服务端发送一条json格式的消息
                sendMessage({
                    "type": "MANAGE_CONNECT",
                    "token": "www.feiyunjs.com"
                });

                startHeartbeat();  // 开始客户端心跳定时器
            };

            // WebSocket 收到消息事件
            ws.onmessage = function (event) {
                console.log('服务端消息：' + event.data);
                var data = JSON.parse(event.data);
                    
                // json数据转换成js对象
                var data = eval("(" + event.data + ")");
                var type = data.type || '';
                switch (type) {
                    // Events.php中返回的init类型的消息，将client_id发给后台进行uid绑定
                    case 'SERVER_INIT':
                        // 利用jquery发起ajax请求，将client_id发给后端进行uid绑定
                        // 下面这个方法是我使用的前端框架中封装的ajax方法。你可以改为常规的ajax请求
                        admin.req(
                            '/?s=Manage.System_Websocket.BindUid',
                            {
                                client_id: data.client_id,
                            },function (res) {}, 'post');
                        break;
                    case 'SERVER_HEARTBEAT':
                        // 服务端心跳消息，可忽略
                        console.log('收到服务端心跳');
                        break;
                    default:
                        //// 当mvc框架调用GatewayClient发消息时直接alert出来
                        alert(event.data);
                }
            };

            // 发生错误回调
            ws.onerror = function (event) {
                console.log("通信出现异常");
            }

            // WebSocket 关闭事件
            ws.onclose = function () {
                console.log("WebSocket 已关闭");

                stopHeartbeat();  // 停止心跳定时器
            };
        } else {
            console.log("该浏览器不支持 WebSocket");
        }
    }

    // 发送消息
    function sendMessage(message) {
        if (ws != null && ws.readyState == WebSocket.OPEN) {
            ws.send(JSON.stringify(message));
            console.log("WebSocket 发送消息：" + message);
        } else {
            console.log("WebSocket 连接没有建立或已关闭");
        }
    }

    // 开始心跳定时器
    function startHeartbeat(interval) {
        interval = interval || 50;
        heartbeatTimer = setInterval(function () {
            sendMessage({
                "type": "MANAGE_HEARTBEAT",
            });
        }, interval * 1000);
    }

    // 停止客户端心跳定时器
    function stopHeartbeat() {
        clearInterval(heartbeatTimer);
    }

    // 启动 WebSocket 连接
    createWebSocket();

    // 发送消息
    $('#send').click(function (data) {
        if (ws.readyState != WebSocket.OPEN) {
            console.log('Error：连接已关闭，操作失败');
            return;
        }

        sendMessage({
            "type": "MANAGE_MESSAGE",
            "content": "Hello feiYun"
        });

        console.log('发送内容');
    });

    // 关闭连接
    $('#close').click(function (data) {
        if (ws.readyState != WebSocket.OPEN) {
            console.log('Error：连接已关闭，操作失败');
            return;
        }

        ws.close();

        console.log('关闭连接');
    });
</script>
```

在上面的代码中，我们通过 createWebSocket() 函数创建一个 WebSocket 连接

当 WebSocket 连接成功后，会触发 onopen 事件，并且开始心跳定时器，定时发送心跳数据。

当 WebSocket 收到消息时，会触发 onmessage 事件，并且打印收到的消息内容。

当 WebSocket 关闭时，会触发 onclose 事件，并且停止心跳定时器。

在发送消息时，我们通过 sendMessage() 函数实现，如果 WebSocket 连接没有建立或已关闭，会打印相应的提示信息。

最后，我们通过 startHeartbeat() 和 stopHeartbeat() 函数实现心跳定时器的启动和停止。

# 前端测试

以下是前端测试的控制台日志。

![](../../images/WX20230609-210631@2x.png)

# 后台管理系统有必要用websocket通信吗

使用 WebSocket 通信有以下必要性和好处：
1. 实时性：WebSocket 实现了浏览器与服务器全双工通信，可以实时传递信息，使后台管理系统具有实时性。例如在线聊天、实时显示服务器端日志、监控服务器运行状态等。
2. 即时消息：管理员可以即时接收到服务器的重要通知或报警信息，有利于及时响应和处理。
3. 减轻服务器压力：WebSocket 连接在建立后会持续存在，不需要像 HTTP 那样每次都建立新的连接。这可以减少服务器的开销，特别是在频繁刷新页面的场景下，可以大大减轻服务器压力。
4. 实现消息推送：WebSocket 可以实现服务器向客户端的消息主动推送，管理员无需主动刷新就可以收到新的消息和通知。
5. 实时数据展示：如果后台管理系统需要显示实时变化的数据，那么使用 WebSocket 是不错的选择，可以实现实时数据的推送和展示。

但是，使用 WebSocket 也有一定的代价：
1. 增加网络流量：WebSocket 连接一旦建立就会常驻，会使用一定的网络带宽，这会增加网络负载。
2. 实现难度较大：相比 HTTP 更复杂，WebSocket 的服务器和客户端实现都较为复杂，对开发者的要求较高。
3. 可能存在安全隐患：如果 WebSocket 通信不加密，那么其传输内容可能存在被窃听的风险。建议使用 SSL/TLS 加密通信，防止数据被窃取。

以下是一些建议：
1. 建议使用现有的 WebSocket 框架，这些框架已经实现了各种 WebSocket 功能，可以大大简化开发过程。
2. 通信的数据格式可以使用 JSON 或其他自定义格式，根据实际情况选择。


所以，总体来说，对于后台管理系统而言，适当使用 WebSocket 可以带来实时性、消息推送等好处，但也要考虑到可能增加的网络压力和实现难度，并采取加密等措施提高安全性。WebSocket 不应该完全取代 HTTP，而应根据具体需求选择使用。