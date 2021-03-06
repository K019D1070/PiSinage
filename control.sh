#!/bin/bash

source config.sh

playN=${#play[*]}
i=0
timestamp=0
launchSec=`date +%s`
now=`date +%s`

echo -e "${playN} source files contain."
rm -f .status > /dev/null
while [ ${now} -lt `expr ${launchSec} + ${upTime}` ] || [ ${upTime} = 0 ];do
    now=`date +%s`
    if [ -e .status ];then
        timestamp=`cat .status`
        printf "\rplaying... $(expr ${playDur} + ${timestamp} - ${now})/${playDur}"
    else
        timestamp=0
    fi

    #set timestamp to pray
    if [ `cat /sys/class/gpio/gpio18/value` = 1 ];then
        echo ${now} > .status
        timestamp=`cat .status`
    fi
    if [ "$(screen -ls | grep 'player')" = "" ] && [ $now -lt `expr $timestamp + $playDur` ];then
        echo -e "\nplay start"
        if [ ${random} = 0 ];then
            if [ i -gt `expr ${playN} - 1` ];then
                i=0
            fi
            screen -dmS player ./play.sh "${dir}/${play[${i}]}"
            i=$(expr ${i} + 1)
        elif [ ${random} = 1 ];then
            r=$(od -vAn --width=4 -tu4 -N4 < /dev/urandom | awk -v n=${playN} '{print $1 % n }')
            echo -e "\nNo. ${r} will play."
            echo -e "${play[${r}]}"
            screen -dmS player ./play.sh "${dir}/${play[${r}]}"
        fi
    fi
    if [ ${now} -gt `expr ${timestamp} + ${playDur}` ] && [ ${timestamp} != 0 ];then
        if [ ${endMode} = 1 ];then
            screen -XS player quit
        elif [ "$(screen -ls | grep "player")" = "" ];then
            echo -e "\nplay stop"
            rm -f .status
        fi
    fi
    sleepenh ${ctrlRate} > /dev/null
done
rm -f .status
if [ ${poweroff} = 1 ];then
    sudo poweroff
fi
