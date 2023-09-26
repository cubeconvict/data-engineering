import requests
import pandas as pd
from pandas import json_normalize


url = "http://api.exchangeratesapi.io/v1/latest?base=EUR&access_key=f4e5b9302f2b7961b473b61d53a0c949"  
myheaders = {'Accept': 'application/json'}
response = requests.get(url, headers=myheaders)
my_json = response.json()


# Turn the data into a dataframe
df = pd.DataFrame(my_json)

# Drop unnecessary columns: Currency as the index and Rate as their columns
df = df['rates']


# Save the Dataframe
df.to_csv('exchange_rates_1.csv')
