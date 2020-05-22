---
title: k8s与docker组件堆栈信息
author: qinng
toc: true
tags:
  - k8s
  - docker
  - pprof
date: 2019-05-11 23:11:45
categories:
  - cloud
---

controller manager
```bash
wget http://localhost:10252/debug/pprof/profile
wget http://localhost:10252/debug/pprof/heap
curl http://127.0.0.1:10252/debug/pprof/goroutine?debug=1 >> debug1
curl http://127.0.0.1:10252/debug/pprof/goroutine?debug=2 >> debug2
```

kubelet 堆栈信息
```bash
wget http://localhost:10248/debug/pprof/profile
wget http://localhost:10248/debug/pprof/heap
curl http://127.0.0.1:10248/debug/pprof/goroutine?debug=1 >> debug1
curl http://127.0.0.1:10248/debug/pprof/goroutine?debug=2 >> debug2
```

docker 堆栈信息
```bash
curl --unix-socket /var/run/docker.sock -X GET http://v1.2/debug/pprof/profile
curl --unix-socket /var/run/docker.sock -X GET http://v1.2/debug/pprof/
curl --unix-socket /var/run/docker.sock -X GET http://v1.2/debug/pprof/
 
sudo kill -SIGUSR1 $(pidof dockerd)
/var/run/docker/
 
curl --unix-socket /var/run/docker.sock -X GET http://v1.2/debug/pprof/profile >>docker.profile
curl --unix-socket /var/run/docker.sock -X GET http://v1.2/debug/pprof/goroutine >> docker.goroutine
curl --unix-socket /var/run/docker.sock -X GET http://v1.2/debug/pprof/goroutine?debug=2 >>docker.gorouting_debug_2
curl --unix-socket /var/run/docker.sock -X GET http://v1.2/debug/pprof/heap?debug=2 >>docker.heap
```

docker-registry 堆栈信息
```bash
#先登入机器,然后执行
wget localhost:5002/debug/pprof/profile #这个是cpu占用时间的采样结果，要先等30s
wget localhost:5002/debug/pprof/heap #内存的使用情况
wget localhost:5002/debug/pprof/goroutine?debug=2 #调用栈的全部信息
wget localhost:5002/debug/pprof/goroutine
其他可用的profile:
allocs block goroutine cmdline mutex threadcreate trace，替换上面命令pprof/后面的词即可
```