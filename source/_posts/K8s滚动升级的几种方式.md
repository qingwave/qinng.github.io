---
title: Deployment升级的几种方式
date: 2018-09-07 17:46:27
tags:
    - k8s
categories:
    - cloud
---
对于已经运行的deploy，有以下几种升级方式
### kubectl升级方式
```bash
kubectl set image deployments/busy busy=busybox:1.29

kubectl apply -f rolling-update-test.yaml

kubectl edit deployment/rolling-update-test

kubectl scale --replicas=3 rs/foo
```
### kubectl回滚
查看升级
`kubectl rollout status deployment/rolling-update-test`
回滚
```bash
kubectl rollout undo deployments/busy
kubectl rollout status deployments/busy
```