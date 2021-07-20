#/bin/sh
cd `dirname $0`
sh .config

screen -XS controler quit
screen -XS player quit
rm .status
