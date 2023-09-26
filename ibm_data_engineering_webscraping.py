from bs4 import BeautifulSoup
import html5lib
import requests
import pandas as pd
import re

#Write your code here
url = 'https://en.wikipedia.org/wiki/List_of_largest_banks'
page = requests.get(url)
html_data = page.text

def Convert(a):
    it = iter(a)
    res_dct = dict(zip(it, it))
    return res_dct


#Replace the dots below
soup= BeautifulSoup(html_data, "html5lib")

data = pd.DataFrame()

for row in soup.find_all('tbody')[0].find_all('tr'):
    cols = row.find_all('td')
    
    ### Dont touch this part
    #create a list for each row
    cols = [i.text for i in cols]
    
    ###
    cols_df = pd.DataFrame(cols)
    cols_df = cols_df.transpose()
    ###

    data = pd.concat([data, cols_df])
    
data.drop(columns=[0], inplace=True, axis=1)
data.columns=["Name", "Market Cap (US$ Billion)"]

#clean the newline text
pattern = r'[\n]'
data["Name"] = data['Name'].apply(lambda x: re.sub(pattern, '', x))
data["Market Cap (US$ Billion)"] = data['Market Cap (US$ Billion)'].apply(lambda x: re.sub(pattern, '', x))

#dataframe has all zeros for index
data.reset_index(drop=True, inplace=True)


print(data.head())

# Export to csv
data.to_json("data.json")