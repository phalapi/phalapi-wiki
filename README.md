# PhalApi Official Development Document

Online Document url: [https://docs-en.phalapi.net](https://docs-en.phalapi.net)

## Document writing specifications

请参考[文档编写规范](http://git.oschina.net/dogstar/phalapi-wiki/blob/master/guide.md)。

欢迎一起来维护PhalApi 2.x 文档！直接提交PR即可，我会定时合并、更新和发布。

## Nginx本地部署

```
server
{
        listen 80;
        server_name docs.phalapi.net;

        index index.html index.php;
        root /path/to/phalapi-wiki;
}
```
