#/bin/sh
cd `dirname $0`
play=sm24276234.wav

#if you want to use 3.5mm jack, hw:CARD=Headphones,DEV=0
aplay sm24276234.wav --device=default