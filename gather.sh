#!/bin/bash

# 参数设定(保存目录)
SAVE_PATH=~/gather

# JDK 目录(如果 jstack 直接可访问,可以不用设定)
JDK_PATH=

# 命令行(进程ID)
PID=$1

if [[ "$PID" == "" ]]; then
	echo -e "Usage:\n\tgather.sh <pid>\n"
	exit 1
fi

# 进程是否存在
(kill -0 $PID > /dev/null 2>&1); RET=$?

if [[ "$RET" != "0" ]]; then
	echo -e "Error:\n\tProcess $PID not exists\n"
	exit 2
fi

if [[ "$JDK_PATH" != "" ]]; then
	export PATH=$PATH:$JDK_PATH/bin
fi

# 时间戳
TS=`date +%Y%m%d%H%M%S`

SAVE_PATH=$SAVE_PATH/"$TS"_"$PID"

mkdir -p $SAVE_PATH

# 收集 CPU
echo top -cbH -n 2 -p $PID
top -cbH -n 2 -p $PID > $SAVE_PATH/top.txt

# 收集 jstack
echo jstack $PID
jstack $PID > $SAVE_PATH/jstack.txt

# 收集 jmap
echo jmap -histo $PID
jmap -histo $PID > $SAVE_PATH/jmap-histo.txt

