---
title: hexo建立个人blog
date: 2019-02-01 21:04:04
tags:
    - blog
categories:
    - 其他
---
学到的分享出来才更有意义，春节前事不多使用hexo建立了个人blog，记录下。
## gitlab pages
创建个以`your_github_name.github.io`为名称的仓库，创建个[github page](https://help.github.com/articles/configuring-a-publishing-source-for-github-pages/)
## hexo建站
### 创建hexo分支
为`your_github_name.github.io`创建hexo分支，存放[hexo](https://hexo.io/zh-cn/docs/)配置，避免维护两个仓库

```bash
git clone git@...your_github_name.github.io
cd your_github_name.github.io
git checkout --orphan hexo
```
### 初始化
hexo初始化
`hexo init`

安装需要组件
`sudo npm install`

根据hexo官网配置`_config.yml`文件
## 主题
使用[melody主题](https://molunerfinn.com/hexo-theme-melody-doc/#/zh-Hans/quick-start)，参考官网自定义相关配置
## 常用命令
```bash
hexo g #生成静态文件
hexo n "name" #创建blo
hexo server #预览
hexo deploy #推送到github
```
## 参考
- https://help.github.com/articles/configuring-a-publishing-source-for-github-pages/
- https://hexo.io/zh-cn/docs/
- https://molunerfinn.com/hexo-theme-melody-doc/#/zh-Hans/quick-star
