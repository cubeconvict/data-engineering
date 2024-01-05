import requests
import re
import json


#########################
def scrape_game_page(this_url):
    # function for performing a game page scrape and returning the json of the game data
    page_html = requests.get(this_url)
    page_text = page_html.text

    pattern = re.compile('GEEK.geekitemPreload =.*')

    game_json_match = pattern.search(page_text)

    json_text = game_json_match.group(0)
    json_text = json_text.strip("GEEK.geekitemPreload =")
    json_text = json_text.rstrip(";")

    json_data = json.loads(json_text)


    return json_data
###################################################################################
def get_players(json_data):
    # function for getting player number data from game json data

    user_recommended_players = json_data['item']['polls']['userplayers']['best']
    publisher_recommended_players = json_data['item']['polls']['userplayers']['recommended']

    return user_recommended_players, publisher_recommended_players


url = 'https://boardgamegeek.com/boardgame/421/1830-railways-robber-barons'
game_json = scrape_game_page(url)
list = get_players(game_json)







