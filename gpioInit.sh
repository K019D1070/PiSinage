#!/bin/sh
if [ -e /sys/class/gpio/gpio${1} ]; then
    echo It had already be initialized.
else
    echo ${1} > /sys/class/gpio/export
    sudo echo in > "/sys/class/gpio/gpio${1}/direction"
fi
<< USAGE
input:
echo in > /sys/class/gpio/gpio18/direction
output:
echo out > /sys/class/gpio/gpio18/direction
read and write here:
/sys/class/gpio/gpio18/value
USAGE