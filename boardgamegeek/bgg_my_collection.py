from bs4 import BeautifulSoup
import html5lib
import requests
import pandas as pd
import re

nan_value = float("NaN") 

#############Didn't use this function, but I want to save it, used the extract method instead once I got the patter right
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

#########################
def scrape_list_page(this_url):
    page = requests.get(this_url)
    html_data = page.text
    soup= BeautifulSoup(html_data, "html5lib")

    data = pd.DataFrame()

    for row in soup.find_all('table')[0].find_all('tr'):
        cols = row.find_all('td')
        if row.find('a', class_="primary") is not None:
            link = row.find('a', class_="primary")['href']
            link = "https://boardgamegeek.com/"+link
        else:
            link = ""
        ### Dont touch this part
        #create a list for each row
        cols = [i.text for i in cols]
        cols.append(link)
        
        cols = [re.sub(r'\n', '', cell) for cell in cols]
        cols = [re.sub(r'\t', '', cell) for cell in cols]

        ###
        cols_df = pd.DataFrame(cols)
        cols_df = cols_df.transpose()
        data = pd.concat([data, cols_df])
        
    
    
    data.replace("", nan_value, inplace=True) 
    data.dropna(how='all', axis=1, inplace=True) 
    data.columns = ['Rank','Name','Geek Rating','Avg Rating','Num Voters','Link']
    
    #print(data)

    #dataframe has all zeros for index
    data.reset_index(inplace=True)
    return data
###################################################################################
url = 'https://boardgamegeek.com/collection/user/cubeconvict?sortdir=asc&rankobjecttype=subtype&rankobjectid=1&columns=title%7Cthumbnail%7Cstatus%7Cownership%7Crating%7Cbggrating%7Cplays%7Ccomment&geekranks=%0A%09%09%09%09%09%09%09%09%09Board%20Game%20Rank%0A%09%09%09%09%09%09%09%09&own=1&objecttype=thing&ff=1&subtype=boardgame'
page = requests.get(url)
html_data = page.text

f = open('file.txt', 'w')
f.write(html_data)
