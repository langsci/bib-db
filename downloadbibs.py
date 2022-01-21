import os
import sys
import requests
from bs4 import BeautifulSoup
from requests import get

langsci_min_ID = 16
langsci_max_ID = int(sys.argv[1])
book_url_pattern  = "https://langsci-press.org/catalog/book/%i"

for i in range(langsci_min_ID,langsci_max_ID):
    if os.path.isfile(f"bibs/{i}.bib"):
        print (f"{i}.bib already available in bibs/")
        continue
    url = book_url_pattern%i
    html = requests.get(url).text
    if(len(html)) == 18820: #error page
        print(f"{i}: no such LangSci ID")
        continue
    soup = BeautifulSoup(html, 'html.parser')
    links = soup.find_all("a", "cmp_download_link")
    bib_url = None
    for link in links:
        if "Bibliography" in link.text:
            biburl = link["href"]
            with open(f"bibs/{i}.bib", "wb") as bibfile:
                print(f"{i}: downloading bib", end=" ")
                response = requests.get(biburl)
                bibfile.write(response.content)
                print("done")
            break
    else:
        print(f"no bib found for {i}")


