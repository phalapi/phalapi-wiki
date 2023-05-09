#!/bin/bash

# 下载
# wget https://github.com/phpDocumentor/phpDocumentor/releases/download/v2.9.0/phpDocumentor.phar

# 使用教程
# https://docs.phpdoc.org/3.0/guide/getting-started/installing.html#installation

php ~/projects/github/phpDocumentor.phar -d ~/projects/github/kernal/src -f ~/projects/github/notorm/src/NotORM/Result.php -t ~/projects/github/phalapi-wiki/manual --title "PhalApi 2.21.6 类手册" --force

