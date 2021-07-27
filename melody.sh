#!/bin/sh
cd `dirname $0`

#echo waiting for 10seconds...
#sleep 10
sudo ./gpioInit.sh
screen -dmS controler ./control.sh
