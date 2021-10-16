import requests
import json
import argparse

parser = argparse.ArgumentParser(description='get crypto currency value')
parser.add_argument('-name', help='name of crypto ex: bitcoin, dogecoin')
parser.add_argument('-currency', help='name of currency ex: eur, usd')
parser.add_argument('-days', help='number of days for calc of evolution percentage aivable: 1|7|14|...|365')
parser.add_argument('-label', help='label to render in bar, you can put everything you wants here ex: BTC, Bitcoin, Doge')
args = parser.parse_args()

name = args.name
currency = args.currency
days = args.days
label = args.label

def get_token_evolution(name, currency, days, label):
    return_array = {}
    uri = "https://api.coingecko.com/api/v3/coins/"+name+"/ohlc?vs_currency="+currency+"&days="+days
    response = requests.get(uri)
    if response.status_code == 200:
        result = json.loads(response.content)
        first_tab = result[0]
        last_tab = result[len(result) - 1]
        first_value = first_tab[2]
        last_value = last_tab[2]
        values = [first_value] + [last_value]
        evolution_calc = ((last_value - first_value) / first_value) * 100
        evolution = "%+.3f" % evolution_calc
        if evolution_calc < 0 :
            return_array[1] = f' {last_value:.2f}' + '€ ' + evolution + '%'
            return_array[2] = '#E3B505'
            return return_array
        else:
            return_array[1] = f' {last_value:.2f}' + '€ ' + evolution + '%'
            return_array[2] = '#35FF69'
            return return_array
    else: 
        return "err"

response_array = get_token_evolution(name, currency, days, label)
print('{"name":"' + name + '","color":"' + response_array[2] + '","full_text":"' + label + response_array[1] + '"}')
