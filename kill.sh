#!/bin/sh
cd `dirname $0`

screen -XS controler quit
screen -XS player quit
rm .status
