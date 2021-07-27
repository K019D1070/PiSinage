#!/bin/bash

cd `dirname $0`
#Sensor pin
sPin=(18)
#How long play for?
playDur=1200
#How long run this script for?
upTime=0
#Is playing stop suddenly?
#1=suddenly/0=when music is finished
endMode=0
#Audio source directory
dir="./source"
#Audio source
play=("sample.wav")
#Random?
#1=random/0=seequential
random=1
#Interval of main roop
ctrlRate=0.3

source *.config.sh