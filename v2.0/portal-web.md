# 运营平台前端部分

运营平台前端使用的是[layui](https://www.layui.com/)经典模块化前端框架和[layuimin](http://layuimini.99php.cn/)LAYUI MINI 后台管理模板的【iframe版 - v2】进行开发，
开发过程中，关于前端部分可参考layui的开发文档。 

## PhalApi运营平台主要界面

目前，主要界面有：  

 + 运营平台首页：/portal/
 + 安装界面：/portal/page/install.html
 + 登录界面：/portal/page/login-1.html
 + 菜单管理界面：/portal/index.html#/page/menu.html

可以根据项目的情况，进行调整。

## 如何在运营平台开发一个新页面

下面，将讲述如何在运营平台开发一个新页面，主要步骤是：

 + 第1步：添加新页面菜单
 + 第2步：添加运营平台后台界面模板
 + 第3步：编写运营平台后端接口

以开发CURD示例的列表页为例，同步进行讲解。

## 第1步：添加新页面菜单

添加新页面菜单，你可以手动在【菜单管理】页面手动添加。  
![](http://cdn7.okayapi.com/yesyesapi_20200401112639_0d18c8a9567b83b09f38eeb733734bf0.png)

也可以直接修改数据库表```phalapi_portal_menu```添加。

主要配置：  
 + title：菜单标题
 + icon：菜单图标，想知道有哪些图标？可以查看layui的[图标文档](https://www.layui.com/doc/element/icon.html)。
 + href：界面链接，使用相对于portal目录的路径，例如：```page/upload.html```，或相对于网站根路径，例如：```/portal/page/upload.html```。
 + target：目标窗口，_self表示当前页面打开，_target表示新窗口打开
 + sort_num：排序值，值越小越前面
 + parent_id：上一级菜单ID，特别为0时，表示是顶部的菜单

为方便管理，推荐对于菜单ID，从1~10000，统一约定预留作为PhalApi框架及运营平台使用。方便日后框架升级和安装其他应用，不会出现菜单ID冲突。对于10000至99999之间的ID，用于项目自身的开发，可由自行分配。对于100000后的ID，则由第三方应用分配的选择。  

小结：  
 + PhalApi官方预留的菜单ID区间：1~10000（1到1万）
 + 项目自身预留菜单ID区间：10001~99999（1万零1到9.999万）
 + 第三方应用预留菜单ID区间：100000~无穷大（10万起）

目前已确定的顶部菜单ID有：  

菜单ID|菜单名称|说明
---|---|---
1|运营平台|运营平台的主要功能区
2|页面示例|layuimini的页面示例参考
3|应用市场|基于PhalApi开发的应用、插件、接口等源码市场


比如，需要添加以下这个【CURD表格示例】菜单：
![](http://cdn7.okayapi.com/yesyesapi_20200309183948_3ae3092a115d64b720c31feb9c85ebd6.png)

可以执行以下sql插入语句：
```sql
insert into `phalapi_test`.`phalapi_portal_menu` 
( `target`, `title`, `href`, `sort_num`, `parent_id`, `icon`)  
values 
( '_self', 'CURD表格示例', 'page/phalapi-curd-table.html', '5', '1', 'fa fa-list-alt');
```

## 第2步：添加运营平台后台界面模板

可以参考./public/portal/page目录下面原有的页面模板，或者【页面示例】的模板示例，复制一份合适的进行修改。 

这里，参考的是原来的```./public/portal/page/table.html```模板，复制一份到：./public/portal/page/phalapi-curd-table.html```，注意模板路径和要上面的菜单路径对应。  

首先，修改需要搜索的表单字段。

```
        <fieldset class="table-search-fieldset">
            <legend>搜索信息</legend>
            <div style="margin: 10px 10px 10px 10px">
                <form class="layui-form layui-form-pane" action="">
                    <div class="layui-form-item">
                        <div class="layui-inline">
                            <label class="layui-form-label">ID</label>
                            <div class="layui-input-inline">
                                <input type="text" name="id" autocomplete="off" class="layui-input">
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">标题</label>
                            <div class="layui-input-inline">
                                <input type="text" name="title" autocomplete="off" class="layui-input">
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">状态</label>
                            <div class="layui-input-inline">
                                <input type="text" name="state" autocomplete="off" class="layui-input">
                            </div>
                        </div>
                        <div class="layui-inline">
                            <button type="submit" class="layui-btn layui-btn-primary" lay-submit  lay-filter="data-search-btn"><i class="layui-icon"></i> 搜 索</button>
                        </div>
                    </div>
                </form>
            </div>
        </fieldset>
```

界面效果：  
![](http://cdn7.okayapi.com/yesyesapi_20200309211257_7bccb3e2dfa23d9cb857cf183ba42fdf.png)

接下来，在前端模板中配置需要调用的运营平台接口获取列表数据。  


```javascript
url: '/?s=Portal.CURD.TableList', // 换成相应的运营平台接口
```

继续配置，把默认的接口返回结果转换成layui表格需要的格式。  
```javascript
            parseData: function(res){ //res 即为原始返回的数据
                return {        
                    "code": res.ret == 200 ? 0 : res.ret, //解析接口状态
                    "msg": res.msg, //解析提示文本
                    "count": res.data.total, //解析数据长度
                    "data": res.data.items //解析数据列表
                };          
            },  
```

最后，再配置需要展示的表格数据。  
```javascript
            cols: [[        
                {type: "checkbox", width: 50, fixed: "left"},
                {field: 'id', width: 80, title: 'ID', sort: true},
                {field: 'title', minWidth: 50, title: '标题'},
                {field: 'content', minWidth: 80, title: '内容', sort: true},
                {field: 'post_date', minWidth: 80, title: '发布时间', sort: true},
                {
                    field: 'state', minWidth: 50, align: 'center', templet: function (d) {
                        if (d.state == 0) {
                            return '<span class="layui-badge layui-bg-red">关闭</span>';
                        } else {
                            return '<span class="layui-badge-rim">开启</span>';
                        }
                    }, title: '状态', sort: true
                },
                {title: '操作', minWidth: 50, templet: '#currentTableBar', fixed: "right", align: "center"}
            ]],
```

表格界面展示效果如下：  
![](http://cdn7.okayapi.com/yesyesapi_20200309211651_f7be5e390a423373de8f5683c37e5acc.png)

前面javascript代码组合起来完整是：  
```javascript
        table.render({
            elem: '#currentTableId',
            url: '/?s=Portal.CURD.TableList', // 换成相应的运营平台接口
            toolbar: '#toolbarDemo',
            defaultToolbar: ['filter', 'exports', 'print', {
                title: '提示',
                layEvent: 'LAYTABLE_TIPS',
                icon: 'layui-icon-tips'
            }],             
            parseData: function(res){ //res 即为原始返回的数据
                return {        
                    "code": res.ret == 200 ? 0 : res.ret, //解析接口状态
                    "msg": res.msg, //解析提示文本
                    "count": res.data.total, //解析数据长度
                    "data": res.data.items //解析数据列表
                };          
            },                  
            cols: [[        
                {type: "checkbox", width: 50, fixed: "left"},
                {field: 'id', width: 80, title: 'ID', sort: true},
                {field: 'title', minWidth: 50, title: '标题'},
                {field: 'content', minWidth: 80, title: '内容', sort: true},
                {field: 'post_date', minWidth: 80, title: '发布时间', sort: true},
                {
                    field: 'state', minWidth: 50, align: 'center', templet: function (d) {
                        if (d.state == 0) {
                            return '<span class="layui-badge layui-bg-red">关闭</span>';
                        } else {
                            return '<span class="layui-badge-rim">开启</span>';
                        }
                    }, title: '状态', sort: true
                },
                {title: '操作', minWidth: 50, templet: '#currentTableBar', fixed: "right", align: "center"}
            ]],
            limits: [10, 15, 20, 25, 50, 100],
            limit: 15,
            page: true
        });
```

## 第3步：编写运营平台后端接口

上面示例中，接口请求的链接类似：  
```
http://dev.phalapi.net/?s=Portal.CURD.TableList&page=1&limit=15
```

返回的结果数据类似是：  
```
{
    "ret": 200,
    "data": {
        "total": 2,
        "items": [
            {
                "id": 2,
                "title": "版本更新",
                "content": "主要改用composer和命名空间，并遵循psr-4规范。",
                "state": 1,
                "post_date": "2017-07-08 12:10:58"
            },
            {
                "id": 1,
                "title": "PhalApi",
                "content": "欢迎使用PhalApi 2.x 版本!",
                "state": 0,
                "post_date": "2017-07-08 12:09:43"
            }
        ]
    },
    "msg": ""
}
```

对应的PHP接口代码是：  
```php
<?php
namespace Portal\Api;

use Portal\Common\DataApi as Api;

/**
 * CURD数据接口示例
 */
class CURD extends Api {
    protected function getDataModel() {
        return new \Portal\Model\CURD();
    }
}
```

## 运营平台链接写法

URL链接写法，可以有三种方式，分别是：  
 + 第1种：完整的URL链接，例如：http://mac.phalapi.net/portal/index.html（前面使用http或https协议）
 + 第2种：相对于根路径的写法，例如：/portal/index.html（前面有斜杠）
 + 第3种：相对于当前文件的写法，例如：page/menu.html（前面没有斜杠）

这里遵循layuimini原来的写法，在模板中或者在菜单切尔西中推荐使用第3种写法，相对于当前文件的写法。  

这样的好处在于，当调整portal目录的位置时，影响较少，并且当域名发生变化时也不受影响。  

## 在运营平台前端需要调用的API接口

在运营平台的前端，需要调用后端的API接口时，需要注意以下几点。  

 + 第1点：页面初始化时需要调用```/?s=Portal.Page.StartUp```初始化接口，如果未登录则跳转到登录页面
 + 第2点：调用接口时，统一使用相对于根路径的写法，即：```/?s=接口服务名称```
 + 第3点：调用的接口，都应用放置在Portal大分类下，对应在线接口文档的运营平台。如下图所示。  

![](http://cdn7.okayapi.com/yesyesapi_20200309213546_4a69cc347feddc5e25e90e4c6180de61.png)

## 如何使用iview等其他前端技术开发后台？  

运营平台使用的是layui前端框架开发，如果你需要使用其他前端技术和框架开发，可以放置在public目录下。  

如果需要与运营平台整合，可以放置到./public/portal目录下；如果是另外单独的管理后台，可以放置到public目录与portal目录同级。  


