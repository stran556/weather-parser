# HTTP Content Parser for Weather.com

There is nothing more useful than the ability to check the weather at any place, for any place. Especially in your Linux terminal, where the forecast is of paramount importance, the command to check the weather should work whenever you use it. Only it doesn't.

![](https://github.com/stran556/weather-parser/blob/main/wttrerror.png)

Weather-parser displays the weather with a densely packed interface of necessary and unnecessary information. There was no point in knowing the dew point or the moon phase, but here you have it. Weather-parser will display the local forecast by default or access another location by manual search.

This program does not use a weather API. Instead, it parses an extremely packed chunk (Over one million characters written to a file on a single line) of 'wget' information dumped from weather.com and translates it into useable data to be displayed to the terminal.

![](https://github.com/stran556/weather-parser/blob/main/output.png)

## weather
Display the local forecast using the system IP to determine location

## weather \<location\>
Display the forecast for a specified location (Specificity for more accuracy)

### Tools that may need installation
wget- Retrieve HTTP content from weather.com website
