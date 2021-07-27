#!/bin/bash

source config.sh

playN=${#play[*]}
i=0
timestamp=0
launchSec=`date +%s`
now=`date +%s`

echo ${playN} source files contain.
rm -f .status > /dev/null
while [ ${now} -lt `expr ${launchSec} + ${upTime}` ] || [ ${upTime} = 0 ];do
    now=`date +%s`
    if [ -e .status ];then
        timestamp=`cat .status`
        echo playing...
        echo `expr ${playDur} + ${timestamp} - ${now}`/"${playDur}"
    else
        timestamp=0
    fi

    #set timestamp to pray
    if [ `cat /sys/class/gpio/gpio18/value` = 1 ];then
        echo ${now} > .status
        timestamp=`cat .status`
    fi
    if [ "`screen -ls | grep "player"`" = "" ] && [ $now -lt `expr $timestamp + $playDur` ];then
        echo play start
        if [ ${random} = 0 ];then
            if [ i -gt `expr ${playN} - 1` ];then
                i=0
            fi
            screen -dmS player ./play.sh "${dir}/${play[${i}]}"
            i=$(expr ${i} + 1)
        elif [ ${random} = 1 ];then
            r=$(od -vAn --width=4 -tu4 -N4 < /dev/urandom | awk -v n=${playN} '{print $1 % n }')
            echo No. ${r} will play.
            echo ${play[${r}]}
            screen -dmS player ./play.sh "${dir}/${play[${r}]}"
        fi
    fi
    if [ ${now} -gt `expr ${timestamp} + ${playDur}` ] && [ ${endMode} = 1 ];then
        screen -XS player quit
        rm .status
        echo play stop
    fi
    sleepenh ${ctrlRate} > /dev/null
done
rm .status
if [ ${poweroff} = 1 ];then
    sudo poweroff
fi
