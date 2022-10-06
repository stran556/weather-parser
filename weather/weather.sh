#!/bin/bash

: > content.txt
input="'$*'"

if [[ ${input} == *"--help"* ]]; then
	echo ""
	echo "Help for Weather"
	echo ""
	echo "ARG_1: str"
	echo "   <null>       retrieve weather using IP"
	echo "   <URL>        retrieve weather using URL from 'weather.com/weather/today...'"
	echo "   <location>   attempt a google search of location (May not always work)"
	echo ""
	exit 0
fi

if [[ ${input} == *"weather.com/weather/today"* ]]
then
	printf "Processing address..."
	./weatherlocation.sh $1 > /dev/null 2>&1
	./weatheroutput.sh
	: > content.txt
else
	if [[ -z ${1+x} ]];
	then
		printf "Accessing local data..."
		./weatherlocation.sh > /dev/null 2>&1
		./weatheroutput.sh
		: > content.txt
	else
		printf "Processing search..."
		./weatherlocation.sh $(./search.sh "weathercom $input" | grep "weather.com/weather/today") > /dev/null 2>&1 "success"
		./weatheroutput.sh
		: > content.txt
	fi
fi
