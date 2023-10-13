# 如何编辑文档？

如果你想参与本文档的修订与编辑，可联系管理员dogstar，并提供github的账号，开通编辑权限后，就可以对本文档进行编辑和修改。

# VSCode操作示例

## 克隆仓库

克隆仓库的HTTPS地址

[GitHub - PhalApi 2.x framework wiki](https://github.com/phalapi/phalapi-wiki.git)

克隆完成后，按照弹窗提示，打开仓库文件。

## 切换master分支

如果master不是默认的分支，需要拉取master分支。

具体方法是：点击左下角的图标，选择菜单中的origin/master，即可切换到master分支。

也可以使用git命令，来切换到master分支：
```git
git checkout master
```

## 身份认证

如果是初次使用，可能需要添加GitHub用户名和邮箱，进行身份认证。

在VS中新建终端，输入：

```git
git config --global user.name "myname" # myname 为 GitHub 用户名
```

```git
git config --global user.email "myname@xxx.com" # myname@xxx.com 为 GitHub关联的邮箱
```

> 命令中的用户名和邮箱，都是带半角双引号的。

参考[VSCode中使用github_vscode github](https://blog.csdn.net/weixin_39450145/article/details/127958650)

完成身份认证后，就可以对文档进行编辑和提交了。

> 需要注意的是，每次进行编辑前，建议先从服务器上拉取最新版本，然后再进行编辑和提交。

## 命名与编写规范
参考[官方文档编写规范](https://gitee.com/dogstar/phalapi-wiki/blob/master/guide.md)

## 添加新页面
如果需要添加一个新页面，可以在“v2.0”或者子目录下，创建新的.md文件。

> 需要注意文件的命名规范。

例如，新建"v2.0/components/more/how-to-edit.md"

## 将页面添加到目录
编辑完页面内容以后，还需要将页面地址，添加到目录里，才能在文档的左侧菜单显示

文档的目录，在“v2.0/_sidebar.md”文件里。

> 注意：这个项目有两个“_sidebar.md”文件，别把路径搞混淆了。

例如，将前面建立的页面，添加到目录里。

```md
- 七、拓展阅读 
  - [7.1 记录API请求日志](v2.0/components/more/how-to-record-api-log.md)
  - [7.2 拦截多个接口请求并返回自定义内容](v2.0/components/more/how-to-volley-api-request.md)
  - [7.3 如何参与文档的编辑](v2.0/components/more/how-to-edit.md)
```

## 图片文件
可以统一存放在CDN，以便随处可访问并加快浏览速度。
建议使用七牛等空间来存储。

还可以将图片统一存储在`images`目录下，然后在其他文档页面进行引用。
引用方法如下：
```md
![](../../images/xxx.png)
```

> 图片文件的相对路径，必须写正确。

## 提交内容
提交以后，等待管理员审核和同步。

同步完成后，清理浏览器缓存，**强制刷新**，就可以看到新提交的内容了。

## Git错误处理
由于git服务器在国外，提交的速度还是挺慢的。经常会有一些莫名其妙的报错。
这里将常遇到的记录下来，以便遇到时能快速处理。

### git HTTP/2 stream 1 was not closed cleanly before end of the underlying stre

> 由于 git 默认使用的通信协议出现了问题，将默认通信协议修改为 `http/1.1`

修改git配置
```git
git config --global http.version HTTP/1.1
```

### git Empty reply from server

去掉代理
```git
git config --global --unset http.proxy
```

# 贡献者

你可以做的事（包括但不限于以下）：

- 纠正拼写、错别字
- 完善注释
- bug修复
- 功能开发
- 文档编写
- 教程、博客分享

提交 Pull Request 到本仓库，就可以成为 phalapi 的贡献者！

