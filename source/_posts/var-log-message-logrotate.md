---
title: /var/log/message 归档探究
date: 2018-09-27 13:51:52
tags:
    - linux
categories:
    - linux
---
## 背景
由于项目要收集/var/log/messages的日志到es中，发现messages日志按天切割，但归档的时间却不一直，于是乎查了点资料探究下
## 介绍
/var/log/messages是由journald生成的，流程如下
`systemd --> systemd-journald --> ram DB --> rsyslog -> /var/log`
当 systemd 启动后，systemd-journald 也会立即启动。将日志存入RAM中，当rsyslog 启动后会读取该RAM并完成筛选分类写入目录 /var/log 。所以牵扯到DB，操作就会很舒服。
### 相关服务
针对日志文件所需的功能，我们需要的服务于进程有：
- systemd-journald.service：最主要的信息收受者，由systemd提供；
- rsystem.service：主要登录系统于网络等服务的信息；
- logrotate：主要在进行日志的轮替功能

Centos7.x使用systemd提供的journalctl日志管理，基本上，系统由systemd所管理，那所有经由systemd启动的服务（）如果在启动或结束的过程中发生了一些问题或是正常的信息），就会将该信息由systemd-journald.service以二进制的方式记录下来，之后再将信息发个rsyslog.service作进一步的记载。
systemd-journald.service的记录主要都放置与内存中，因此在存取方面效能比较好。也能透过journalctl以及systemctl status unit.service 来查看各个不同服务的日志。
### 相关配置
journald配置文件
`cat /etc/systemd/journald.conf`
```
# This file is part of systemd.
#
# systemd is free software; you can redistribute it and/or modify it
# under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation; either version 2.1 of the License, or
# (at your option) any later version.
#
# Entries in this file show the compile time defaults.
# You can change settings by editing this file.
# Defaults can be restored by simply deleting this file.
#
# See journald.conf(5) for details.

[Journal]
#Storage=auto
#Compress=yes
#Seal=yes
#SplitMode=uid
#SyncIntervalSec=5m
#RateLimitInterval=30s
#RateLimitBurst=1000
#SystemMaxUse=
#SystemKeepFree=
#SystemMaxFileSize=
#RuntimeMaxUse=
#RuntimeKeepFree=
#RuntimeMaxFileSize=
#MaxRetentionSec=
#MaxFileSec=1month
#ForwardToSyslog=yes #默认转向syslog
#ForwardToKMsg=no
#ForwardToConsole=no
#ForwardToWall=yes
#TTYPath=/dev/console
#MaxLevelStore=debug
#MaxLevelSyslog=debug
#MaxLevelKMsg=notice
#MaxLevelConsole=info
#MaxLevelWall=emerg
```
1. 目前，centos log 由 rsyslog 管理，设置文件  /var/lib/rsyslog 并兼容syslog的配置文件
2. 其中messages文件记录系统日志，包括mail、定时任务、系统异常等（*.info;mail.none;authpriv.none;cron.none /var/log/messages）
3. Logrotate 实现日志切割，具体由 CRON 实现

logrotate配置文件
`cat /etc/cron.daily/logrotate`
```
#!/bin/sh


/usr/sbin/logrotate -s /var/lib/logrotate/logrotate.status /etc/logrotate.conf
EXITVALUE=$?
if [ $EXITVALUE != 0 ]; then
/usr/bin/logger -t logrotate "ALERT exited abnormally with [$EXITVALUE]"
fi
exit 0

实际运行时，Logrotate会调用配置文件「/etc/logrotate.conf」
# see "man logrotate" for details
# rotate log files weekly
weekly # 每月归档一次


# keep 4 weeks worth of backlogs
rotate 4 # 归档4个周期


# create new (empty) log files after rotating old ones
create


# use date as a suffix of the rotated file
dateext 


# uncomment this if you want your log files compressed
#compress # 默认不压缩


# RPM packages drop log rotation information into this directory
include /etc/logrotate.d #包含其下配置文件


# no packages own wtmp and btmp -- we'll rotate them here
/var/log/wtmp {
monthly
create 0664 root utmp
minsize 1M
rotate 1
}


/var/log/btmp {
missingok
monthly
create 0600 root utmp
rotate 1
}


# system-specific logs may be also be configured here.
```
设置特殊文件的归档方式
`cat /etc/logrotate.d/syslog` 
```
/var/log/cron
/var/log/maillog
/var/log/messages
/var/log/secure
/var/log/spooler
{
daily
rotate 4
compress
delaycompress # 延迟一个周期压缩
missingok # 日志丢失不报错
sharedscripts # 运行postrotate脚本，作用是在所有日志都轮转后统一执行一次脚本。如果没有配置这个，那么每个日志轮转后都会执行一次脚本
postrotate # 在logrotate转储之后需要执行的指令，例如重新启动 (kill -HUP) 某个服务！必须独立成行
/bin/kill -HUP `cat /var/run/syslogd.pid 2> /dev/null` 2> /dev/null || true
endscript
}
```

messages中日志生成时间大多是晚上3点多，这是由cron控制的
`cat /etc/anacrontab`
```
# /etc/anacrontab: configuration file for anacron


# See anacron(8) and anacrontab(5) for details.


SHELL=/bin/sh
PATH=/sbin:/bin:/usr/sbin:/usr/bin
MAILTO=root
# the maximal random delay added to the base delay of the jobs
RANDOM_DELAY=45 # 随机延迟最大时间
# the jobs will be started during the following hours only
START_HOURS_RANGE=3-22 # 3点到22点执行


#period in days delay in minutes job-identifier command
1 5 cron.daily nice run-parts /etc/cron.daily # 第一天执行，延迟5分钟
7 25 cron.weekly nice run-parts /etc/cron.weekly
@monthly 45 cron.monthly nice run-parts /etc/cron.monthly
日志生成时间在03:05~03:50 随机延迟时间 5~5+45
```