---
title: kubernetes相关开源项目
author: qinng
toc: true
tags:
  - k8s
  - crd
date: 2020-07-14 11:12:20
categories:
  - k8s
---

总结下项目中可参考k8s相关开源项目，不断更新中...

## cncf
- [project](https://www.cncf.io/projects/)
- [sandbox](https://www.cncf.io/sandbox-projects/)

## 阿里
- [kruise](https://github.com/openkruise/kruise): 各种自定义app，包括增强deployment/statefulset等
- [kubernetes-cronhpa-controller](https://github.com/AliyunContainerService/kubernetes-cronhpa-controller): 定时扩缩
- [kube-eventer](https://github.com/AliyunContainerService/kube-eventer): event收集
- [gpushare-scheduler-extender](https://github.com/AliyunContainerService/gpushare-scheduler-extender): 共享GPU
- [log-pilot](https://github.com/AliyunContainerService/log-pilot): docker日志收集工具

## 腾讯
- [tapp](https://github.com/tkestack/tapp): 增强版deployment/statefulset
- [cron-hpa](https://github.com/tkestack/cron-hpa): 定时扩缩
- [lb-controlling-framework](https://github.com/tkestack/lb-controlling-framework): lb扩展，可自定义接口
- [tke-kms-plugin](https://github.com/Tencent/tke-kms-plugin): 实现kms,可参考

## 其他
- [stakater](https://github.com/stakater): 提供多种controller, 白名单、reloader等工具

