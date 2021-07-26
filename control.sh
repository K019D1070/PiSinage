#/bin/sh
cd `dirname $0`
#How long play for?
playDur=1200
#How long run this script for?
upTime=0
#Is playing stop suddenly?
#1=suddenly/0=when music is finished
endMode=0
#Audio source
play=( "./source/example.m4v" )
#Random?
#1=random/0=seequential
random=1
#Interval of main roop
ctrlRate=0.3

playN=${#play[*]}
i=0
timestamp=0
launchSec=`date +%s`
now=`date +%s`
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
    fi
    if [ "`screen -ls | grep "player"`" = "" ] && [ $now -lt `expr $timestamp + $playDur` ];then
        echo play start
        if [ ${random} = 0 ];then
            if [ i = `expr ${playN} - 1` ];then
                i=0
                screen -dmS player ./play.sh ${play[${i}]}
            fi
        elif [ ${random} = 1 ];then
            r=`od -vAn --width=4 -tu4 -N4 < /dev/urandom | awk '{print $1 % ${playN} }'`
            screen -dmS player ./play.sh ${play[${r}]}
        fi
    fi
    if [ ${now} -gt `expr ${timestamp} + ${playDur}` ] && [ ${endMode} = 1 ];then
        screen -XS player quit
        rm .status
        echo play stop
    fi
    sleepenh ctrlRate > /dev/null
done
rm .status
sudo poweroff
