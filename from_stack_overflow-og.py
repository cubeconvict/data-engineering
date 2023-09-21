import pandas as pd
from bs4 import BeautifulSoup

text = """\
<h2>Date1</h2>
    <ol>
        <li>role1: <a href="url_for_row1">Part2_of row1</a></li>
        <li>role2: <a href="url_for_rown">Part2_of rown</li>
<h2>Date2</h2>
        <li>Part1_of_rowNplus1: <a href="url_for_rown">Part2_of rowNplus1</a></li>
    </ol>
"""

soup = BeautifulSoup(text, "html.parser")


all_data = []
for li in soup.select("li"):
    d = li.find_previous("h2")
    d = d.text if d else "-"

    text2 = li.a.text
    url = li.a["href"]
    li.a.extract()
    text1 = li.text
    all_data.append((d, text1, text2, url))

df = pd.DataFrame(
    all_data, columns=["date", "part1_of_rowN", "Part2_of_rowN", "url_for_rowN"]
)
df["part1_of_rowN"] = df["part1_of_rowN"].str.strip(" :")
print(df)