#!/bin/bash
#Get arguments
while getopts n:c:d: flag
do
    case "${flag}" in
        n) name=${OPTARG};;
        c) currency=${OPTARG};;
        d) days=${OPTARG};;
    esac
done

# Begin the endless array.
echo '{"version": 1}'
echo '['

# Now send blocks with information forever:
while :;
do
    #add new var for new crypto and add them to the array
    bitcoin=`/usr/bin/python ~/.i3/i3coins/i3status-coins.py -name bitcoin -currency eur -days 1 -label ₿`
    tron=`/usr/bin/python ~/.i3/i3coins/i3status-coins.py -name tron -currency eur -days 1 -label TRX`
    doge=`/usr/bin/python ~/.i3/i3coins/i3status-coins.py -name dogecoin -currency eur -days 1 -label DGC`

    #add your new crypto in arr
    arr=($bitcoin, $tron, $doge)
    echo '['${arr[*]}'],'
    sleep 30
done
