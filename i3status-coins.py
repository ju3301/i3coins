import requests
import json
import argparse
import pprint
import os

# Parse arguments
parser = argparse.ArgumentParser(description='get crypto currency value')
parser.add_argument('-c', help='names of currency ex: eur, usd')
parser.add_argument('-d', help='number of days for calc of evolution percentage aivable: 1|7|14|...|365')
parser.add_argument('-symbol', help='symbol to use ex: €, $')
args = parser.parse_args()

# Get arguments and crypto list
currency = args.c
days = args.d
cryptos = open(os.path.expanduser('~') + '/.i3/i3coins/src/cryptos.json')
cryptos_names = json.load(cryptos)
symbol = args.symbol

# Calling api & format output text, color
def get_token_evolution(name, currency, days, label):
    return_array = {}
    uri = "https://api.coingecko.com/api/v3/coins/"+name+"/ohlc?vs_currency="+currency+"&days="+days
    response = requests.get(uri)

    # If response status code 200 OK
    if response.status_code == 200:
        result = json.loads(response.content)
        
        # Calc evolution percentage
        first_tab = result[0]
        last_tab = result[len(result) - 1]
        first_value = first_tab[2]
        last_value = last_tab[2]
        evolution_calc = ((last_value - first_value) / first_value) * 100
        
        # Format percentage value and result in order to always show + on positive result
        evolution = "%+.3f" % evolution_calc
        
        # Color of result and format currency value
        return_array[1] = f' {last_value:.2f}' + symbol + ' ' + evolution + '%'
        if evolution_calc < 0 :
            return_array[2] = '#D52941'
        else:
            return_array[2] = '#35FF69'
        return return_array

    # On wrong response
    else: 
        return "err"

# Merge api calls in one array for i3bar
all_outputs=[]
for c in cryptos_names:
    name = c['name']
    label = c['label']
    response_array = get_token_evolution(name, currency, days, label)
    output_array = {
        "name": name,
        "color": response_array[2],
        "full_text": label + response_array[1]
    }
    all_outputs.append(output_array)
output=json.dumps(all_outputs)
print(output)

