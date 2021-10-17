#!/bin/bash
# Get arguments
while getopts c:d: flag
do
    case "${flag}" in
        c) currency=${OPTARG};;
        d) days=${OPTARG};;
    esac
done

# Get symbol currency
symbol=`cat ~/.i3/i3coins/src/symbols.json | jq -r '.[] | select(.name=="'$currency'") | .symbol'`

if [ -z "$symbol" ]
then
    symbol_arg="-symbol $currency"
else 
    symbol_arg="-symbol $symbol"
fi

# Begin the endless array.
echo '{"version": 1}'
echo '['

# Now send blocks with information forever:
while :;
do
    cmd=`/usr/bin/python ~/.i3/i3coins/i3status-coins.py -currency $currency -days $days $symbol_arg | sed -e 's/, /,/g' -e 's/": "/":"/g'`
    #echo "/usr/bin/python ~/.i3/i3coins/i3status-coins.py -currency $currency -days $days $symbol_arg | sed -e 's/, /,/g' -e 's/": "/":"/g'"
    echo -e "$cmd,"
    sleep 30
done