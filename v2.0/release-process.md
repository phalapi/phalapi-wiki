# 发布流程（维护者手册）

> 本文面向框架维护者，说明 PhalApi 8.x 从提交到发布的完整流程。普通使用者请直接看[升级指南](v2.0/php8-upgrade.md)。

## 一、分支模型

采用**发布制**：日常开发只在开发分支进行，默认分支只在发版时合并一次。

| 仓库 | 开发分支 | 默认分支 |
|---|---|---|
| phalapi | `phalapi8-dev` | **`master-2x`** |
| kernal / notorm / qrcode / cli | `phalapi8-dev` | `master` |
| phalapi-wiki | `phalapi8-dev` | `master` |

四条规则：

1. 提交前先确认当前分支是 `phalapi8-dev`；
2. 非发版期间，不向默认分支提交或合并；
3. **合并默认分支与打 tag 是同一个动作**，不可拆分；
4. 默认分支上每个合并点应对应一个版本号。

日常提交：

```bash
git switch phalapi8-dev
git commit -am "type(scope): 说明"
git push origin phalapi8-dev
```

## 二、版本语义

- `v8.x.y` 中的 **8 表示"支持 PHP 8"**，不是框架第 8 代；
- 补丁位 `y`：缺陷修复、包元数据调整；
- 次版本 `x`：新增功能，向后兼容；
- 破坏性变更：必须在 Release Notes 顶部显著标注；
- 唯一版本常量：`kernal/src/functions.php` 中的 `PHALAPI_VERSION`。

## 三、发版前检查（四项，缺一不可）

| 检查 | 命令 | 通过标准 |
|---|---|---|
| 清单合法 | `composer validate --no-check-publish composer.json` | 无 error |
| 语法 | 对全部 PHP 文件执行 `php -l`，**PHP 8.0 与 8.4 各一遍** | 0 错误 |
| 类加载 | 逐个 `class_exists()` 加载内核类 | 0 fatal、0 Deprecated |
| 真实请求 | 请求一个接口 | `ret:200`，日志无 `Deprecated` |

> `php -l` 查不出动态属性、内部接口返回类型、隐式可空这类**运行期弃用**，必须配合第 3、4 项。

## 四、发版步骤

### 1. 在开发分支准备版本

```bash
git switch phalapi8-dev

# 修改版本常量（仅 kernal）
# kernal/src/functions.php: define('PHALAPI_VERSION', '8.x.y');

# 更新 wiki 更新日志
# phalapi-wiki/v2.0/changelog.md

git commit -am "chore(release): v8.x.y"
git push origin phalapi8-dev
```

### 2. 合并默认分支并打 tag

按依赖顺序执行，**notorm 必须先发**（kernal 依赖 `phalapi/notorm: 8.*.*`）：

```bash
# 顺序：notorm → kernal → phalapi
for r in notorm kernal phalapi qrcode cli; do
  cd /path/to/$r
  target=master
  [ "$r" = "phalapi" ] && target=master-2x
  git switch $target
  git merge --no-ff phalapi8-dev -m "Merge branch 'phalapi8-dev': v8.x.y"
  git push origin $target
  git tag -a v8.x.y -m "..." && git push origin v8.x.y
done
```

`qrcode`、`cli` 无框架依赖，可与主线并行。

### 3. 发布 GitHub Release

```bash
gh release create v8.x.y --repo phalapi/kernal \
  --title "v8.x.y — 一句话说明" \
  --notes-file notes.md \
  --verify-tag --latest
```

### 4. 验证 Packagist 收录

```bash
php -r '
foreach (["phalapi/notorm","phalapi/kernal","phalapi/phalapi","phalapi/cli","phalapi/qrcode"] as $p) {
  $j = json_decode(@file_get_contents("https://repo.packagist.org/p2/$p.json"), true);
  printf("%-16s %s\n", $p, $j["packages"][$p][0]["version"] ?? "未收录");
}'
```

### 5. 全新安装验证

```bash
cd /tmp && rm -rf verify && mkdir verify && cd verify
COMPOSER_HOME=/tmp/ch_verify composer create-project phalapi/phalapi:^8.0 app --no-scripts
php app/public/index.php          # 或在浏览器访问 ?s=Hello.World
```

## 五、Packagist 同步机制与特例

Packagist 的版本元数据**取自 tag 对应的 commit**。因此修改默认分支上的 description、authors、php 约束，**不会回溯已发布版本** —— 想让元数据生效，必须发新 tag。

| 仓库 | 自动同步 |
|---|---|
| notorm / kernal / phalapi / cli | ✅ 已配置 webhook，tag 推送后约 10 秒收录 |
| **qrcode** | ❌ **没有 webhook**，需手动到 https://packagist.org/packages/phalapi/qrcode 点 **Update** |

### 国内镜像延迟

本机及多数国内环境使用 Composer 镜像（如腾讯云、阿里云）。新 tag 的 zip 通常要几分钟才同步，期间 `create-project` 会报 `404`。验证时可隔离配置走官方源：

```bash
COMPOSER_HOME=/tmp/ch_verify composer create-project ...
```

## 六、Release Notes 模板

固定五段，缺一段都算不合格：

```markdown
> **版本号说明**：v8 中的 8 表示"支持 PHP 8"，不是框架第 8 代。

## 支持矩阵
（8.0 / 8.1-8.3 / 8.4 / 7.x 及以下）

## 本次变更
（按仓库列，标注是代码改动还是仅元数据）

## 破坏性变更
（没有就写"无"）

## 升级步骤
（可直接复制的命令）

## 验证记录
（说明实测了哪些场景、哪些未验证）
```

**未验证的部分必须写明**，例如"未在真实 Oracle 实例上验证"。不要把推断写成已验证。

## 七、发版后

1. **文档同步**：README、wiki 更新随本版本一起合并到默认分支；
2. **依赖联动**：上游包发布后，检查下游 `composer.json` 的版本约束是否需要跟进（如 `phalapi/qrcode` 收录后，把 app 的 `dev-master` 改为 `^8.0`）；
3. **通知**：在 Issue / 社群说明破坏性变更。

## 八、回滚

- **不推荐移动已发布的 tag**。同一版本号对应不同内容会造成供应链风险；
- 正确做法：修复问题后发新的补丁版本（`v8.x.y+1`）；
- 若 tag 刚推送且确认无人安装，可删除 tag 后重发：
  ```bash
  git push origin :refs/tags/v8.x.y
  git tag -d v8.x.y
  ```
  但 Packagist 可能仍保留旧记录，需在其页面手动 Update。
