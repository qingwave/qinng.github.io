---
title: k8s serviceaccount挂载pod问题
date: 2018-09-26 12:31:27
tags:
    - k8s
categories:
    - cloud
---
## 问题1
用户创建role失败，报错:
```bash
$ kubectl create -f role.yml 
Error from server (Forbidden): error when creating "role.yml": roles.rbac.authorization.k8s.io "pod-modifier" is forbidden: attempt to grant extra privileges: [PolicyRule{APIGroups:[""], Resources:["pods"], Verbs:["get"]}] user=&{test test [system:authenticated] map[]} ownerrules=[PolicyRule{APIGroups:["authorization.k8s.io"], Resources:["selfsubjectaccessreviews" "selfsubjectrulesreviews"], Verbs:["create"]} PolicyRule{NonResourceURLs:["/api" "/api/*" "/apis" "/apis/*" "/healthz" "/openapi" "/openapi/*" "/swagger-2.0.0.pb-v1" "/swagger.json" "/swaggerapi" "/swaggerapi/*" "/version" "/version/"], Verbs:["get"]}] ruleResolutionErrors=[]
```
### 解决
错误显示`user=&{test test [system:authenticated] map[]}`这个user没有权限，在`~/.kube/config`添加admin用户

## 问题2
创建serviceaccount后，没有挂载到pod中

### 解决
需要在apiserver配置中开启，添加`--admission-control=ServiceAccount --authorization-mode=RBAC`，重启
```bash
$ systemctl daemon-reload
$ systemctl restart kube-apiserver
```

## 问题3
添加配置后,直接创建pod能够加载sa与token，创建deployment则不行

### 解决
kubeconfig配置有问题，确认其中user的配置