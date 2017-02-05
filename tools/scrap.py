import urllib2
from bs4 import BeautifulSoup
game_ids = [18,19,42,75,24,25,57,60,61,66,68,69,67,9,37,43,47,51,52,53,54,70,71,92,102,112,29,32,132,11,44,45,8,14,48,49,13,22,23,59,62,82,63,64,65,10,72,73,74,122,15,27,28,39,46,50,20,16,31,12,41,17,56,21,26,35,30,40,33,38]

for game_id in game_ids:
    url = "https://tokyo-eagles.herokuapp.com/games/" + str(game_id)
    page = urllib2.urlopen(url)
    soup = BeautifulSoup(page, "html.parser")
    html = soup.prettify("utf-8")

    filename = "html_backup/" + soup.title.string + "_" + str(game_id) + ".html"
    print filename
    fout = open(filename, "wb")
    fout.write(html)
    fout.close()
