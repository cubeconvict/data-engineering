from bs4 import BeautifulSoup
import pandas as pd
import re

#
# Sample format of file I want to extract 
"""
<h2>Date1</h2>
    <ol>
        <li>Part1_of_row1: <a href="url_for_row1">Part2_of row1</a></li>
        .
        .
        .
        <li>Part1_of_rowN: <a href="url_for_rown">Part2_of rown</li>
<h2>Date2</h2>
        <li>Part1_of_rowNplus1: <a href="url_for_rown">Part2_of rowNplus1</aL</li>
.
.

""" 
# Desired output is a .csv where each line has ["date","part1_of_rowN","Part2_of_rowN","url_for_rowN"]

with open("myfile.html", "r") as og_file:
    page = str(og_file.read())

soup = BeautifulSoup(page, "html5lib")

list_items = soup.find_all('li')

#separate each li in the soup object into columns
list_output = []
for li in list_items:
    date = li.find_previous("h2")
    date = date.text if date else "-"

    halfway = str(li.text)
    if ":" in halfway:
        halfway = halfway.split(":")
        company = halfway[0]
        role = halfway[1]
    elif "," in halfway:
        halfway = halfway.split(",", maxsplit=1)
        company = halfway[0]
        role = halfway[1]
    elif "at" in halfway:
        halfway = halfway.split("at", maxsplit=1)
        company = halfway[1]
        role = halfway[0]
    else:
        role = halfway
        company = ""
   

    
    a= li.a
    if a:
        url = a["href"]
        url = url.replace("https://www.google.com/url?q=","")

    list_output.append([date,company,role,url])
df = pd.DataFrame(list_output, columns=["Date","Company", "Role","URL"])

#clean up some crap in the Company column
df["Company"] = df["Company"].str.replace(':','')
df["Company"] = df["Company"].str.strip()

#filter out the non-dates
df = df[~df['Date'].str.contains('Knack|Applications')]

#remove days of the week from the date column, this should probably be done above on each date row individually
dirty_date = df["Date"]
clean_date = dirty_date.str.replace("\(.*\)",'',regex=True)
df["Date"] = clean_date

with open('scrape.csv', 'w', newline='') as file:
    df.to_csv('scrape.csv')