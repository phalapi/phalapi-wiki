# CURL请求

当需要进行curl请求时，可使用PhalApi封装的CURL请求类[PhalApi\CUrl](https://github.com/phalapi/kernal/blob/master/src/CUrl.php)，从而实现快捷方便的请求。  

## 发起GET请求

例如，需要请求的链接为：```http://demo2.phalapi.net/```，则可以：  

```php
// 先实例
$curl = new \PhalApi\CUrl();

// 第二个参数，表示超时时间，单位为毫秒
$rs = $curl->get('http://demo2.phalapi.net/?username=dogstar', 3000);

echo $rs;
// 输出类似如下：
// {"ret":200,"data":{"title":"Hello dogstar","version":"2.1.2","time":1513506356},"msg":""}
```

## 发起POST请求

当需要发起POST请求时，和GET方式类似，但需要把待POST的参数单独传递，而不是拼接在URL后面。如： 
```php
try {
    // 实例化时也可指定失败重试次数，这里是2次，即最多会进行3次请求
    $curl = new \PhalApi\CUrl(2);

    // 第二个参数为待POST的数据；第三个参数表示超时时间，单位为毫秒
    $rs = $curl->post('http://demo2.phalapi.net/', array('username' => 'dogstar'), 3000);

    // 一样的输出
    echo $rs;
} catch (\PhalApi\Exception\InternalServerErrorException $ex) {
    // 错误处理……
}
```

## PUT/DELETE/PATCH其他请求

```php
// 实例化时
$curl = new \PhalApi\CUrl();

// 网址和参数
$url = 'http://demo2.phalapi.net/';
$data = array('username' => 'dogstar');
$timeoutMs = 3000; // 超时，单位：毫秒

// PUT请求
$rs = $curl->put($url, $data, $timeoutMs);

// DELETE请求
$rs = $curl->delete($url, $data, $timeoutMs);

// PATCH请求
$rs = $curl->patch($url, $data, $timeoutMs);

// 其他请求
$requestMethod = 'HEAD';
$rs = $curl->request($url, $data, $timeoutMs, $requestMethod);
```

对应的服务器将会接收到以下请求：  
```bash
113.66.32.124 - - [26/Jul/2023:16:03:48 +0800] "PUT / HTTP/1.1" 405 157 "-" "-"
113.66.32.124 - - [26/Jul/2023:16:03:59 +0800] "DELETE / HTTP/1.1" 405 157 "-" "-"
113.66.32.124 - - [26/Jul/2023:16:04:09 +0800] "PATCH / HTTP/1.1" 405 157 "-" "-"
113.66.32.124 - - [26/Jul/2023:16:04:09 +0800] "HEAD / HTTP/1.1" 405 157 "-" "-"
```

> 温馨提示：PUT/DELETE/PATCH其他请求，需要PhalApi 2.22.0 及以上版本支持。  

## 请求失败时，取消抛出异常

> 温馨提示：取消抛出异常需要 PhalApi v2.21.3 及以上版本。  

默认情况下，当curl请求失败时会抛出```PhalApi\Exception\InternalServerErrorException```异常。如果应用层不需要抛出异常，可以手动取消。  
```php
$curl = new \PhalApi\CUrl();

// 取消抛出异常
$curl->setIsThrowException(false);

// 重新开启抛出异常
$curl->setIsThrowException(true);

// 支持链式操作
$curl->setIsThrowException(false)->get('http://demo2.phalapi.net');
```

## 高级设置

```php
$curl = new \PhalApi\CUrl();

// 设置请求的头部信息。  
$curl->setHeader(array('Content-Type' => 'application/x-www-form-urlencoded'));

// 设置curl选项
// 选项参考：https://www.php.net/manual/zh/function.curl-setopt.php
// 例如设置连接超时为3秒
$curl->setOption(array(CURLOPT_CONNECTTIMEOUT => 10));

// 设置cookie
$curl->setCookie(array('username' => 'phalapi'));
```



