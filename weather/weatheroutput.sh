#!/bin/bash

#Formatting content expressions into readable information
location=$(cat content.txt | colrm 1000 | head -1 | sed -e 's/.*tonight’s \(.*\) weather forecast.*/\1/')
current_temp=$(cat content.txt | colrm 300000 | sed -e 's/.*--tempValue--3a50n\"'\>'\(.*\)'\<'\/span'\>\<'div data-testid=\"wxPhrase.*/\1/')
day_temp=$(cat content.txt | sed -e 's/.*TemperatureValue\"'\>'\(.*\)'\<'\/span'\>' '\<'\!--.*/\1/')
night_temp=$(cat content.txt | sed -e 's/.*TemperatureValue\"'\>'\(.*\)'\<'\/span'\>\<'\/div'\>\<'\/div'\>\<'div class='\"'CurrentConditions--secondary.*/\1/')
feels_like=$(cat content.txt | sed -e 's/.*Cf9Sl\"'\>'\(.*\)'\<'\/span'\>''\<'span data-testid'\='\"FeelsLikeLabel.*/\1/')

#Today's Forecast
day_temp() {
	temp=$(cat content.txt | grep -o "$1<\/span><\/h3><div data-testid=\"SegmentHighTemp\" class=\"Column--temp--5hqI_\"><span data-testid=\"TemperatureValue\">....")
	if [ $2 -eq 0 ]
		then
			morning=${temp%<*}
			morning=${temp##*>}
	elif [ $2 -eq 1 ]
		then
			afternoon=${temp%<*}
			afternoon=${temp##*>}
	elif [ $2 -eq 2 ]
		then
			evening=${temp%<*}
			evening=${temp##*>}
	elif [ $2 -eq 3 ]
		then
			overnight=${temp%<*}
			overnight=${temp##*>}
	fi
}
timeOfDay=("Morning" "Afternoon" "Evening" "Overnight")
for i in ${!timeOfDay[@]}; do
	day_temp "${timeOfDay[$i]}" "$i"

done
#=$(cat content.txt | grep -o 'Morning'\<\/'span'\>\<'/h3'\>\<'div data-testid=\"SegmentHighTemp\" class=\"Column--temp--5hqI_\"'\>\<'span data-testid=\"TemperatureValue\"'\>'...' | cut -c 120-)

#Weather Today
humidity=$(cat content.txt | colrm 461000 | sed -e 's/.*,\\\"relativeHumidity\\\":\(.*\),\\\"snow1Hour\\\":.*/\1/')

pressure=$(cat content.txt | colrm 461000 | sed -e 's/.*,\\\"pressureAltimeter\\\":\(.*\),\\\"pressureChange.*/\1/')

visibility=$(cat content.txt | colrm 461000 | sed -e 's/.*,\\\"visibility\\\":\(.*\),\\\"windDirection\\\".*/\1/')

wind_speed=$(cat content.txt | colrm 461000 | sed -e 's/.*,\\\"windSpeed\\\":\(.*\),\\\"wxPhraseLong\\\".*/\1/')

dew_point=$(cat content.txt | colrm 461000 | sed -e 's/.*,\\\"temperatureDewPoint\\\":\(.*\),\\\"temperatureFeelsLike\\\".*/\1/')

uv=$(cat content.txt | grep -o 'UVIndexValue\"'\>'..' | cut -c 15-)
uv_index=""
if [[ "$uv" == "10" ]];
then
	uv_index=$(cat content.txt | grep -o 'UVIndexValue\"'\>'........' | cut -c 15-)
else
	uv_index=$(cat content.txt | grep -o 'UVIndexValue\"'\>'.......' | cut -c 15-)
fi

moon_phase=$(cat content.txt | colrm 461000 | sed -e 's/.*Moon Phase\(.*\)'\<'\/div'\>\<'\/div'\>\<'\/div'\>\<'\/section'\>\<'\/div'\>\<'div id=\"WxuHourlyWeatherCard.*/\1/' | cut -c 79-)

#Hourly Forecast
now_temp=$(cat content.txt | grep -o "Now<\/span><\/h3><div data-testid=\"SegmentHighTemp\" class=\"Column--temp--5hqI_\"><span data-testid=\"TemperatureValue\">....." | cut -c 115-)
time_temp() {
	temp2=$(cat content.txt | grep -o "....m<\/span><\/h3><div data-testid=\"SegmentHighTemp\" class=\"Column--temp--5hqI_\"><span data-testid=\"TemperatureValue\">....." | sed -n $(( $x + 1))p | sed 's/\s//g')
	time2=${temp2::4}
	if [[ $time2 == *\>* ]];
		then
			time2="${time2}x"
	fi

	if [ $1 -eq 0 ]
		then
			hour_one_temp=${temp2%<*}
			hour_one_temp=${temp2##*>}
			hour_one=${time2::5}
	elif [ $1 -eq 1 ]
		then
			hour_two_temp=${temp2%<*}
			hour_two_temp=${temp2##*>}
			hour_two=${time2::5}
	elif [ $1 -eq 2 ]
		then
			hour_three_temp=${temp2%<*}
			hour_three_temp=${temp2##*>}
			hour_three=${time2::5}
	elif [ $1 -eq 3 ]
		then
			hour_four_temp=${temp2%<*}
			hour_four_temp=${temp2##*>}
			hour_four=${time2::5}

	fi
}

x=0
while [ $x -le 4 ]
do
	time_temp $x
	x=$(( $x + 1 ))
done

week_temp() {
	day_zero=$(cat content.txt | grep -o -E ">Today<\/span><\/h3><div data-testid=\"SegmentHighTemp\" class=\"Column--temp--5hqI_\"><span data-testid=\"TemperatureValue\">...." | sed -n 1p | sed 's/\s//g')
	day_zero_temp_high=${day_zero%<*}
	day_zero_temp_high=${day_zero##*>}
	day_zero=$(cat content.txt | grep -o -E "<\/span><\/div><div data-testid=\"SegmentLowTemp\" class=\"Column--tempLo--1GNnT\"><span data-testid=\"TemperatureValue\">..." | sed -n 1p | sed 's/\s//g')
	day_zero_temp_low=${day_zero%<*}
	day_zero_temp_low=${day_zero##*>}
	day_of_week=$(cat content.txt | grep -o -E ">... [0-9]+<\/span><\/h3><div data-testid=\"SegmentHighTemp\" class=\"Column--temp--5hqI_\"><span data-testid=\"TemperatureValue\">...." | sed -n $(( $x + 1))p | sed 's/\s//g')
	day_of_week_2=$(cat content.txt | grep -o -E "<\/span><\/div><div data-testid=\"SegmentLowTemp\" class=\"Column--tempLo--1GNnT\"><span data-testid=\"TemperatureValue\">...." | sed -n $(( $x + 2))p | sed 's/\s//g')
	if [ $1 -eq 0 ]
		then
			day_one_temp_high=${day_of_week%<*}
			day_one_temp_high=${day_of_week##*>}
			day_one=${day_of_week::6}
			day_one_temp_low=${day_of_week_2%<*}
			day_one_temp_low=${day_of_week_2##*>}
	elif [ $1 -eq 1 ]
		then
			day_two_temp_high=${day_of_week%<*}
			day_two_temp_high=${day_of_week##*>}
			day_two=${day_of_week::6}
			day_two_temp_low=${day_of_week_2%<*}
			day_two_temp_low=${day_of_week_2##*>}
	elif [ $1 -eq 2 ]
		then
			day_three_temp_high=${day_of_week%<*}
			day_three_temp_high=${day_of_week##*>}
			day_three=${day_of_week::6}
			day_three_temp_low=${day_of_week_2%<*}
			day_three_temp_low=${day_of_week_2##*>}
	elif [ $1 -eq 3 ]
		then
			day_four_temp_high=${day_of_week%<*}
			day_four_temp_high=${day_of_week##*>}
			day_four=${day_of_week::6}
			day_four_temp_low=${day_of_week_2%<*}
			day_four_temp_low=${day_of_week_2##*>}
	fi
}

x=0
while [ $x -le 4 ]
do
	week_temp $x
	x=$(( $x + 1 ))
done

#echo "$location $current_temp"

if [[ "$current_temp" != *"°"* ]];
then
	sleep 1
	printf " Error.\n"
	sleep 0.5
	printf "See --help for more information."
else
	printf " Success!\n\n"
	sleep 0.5
	timestamp=$(date +"%I:%M %P %Z")
	echo "As of $timestamp"
	x=1
	while [ $x -le $(cat content.txt | grep -o "eventDescription" | wc -l) ]
	do
		warning=$(cat content.txt | grep -o -E "eventDescription.{100}" | sed -n $(( $x ))p)
		x=$(( $x + 1 ))
		warning=$(echo "$warning" | sed -e 's/.*eventDescription\\\":\\\"\(.*\)\\\",\\\"severityCode.*/\1/' | tr '[:lower:]' '[:upper:]')
		echo "[$warning]"
	done
	echo ""
	echo "---$location---"
	printf "Current    | %s\n" $current_temp
	printf "Feels Like | %s\n" $feels_like
	printf "Day        | %s\n" $day_temp
	printf "Night      | %s\n\n" $night_temp
	echo "---Today's Forecast---"
	printf "%-5s %-5s %-5s %-5s\n" "MORN" "AFTN" "EVEN" "NGHT"
	printf "%-6s %-6s %-6s %-6s\n" $morning $afternoon $evening $overnight | sed 's/</ /g' | sed 's/\// /g'
	printf "\n---Weather Today---\n"
	echo "High/Low   | $day_temp/$night_temp"
	echo "Humidity   | $humidity%"
	echo "Pressure   | $pressure in"
	echo "Visibility | $visibility mi"
	echo "Wind       | $wind_speed mph"
	echo "Dew Point  | $dew_point°"
	echo "UV Index   | $uv_index"
	echo "Moon Phase | $moon_phase"
	printf "\n---Hourly Forecast---\n"
	printf "%-5s %-5s %-5s %-5s %-5s\n" "Now " $hour_one $hour_two $hour_three $hour_four | sed 's/>//g' | sed 's/x/  /g'
      	printf "%-5s %-5s %-5s %-5s %-5s\n" $now_temp $hour_one_temp $hour_two_temp $hour_three_temp $hour_four_temp | sed 's/</ /g' | sed 's/>//g' | sed 's/\// /g'
	printf "\n---Daily Forecast---\n"
	printf "%-6s %-8s %-8s %-8s %-8s\n" "Today" $day_one $day_two $day_three $day_four | sed 's/>//g' | sed 's/\///g' | sed 's/<//g' | sed 's/   /  /g'
	printf "%-7s %-7s %-7s %-7s %-7s\n" $day_zero_temp_high $day_one_temp_high $day_two_temp_high $day_three_temp_high $day_four_temp_high | sed 's/</ /g' | sed 's/\// /g' | sed 's/     /    /g'
	printf "%-7s %-7s %-7s %-7s %-7s\n" $day_zero_temp_low $day_one_temp_low $day_two_temp_low $day_three_temp_low $day_four_temp_low | sed 's/>//g' | sed 's/</ /g'
fi
