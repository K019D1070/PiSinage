#/bin/sh
cd `dirname $0`
#How long play for?
playDur=1200
#How long run this script for?
upTime=20
#Is playing stop suddenly?
#1=suddenly/0=when music is finished
endMode=0


launchSec=`date +%s`
now=`date +%s`
while [ $now -lt `expr $launchSec + $upTime` ];do
    now=`date +%s`
    if [ `cat /sys/class/gpio/gpio18/value` = 1 ] || [ $now -lt `expr $timestamp + $playDur` ];then
        if [ "`screen -ls | grep "player"`" = "" ];then
            echo play start
            screen -dmS player ./play.sh
            echo $now > .status
        fi
    fi
    if [ -e .status ];then
        timestamp=`cat .status`
        if [ $now -gt `expr $timestamp + $playDur` ] && [ $endMode ];then
            screen -XS player quit
            rm .status
            echo play stop
        else
            echo playing...
            echo `expr $playDur + $timestamp - $now`/"$playDur"
        fi
    fi
    sleepenh 0.3 > /dev/null
done
sudo poweroff