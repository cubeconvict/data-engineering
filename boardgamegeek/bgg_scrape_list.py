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
#Replace the dots below
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
url = 'https://boardgamegeek.com/browse/boardgame/page/1?sort=bggrating&sortdir=desc'
mydata = scrape_list_page(url)

url2 = 'https://boardgamegeek.com/browse/boardgame/page/2?sort=bggrating&sortdir=desc'
mydata2 = scrape_list_page(url2)

url3 = 'https://boardgamegeek.com/browse/boardgame/page/3?sort=bggrating&sortdir=desc'
mydata3 = scrape_list_page(url3)

url4 = 'https://boardgamegeek.com/browse/boardgame/page/4?sort=bggrating&sortdir=desc'
mydata4 = scrape_list_page(url4)

url5 = 'https://boardgamegeek.com/browse/boardgame/page/5?sort=bggrating&sortdir=desc'
mydata5 = scrape_list_page(url5)

url6 = 'https://boardgamegeek.com/browse/boardgame/page/6?sort=bggrating&sortdir=desc'
mydata6 = scrape_list_page(url6)

url7 = 'https://boardgamegeek.com/browse/boardgame/page/7?sort=bggrating&sortdir=desc'
mydata7 = scrape_list_page(url7)


mydata = pd.concat([mydata, mydata2, mydata3, mydata4, mydata5,mydata6,mydata7])

# extract first and last names using a regular expression
pattern = re.compile(r"""(?P<name>.*?) #everything up to the open paren is the name
                        \((?P<year>\d{4})\) #everything between the parentheses is the name, this will need to be changed to look for four digits
                        (?P<description>.*) #from the close paren to the end
                        """, re.VERBOSE)
mydata[['New Name', 'year','description']] = mydata['Name'].str.extract(pattern, expand=True)
mydata.reset_index(inplace=True)
mydata = mydata.drop(['Name', 'index'], axis=1)
mydata = mydata.rename(columns={"New Name":"Name"})

#TODO: Could clean this even better if you dropped all columns where "rank" =! N/A or a number.  There are trash bits in there from interjected rows.
#TODO: Write a functio instead of putting in lines to scrape each page.  Something like tell it to scrape the first seven pages and it loops seven times



# Export to csv
mydata.to_csv("bgg.csv")
