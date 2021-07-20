#/bin/sh
cd `dirname $0`
#How long play for?
playDur=1200
#How long run this script for?
upTime=23400
#Is playing stop suddenly?
#1=suddenly/0=when music is finished
endMode=0
#Audio source
play=sm24276234.wav


launchSec=`date +%s`
now=`date +%s`
rm .status > /dev/null
while [ $now -lt `expr $launchSec + $upTime` ];do
    now=`date +%s`
    if [ ! -e .status ];then
        timestamp=0
    fi
    if [ "`screen -ls | grep "player"`" = "" ] && ([ `cat /sys/class/gpio/gpio18/value` = 1 ] || [ $now -lt `expr $timestamp + $playDur` ]);then
        echo play start
        screen -dmS player ./play.sh $play
        echo $now > .status
    fi
    if [ -e .status ];then
        timestamp=`cat .status`
        if [ $now -gt `expr $timestamp + $playDur` ] && [ $endMode = 1 ];then
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
rm .status
sudo poweroff