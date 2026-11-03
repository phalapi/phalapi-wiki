# 加密

## 底层加密实现：OpenSSL（AES-256-CBC）

> **v8.0.0 起变更**：原实现依赖 PHP 的 mcrypt 扩展。该扩展自 **PHP 7.2 起已从 PHP 移除**，在 PHP 8 下调用会直接致命错误（`Call to undefined function mcrypt_generic()`）。因此 `PhalApi\Crypt\McryptCrypt` 已改为基于 OpenSSL 的 **AES-256-CBC** 实现。

变化与不变：

+ **不变**：类名 `PhalApi\Crypt\McryptCrypt`、`encrypt($data, $key)` / `decrypt($data, $key)` 接口、构造参数（IV）均保持原样，调用方代码无需改动；
+ **不变**：补位方式沿用原实现（按 16 字节块补 `\0`，解密后 `rtrim("\0")`），密文长度恒为 16 的整数倍；
+ **变化**：密钥不足 32 字节补 `\0`、超长截断为 32 字节；
+ **变化**：**与历史 mcrypt 密文不兼容**。mcrypt 在 PHP 7.2+ 本就不可用，若确有历史数据，须先在 PHP 7.1 及以下解密再重新加密迁移。

## 加解密的使用

在单元测试中，我们可以快速找到加密和解密的使用，这里再简单举一例：
```php
$mcrypt = new PhalApi\Crypt\McryptCrypt('12345678');

$data = 'The Best Day of My Life';
$key = 'phalapi';

$encryptData = $mcrypt->encrypt($data, $key);
var_dump($encryptData);

$decryptData = $mcrypt->decrypt($encryptData, $key);
var_dump($decryptData);
```
上面输出的是二进制密文（不可直接阅读），`$decryptData` 会还原为原始明文 `The Best Day of My Life`。

## 更富弹性和便于存储的加密方案

直接加密的二进制结果在两点上不足：
  
+ 1、有乱码，不能很好地永久化存储；
+ 2、只针对文本字符串的加密，不支持数组等，且无法还原类型；
  
为此， 我们提供了更富弹性和便于存储的加密方案，即：序列化 + base64 + 对称加密的多重加密方案。  
  
  
以下是上面的示例-多重加密版：
```php
$mcrypt = new PhalApi\Crypt\MultiMcryptCrypt('12345678');

$data = 'The Best Day of My Life';
$key = 'phalapi';

$encryptData = $mcrypt->encrypt($data, $key);
var_dump($encryptData);

$decryptData = $mcrypt->decrypt($encryptData, $key);
var_dump($decryptData);
```

对应的输出（这里使用了文字结果输出，是因为没了乱码）：
```php
string(64) "……base64 编码后的密文，每次长度随明文对齐，具体值以实际运行为准……"
string(24) "The Best Day of My Life"
```

> 温馨提示：v8.0.0 起底层算法由 Blowfish(mcrypt) 改为 AES-256-CBC(OpenSSL)，同一份明文与密钥产生的密文与旧版本**不同**，这是预期行为。
  
## RSA的支持与超长字符串的应对方案
基于项目有使用RSA进行加密和解密的需求，这里特扩展对RSA的支持。同时针对到RSA对字符串长度的限制，提供了分段处理的方案。RSA加密模块的静态类结构UML如下：  
![rsa-PhalApi](http://webtools.qiniudn.com/20150411005257_e38fc8af28ac9c382e0e3ef8efbb2b86)

### 原生态的通信加密和解密
此部分只是简单地封装了openssl相关函数的操作，可以实现与其他语言和客户端下RSA的加密通信。  
唯一需要注意的是，对于 **“私钥加密，公钥解密”** 和 **“公钥加密，私钥解密”** 这两种情况下key的互换和对应问题。不要混淆。  

### 超长字符串的分段处理
这里重点说明一下超长字符串通信加密的问题。  
解决方案主要涉及两点：一是分段的处理，二是中间层转换。分段是指将待加密的字符串分割成允许最大长度117（有用户反馈说是127）内的数组，再各自处理；中间层转换是为了稳定性、通用性和方便落地存储，使用了json和base64的结合编码。  
  
虽然此方案解决了超长字符串的问题，但需要特别指出的是， **不能与其他语言、或者PHP其他框架和客户端进行原生态的RSA通信** 。  
我们突破了长度的限制，但失去了通用性。这里罗列一下各个场景和对应的处理方式：

 + 支持：PhalApi项目A  <--> PhalApi项目A
 + 支持：PhalApi项目A  <--> PhalApi项目B，PhalApi项目C，PhalApi项目D，...
 + 不支持：PhalApi项目 <--> 非PhalApi项目的PHP项目
 + 不支持：PhalApi项目 <--> 非PHP语言的项目。  
 解决方案：参考PhalApi对RSA超长字符串的处理，同步实现。  
 + 不支持：PhalApi项目 <--> 客户端（iOS/Android/Windows Phone, etc）。  
 解决方案：参考PhalApi对RSA超长字符串的处理，同步实现。  

### 使用示例

以下是单元测试中的使用示例。
```php
    public function testDecryptAfterEncrypt()
    {
        $keyG = new \PhalApi\Crypt\RSA\KeyGenerator();
        $privkey = $keyG->getPriKey();
        $pubkey = $keyG->getPubKey();

        \PhalApi\DI()->crypt = new \PhalApi\Crypt\RSA\MultiPri2PubCrypt();

        $data = 'AHA! I have $2.22 dollars!';

        $encryptData = \PhalApi\DI()->crypt->encrypt($data, $privkey);

        $decryptData = \PhalApi\DI()->crypt->decrypt($encryptData, $pubkey);

        $this->assertEquals($data, $decryptData);
    }
```

## 建议
在上面的加密中，接口项目在开发时，需要自定义两个值：加密向量和私钥。  
  
为了提高数据加密的安全度，建议：
 + 加密向量项目统一在./Config/app.php中配置；
 + 各模块业务数据加密所用的Key则由各业务点自定义；
  
这样，可以对不同的数据使用不同的加密私钥，即使破解了某一个用户的数据，也难以破解其他用户的。

## 扩展：实现你的加密方式

尤其对于加密方案和算法，我们在项目开发决策时，更应该优先考虑使用现在行业内成熟公认的加密方案和算法，而不是自己去从头研发。  
  
但如果你项目确实有此需要，或者需要在现有实现的基础上再作一些变通，也是可以很快地实现和注册使用。  


首先，请先实现下面的加密接口：
```php
<?php
namespace PhalApi;

interface Crypt {

    public function encrypt($data, $key);

    public function decrypt($data, $key);
}
```
  
然后，重新注册加密服务即可。
