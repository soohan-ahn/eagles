import urllib2
from bs4 import BeautifulSoup

url = "https://tokyo-eagles.herokuapp.com/games/8"
local_url = "http://localhost:3000/games/8"
page = urllib2.urlopen(local_url)
soup = BeautifulSoup(page, "html.parser")
print soup.title.string
html = page.read()
print html
