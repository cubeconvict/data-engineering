import requests
from bs4 import BeautifulSoup
import pandas as pd
import json
import csv


with open("2023JobHunting.html", "r") as og_file:
    page = str(og_file.read())

table_soup = BeautifulSoup(page, "html5lib")


"""
for i,row in enumerate(applications):
    print("row",i,"is",row)
    cells=row.find_all('span')
    for j,cell in enumerate(cells):
        print('colunm',j,"cell",cell)
"""


list_input = table_soup.findAll(name=["li"])

#print(list_input)

with open('scrape.csv', 'w', newline='') as file:
    # Step 4: Using csv.writer to write the list to the CSV file
    writer = csv.writer(file)
    writer.writerows(list_input) 
    # Use writerow for single list


