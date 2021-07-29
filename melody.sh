#!/bin/bash
cd `dirname $0`

source config.sh
#echo waiting for 10seconds...
#sleep 10
for i in "${sPin[@]}";do
    sudo ./gpioInit.sh ${sPin}
done
if [ "$(screen -ls | grep 'controler')" != "" ];then
    echo PiSinage has already running!
    echo If you want to kill PiSinage, you type
    echo ./kill.sh
    echo and enter
    exit
else
    screen -dmS controler ./control.sh
fi
