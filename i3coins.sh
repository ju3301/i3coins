#!/bin/bash

# Get arguments
while getopts c:d:ar flag;
do
    case "${flag}" in
        c) 
            currency=${OPTARG}
            currency_arg=true
        ;;
        d) 
            days=${OPTARG}
            days_arg=true
        ;;
        a) 
            add_crypto_arg=true
        ;;
        r) 
            remove_crypto_arg=true
        ;;
        *)
            echo 'wrong arguments'
            exit 1
        ;;
    esac
done

if [[ $currency_arg == true && $days_arg == true && $add_crypto_arg != true && $remove_crypto_arg != true ]]
then
    # Get currency symbol if exist or render currency name
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
        cmd=`/usr/bin/python ~/.i3/i3coins/i3status-coins.py -c $currency -d $days $symbol_arg`
        echo -e "$cmd,"
        sleep 30
    done
elif [[ $add_crypto_arg == true && $remove_crypto_arg == true && $currency_arg != true && $days_arg != true ]]
then
    echo "You have to choose... add or remove"
elif [[ $add_crypto_arg == true && $remove_crypto_arg != true && $currency_arg != true && $days_arg != true ]] 
then
    echo "Add a crypto"
    read -p 'Name of crypto to add: ' crypto_name
    exist=`cat src/cryptos.json | jq '.[] | select(.name=="'$crypto_name'")'`
    if [ -z "$exist" ]
    then
        read -p 'Symbol of crypto: ' crypto_symbol
        echo -e `cat ~/.i3/i3coins/src/cryptos.json | jq '. += [{"name":"'$crypto_name'","label":"'$crypto_symbol'"}]'` > src/cryptos.json
        echo $crypto_name' added to json file'
    else
        echo $crypto_name' already exist in json file'
    fi
elif [[ $add_crypto_arg != true && $remove_crypto_arg == true && $currency_arg != true && $days_arg != true ]] 
then
    echo "Remove a crypto"
    read -p 'Name of crypto to remove: ' crypto_name
    exist=`cat src/cryptos.json | jq '.[] | select(.name=="'$crypto_name'")'`
    if [ -z "$exist" ]
    then
        echo $crypto_name" cant be removed from json file because not exist"
    else
        echo "Removing $crypto_name"
        echo -e `cat ~/.i3/i3coins/src/cryptos.json | jq 'del(.[] | select(.name=="'$crypto_name'"))'` > src/cryptos.json
        echo "$crypto_name was removed from json file"
    fi
else
    echo "Usage : "
    echo "get crypto informations   ./i3coins.sh -c eur -d 1"
    echo "add crypto to list        ./i3coins.sh -a"
    echo "remove crypto to list     ./i3coins.sh -r"
fi

