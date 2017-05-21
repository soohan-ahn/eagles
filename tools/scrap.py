import urllib2
from bs4 import BeautifulSoup
game_ids = [18,19,42,75,24,25,57,60,61,66,68,69,67,9,37,43,47,51,52,53,54,70,71,92,102,112,29,32,132,11,44,45,8,14,48,49,13,22,23,59,62,82,63,64,65,10,72,73,74,122,15,27,28,39,46,50,20,16,31,12,41,17,56,21,26,35,30,40,33,38,142,152,202,162,262,212,222,192,252,242,292,172,272,182,232,282,302,312,322]
#game_ids = [142,152,202,162,262,212,222,192,252,242,292,172,272,182,232,282,302,312,322]

for game_id in game_ids:
    url = "https://tokyo-eagles.herokuapp.com/games/" + str(game_id)
    page = urllib2.urlopen(url)
    soup = BeautifulSoup(page, "html.parser")
    html = soup.prettify("utf-8")

    filename = "html_backup/" + soup.title.string + "." + str(game_id) + ".html"
    fout = open(filename, "wb")
    fout.write(html)
    fout.close()
