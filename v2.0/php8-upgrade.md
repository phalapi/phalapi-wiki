# 升级到 PhalApi v8.0.0（支持 PHP 8）

> **版本号说明**：`v8.0.0` 中的 **8 表示“支持 PHP 8”**，不是 PhalAPI 的第 8 代版本。这是 PhalApi 2.x 的一次兼容性发布，接口写法、目录结构与 API 用法均保持不变。

## 一、支持矩阵

| PHP 版本 | 状态 |
|---|---|
| 8.0 | ✅ 已实测通过 |
| 8.1 / 8.2 / 8.3 | ✅ 预期通过（未逐版本实测；内核已去除 8.1–8.4 引入的全部弃用项） |
| 8.4 | ✅ 已实测通过 |
| 7.4 及以下 | ❌ 不支持（`composer.json` 声明 `php >=8.0`，安装会被拒绝） |

> 代码层面在 PHP 7.4 下仍可运行（`#[...]` 属性在 PHP 7 中被当作行注释），但这只是巧合，不属于承诺的支持范围，也不会再用 7.x 做回归验证。

## 二、为什么需要 v8.0.0

PhalApi 2.x 原先声明 `php >=5.3.3`，在 PHP 8 下虽然多数场景能跑，但会持续输出弃用提示，其中三处属于"每天都触发"的高频项：

| 问题 | 触发时机 | 表现 |
|---|---|---|
| `Api` 请求参数动态属性 | 每个接口参数各一条 | `Creation of dynamic property ... is deprecated`（PHP 8.2+） |
| `DependenceInjection` 数组式访问 | 内核一加载就 4 条 | `Return type of ... should either be compatible with ArrayAccess::...`（PHP 8.1+） |
| `McryptCrypt` 依赖 `mcrypt_*` | 调用即致命 | `Call to undefined function mcrypt_generic()`（mcrypt 自 PHP 7.2 起移除） |

v8.0.0 把这三类问题一并解决。

## 三、破坏性变更

### 1. 不再支持 PHP 7.x

`composer.json` 的 PHP 约束由 `>=5.3.3` 改为 `>=8.0`。在 PHP 7 环境执行 `composer install` 会直接报错：

```
Your requirements could not be resolved to an installable set of packages.
  - Root composer.json requires php >=8.0 but your php version (7.4.x) does not satisfy that requirement.
```

### 2. `vendor` 不再纳入版本控制

`phalapi/phalapi` 仓库中的 `vendor/` 目录（701 个文件）已从 Git 索引移除并加入 `.gitignore`。

**后果**：`git pull` 之后项目中不再自带依赖，直接访问会因为找不到 `vendor/autoload.php` 而失败，**必须先执行 `composer install`**。

### 3. 加密实现由 mcrypt 改为 OpenSSL

`PhalApi\Crypt\McryptCrypt` 的底层由 Blowfish(mcrypt) 改为 **AES-256-CBC(OpenSSL)**。

- 类名、`encrypt()` / `decrypt()` 接口、构造参数（IV）均保持不变
- **历史密文无法用新版本解密**
- mcrypt 自 PHP 7.2 起已从 PHP 移除，这些数据在 7.2+ 环境本就无法解密，并非本次升级引入

如确有历史密文，必须先在 **PHP 7.1 及以下**用旧版本解密，再用新版本重新加密迁移。

### 4. 调用不存在的方法改为抛异常

`NotORM_Result::__call()` 由 `trigger_error(..., E_USER_ERROR)` 改为抛出 `BadMethodCallException`（前者在 PHP 8.4 已弃用）。两者都会中断流程，但异常可以被 `try/catch` 捕获。

## 四、升级步骤

### 方式一：已有项目从 2.x 升级

```bash
# 1. 备份
cp -r /path/to/your-project /path/to/your-project-backup

# 2. 拉取新代码（phalapi 项目的默认分支是 master-2x）
cd /path/to/your-project
git fetch origin
git checkout master-2x
git pull origin master-2x

# 3. 关键：重建依赖
composer install

# 4. 验证
php -v
php public/index.php?s=Hello.World
```

如果第 3 步报 PHP 版本不满足，说明当前 CLI 仍指向 PHP 7.x，需要先切换 PHP 版本。

### 方式二：只升级框架内核

不改动项目代码、仅升级 `vendor` 中的框架：

```bash
composer require phalapi/kernal:^8.0
```

`phalapi/kernal` 8.x 已声明依赖 `phalapi/notorm: 8.*.*`，会一并升级，不需要单独处理 NotORM。

### 方式三：全新项目

```bash
composer create-project phalapi/phalapi:^8.0 my-api
```

## 五、升级后自查清单

- [ ] `php -v` >= 8.0
- [ ] `vendor/autoload.php` 存在（不存在说明漏了 `composer install`）
- [ ] `php public/index.php?s=Hello.World` 返回 `ret:200`
- [ ] 日志中无 `Deprecated:` 输出
- [ ] 若使用过 `McryptCrypt`，已完成密文迁移
- [ ] `runtime/` 目录可写
- [ ] 生产环境已确认 `composer install` 在部署流程中

## 六、常见问题

### Q1：升级后页面空白/报 500，找不到 `vendor/autoload.php`？

v8.0.0 起仓库不再自带 vendor。执行：

```bash
composer install
```

### Q2：`composer install` 提示找不到 `phalapi/kernal: 8.*.*`？

可能是 Composer 镜像尚未同步新版本（国内镜像通常有分钟级延迟）。可临时切官方源：

```bash
composer config -g repo.packagist composer https://repo.packagist.org
```

### Q3：升级后接口仍输出 `Creation of dynamic property`？

确认 `vendor/phalapi/kernal` 的版本确实是 `8.0.0`：

```bash
composer show phalapi/kernal
```

若仍为 `2.x`，说明 `composer.json` 里的约束还是旧值，需要改成 `"phalapi/kernal": "8.*.*"` 后重新 `composer update`。

### Q4：我在 PHP 7.4 上跑得好好的，一定要升吗？

不强制。若继续使用 PHP 7.4，保持现有的 2.x 依赖即可（`"phalapi/kernal": "2.*.*"`）。但 PHP 7.4 已于 2022 年 11 月停止安全支持，建议尽快迁移到 PHP 8。

### Q5：`McryptCrypt` 的密文我还能解开吗？

在 PHP 7.2 及以上不能——mcrypt 扩展已被移除，与是否升级到 v8.0.0 无关。迁移路径只有一条：在 PHP 7.1 及以下环境解密出明文，再用新版本加密。

## 七、相关链接

- [phalapi/phalapi v8.0.0](https://github.com/phalapi/phalapi/releases/tag/v8.0.0)
- [phalapi/kernal v8.0.0](https://github.com/phalapi/kernal/releases/tag/v8.0.0)
- [phalapi/notorm v8.0.0](https://github.com/phalapi/notorm/releases/tag/v8.0.0)
