from bs4 import BeautifulSoup
import html5lib
import requests
import pandas as pd
import re
from lxml import etree
import re

nan_value = float("NaN") 

#########################
def scrape_game_page(this_url):
    page = requests.get(this_url)
    html_data = page.text
    print(type(html_data))
    max_players = re.search("class=\"ng-binding ng-scope\">–</span><!-- end ngIf: min>0 -->(.[0-9]?)", html_data).group(1)

    print(max_players)


    
    
    #data.replace("", nan_value, inplace=True) 
    #data.dropna(how='all', axis=1, inplace=True) 
    
    #dataframe has all zeros for index
    #data.reset_index(inplace=True)
    return data
###################################################################################
url = 'https://boardgamegeek.com/boardgame/342942/ark-nova'
mydata = scrape_game_page(url)





'''
SAMPLE CODE
<span ng-if="::geekitemctrl.geekitem.data.item.minplayers > 0 || geekitemctrl.geekitem.data.item.maxplayers > 0"
    min="::geekitemctrl.geekitem.data.item.minplayers" max="::geekitemctrl.geekitem.data.item.maxplayers"
    class="ng-scope ng-isolate-scope"> <!-- ngIf: min > 0 --><span ng-if="min > 0"
        class="ng-binding ng-scope">1</span><!-- end ngIf: min > 0 --><!-- ngIf: max>0 && min != max --><span
        ng-if="max>0 &amp;&amp; min != max" class="ng-binding ng-scope"><!-- ngIf: min>0 --><span ng-if="min>0"
            class="ng-binding ng-scope">–</span><!-- end ngIf: min>0 -->4</span><!-- end ngIf: max>0 && min != max -->
</span>
'''