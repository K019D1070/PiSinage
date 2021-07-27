#!/bin/sh
cd `dirname $0`
play=$1

#if you want to use 3.5mm jack, hw:CARD=Headphones,DEV=0
aplay "$1" --device=default