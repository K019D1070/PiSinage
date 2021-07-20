#/bin/sh
cd `dirname $0`
playDur=30

now=`date +%s`
if [ -e .status ];then
    timestamp=`cat .status`
    if [ $now -gt `expr $timestamp + $playDur` ];then
        echo play stop
        screen -XS player quit
        rm .status
    else
        echo playing...
        echo `expr $playDur + $timestamp - $now`/"$playDur"
    fi
fi
if [ `cat /sys/class/gpio/gpio18/value` = 1 ];then
    if [ ! -e .status ] || [ "`screen -ls | grep "player"`" = "" ];then
        echo play start
        screen -dmS player ./play.sh
    fi
    echo $now > .status
fi
sleepenh 0.3 > /dev/null
./control.sh