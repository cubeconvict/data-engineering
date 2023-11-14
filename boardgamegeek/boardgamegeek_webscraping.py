from bs4 import BeautifulSoup
import html5lib
import requests
import pandas as pd
import re

def parse_name(mystring):
    pattern = re.compile(r"""(?P<name>.*?) #everything up to the open paren is the name
                        \((?P<year>\d{4})\) #everything between the parentheses is the name, this will need to be changed to look for four digits
                        (?P<description>.*) #from the close paren to the end
                        """, re.VERBOSE)
    
    match = pattern.match(str(mystring))
    name = match.group("name")
    year = int(match.group("year"))
    description = match.group("description")
    

    new_row = pd.Series([name,year,description])
        
    
    return(new_row)


def scrape_bgg(this_url):
#Replace the dots below
    page = requests.get(this_url)
    html_data = page.text
    soup= BeautifulSoup(html_data, "html5lib")

    data = pd.DataFrame()

    for row in soup.find_all('table')[0].find_all('tr'):
        cols = row.find_all('td')
        
        ### Dont touch this part
        #create a list for each row
        cols = [i.text for i in cols]

        cols = [re.sub(r'\n', '', cell) for cell in cols]
        cols = [re.sub(r'\t', '', cell) for cell in cols]

        
        ###
        cols_df = pd.DataFrame(cols)
        cols_df = cols_df.transpose()
        data = pd.concat([data, cols_df])

    nan_value = float("NaN") 
    data.replace("", nan_value, inplace=True) 
    data.dropna(how='all', axis=1, inplace=True) 
    data.columns = ['Rank','Name','Geek Rating','Avg Rating','Num Voters']
    
    

    #dataframe has all zeros for index
    data.reset_index(inplace=True)
    return data

url = 'https://boardgamegeek.com/browse/boardgame/page/1?sort=bggrating&sortdir=desc'
mydata = scrape_bgg(url)

new_row = parse_name(mydata['Name'])
print(new_row)


'''
url2 = 'https://boardgamegeek.com/browse/boardgame/page/2?sort=bggrating&sortdir=desc'
mydata2 = scrape_bgg(url2)

url3 = 'https://boardgamegeek.com/browse/boardgame/page/3?sort=bggrating&sortdir=desc'
mydata3 = scrape_bgg(url3)

url4 = 'https://boardgamegeek.com/browse/boardgame/page/4?sort=bggrating&sortdir=desc'
mydata4 = scrape_bgg(url4)

url5 = 'https://boardgamegeek.com/browse/boardgame/page/5?sort=bggrating&sortdir=desc'
mydata5 = scrape_bgg(url5)

url6 = 'https://boardgamegeek.com/browse/boardgame/page/6?sort=bggrating&sortdir=desc'
mydata6 = scrape_bgg(url6)

url7 = 'https://boardgamegeek.com/browse/boardgame/page/7?sort=bggrating&sortdir=desc'
mydata7 = scrape_bgg(url7)

mydata = pd.concat([mydata, mydata2, mydata3, mydata4, mydata5,mydata6,mydata7])
'''

# Export to csv
mydata.to_csv("bgg.csv")