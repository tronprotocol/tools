#!/bin/bash
APP=$1
APP=${APP:-"FullNode"}
START_OPT=`echo ${@:2}`
JAR_NAME="$APP.jar"
MAX_STOP_TIME=60

checkpid() {
 pid=`ps -ef | grep $JAR_NAME |grep -v grep | awk '{print $2}'`
 return $pid
}

stopService() {
  count=1
  while [ $count -le $MAX_STOP_TIME ]; do
    checkpid
    if [ $pid ]; then
       kill -15 $pid
       sleep 1
    else
       echo "java-tron stop"
       return
    fi
    count=$[$count+1]
    if [ $count -eq $MAX_STOP_TIME ]; then
      kill -9 $pid
      sleep 1
    fi
  done
}

startService() {
 echo `date` >> start.log
 nohup java -jar DBRepair.jar >> start.log 2>&1 &

 pid=`ps -ef |grep DBRepair.jar |grep -v grep |awk '{print $2}'`
 echo "start db-repair with pid $pid on $HOSTNAME"
}

stopService
startService