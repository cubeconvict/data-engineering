

import pandas as pd
from bs4 import BeautifulSoup

with open("myfile.html", "r") as og_file:
    page = str(og_file.read())

soup = BeautifulSoup(page, "html.parser")

all_data = []
for li in soup.select("li"):
    d = li.find_previous("h2")
    d = d.text if d else "-"

    text2 = li.a.text
    url = li.a["href"]
    li.a.extract()
    text1 = li.text
    all_data.append((d, text1, "text2", url))

df = pd.DataFrame(
    all_data, columns=["date", "part1_of_rowN", "Part2_of_rowN", "url_for_rowN"]
)
df["part1_of_rowN"] = df["part1_of_rowN"].str.strip(" :")
print(df)