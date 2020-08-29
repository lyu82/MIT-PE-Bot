#!/bin/bash

cookie='JSESSIONID=.....' #cookie here

if [[ $cookie = "JSESSIONID=....." ]];then
echo 'please replace cookie first'
exit 1
fi

echo 'PE class code..'
echo 'example: 0626-1'
read term
term='PE.'$term

echo 'MIT ID #..'
echo 'example: 900123123'
read id

echo 'Registration open date..'
echo 'example: 1/1/2001'
read timeinput
targettime=$(date -jf '%m/%d/%Y %H:%M:%S %p' "$timeinput 8:00:00 AM" '+%s')
echo $timeinput ' - ' $targettime ' - ' $term

currenttime=$(date +%s)
while [ "$currenttime" -lt "$targettime" ];do
if [ $(($currenttime+11)) -gt $targettime ];then sleep 0.001 ;else sleep 5 ;fi
currenttime=$(date +%s)
done

keycode=$(curl -s 'https://eduapps.mit.edu/mitpe/student/registration/sectionList' -H 'Connection: keep-alive' -H 'Cache-Control: max-age=0' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: ' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3' -H 'Referer: https://eduapps.mit.edu/mitpe/student/registration/home' -H "$cookie" --compressed | grep $term | cut -d'=' -f 3-3 | cut -d'"' -f1)

curl -s 'https://eduapps.mit.edu/mitpe/student/registration/create' -H 'Connection: keep-alive' -H 'Cache-Control: max-age=0' -H 'Origin: https://eduapps.mit.edu' -H 'Upgrade-Insecure-Requests: 1' -H 'Content-Type: application/x-www-form-urlencoded' -H 'User-Agent: ' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3' -H "$cookie" --data "sectionId=$keycode&mitId=$id&wf=%2Fregistration%2Fquick" --compressed
echo $keycode

echo 'done!'
