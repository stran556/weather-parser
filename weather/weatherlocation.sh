#!/bin/bash

#Set to your default location
def_URL='https://weather.com/weather/today/'


if [ -z ${1+x} ];
then 
	echo $(wget $def_URL -O -) >> content.txt;
else 
	echo $(wget $1 -O -) >> content.txt;
fi
