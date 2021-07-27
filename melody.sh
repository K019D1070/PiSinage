#!/bin/bash
cd `dirname $0`

source config.sh
#echo waiting for 10seconds...
#sleep 10
for i in "${sPin[@]}";do
    sudo ./gpioInit.sh ${sPin}
done
screen -dmS controler ./control.sh
