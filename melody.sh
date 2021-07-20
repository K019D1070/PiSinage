#/bin/sh
cd `dirname $0`

sudo ./gpioInit.sh
screen -dmS controler ./control.sh