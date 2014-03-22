# dota-quantify

Collect and analyze game stats

## Installation 

To install dota-quantify on windows:

- install mongodb

- run mongo if it's not running via a service
	- C:\mongodb\bin\mongod

- clone the git repo
	- https://github.com/ccblaisdell/dota-quantify

- make sure your'e on the development branch
	- git checkout develop

- comment out unicorn from gemfile (because kgio won't run on windows)

- install gems
	- bundle install --without production

- temporarily comment out the following in config\initializers\Dota.rb
	- config.api_key = Figaro.env.steam_web_api_key

- get a steam api key
	- http://steamcommunity.com/dev/apikey

- run figaro install
	- rails generate figaro:install

- uncomment the line in Dota.rb

- put the following in your new config\application.yml
	- STEAM_WEB_API_KEY: 79ABCDEFYOURNEWAPIKEY

- give ruby a SSL authority, otherwise trying to get a match will fail with a Figaro/SSL error
	- http://stackoverflow.com/questions/10775640/omniauth-facebook-error-faradayerrorconnectionfailed
	- https://gist.github.com/fnichol/867550

- rails s

- rake jobs:work

- visit localhost:3000 or wherever you have the app running

- try to get a match from dotabuff, using a URL like:
	- http://localhost:3000/matches/558522793

## Tips

You can test calls to the dota API in your browser, eg:

http://api.steampowered.com/ISteamUser/GetFriendList/v0001/?key=[YOUR_STEAM_KEY]&steamid=76561197960435530&relationship=friend

http://api.steampowered.com/IDOTA2Match_570/GetMatchHistory/v1?account_id=76561198004693352&key=[YOUR_STEAM_KEY]

The calls are documented here:

http://wiki.teamfortress.com/wiki/WebAPI

Also, here, with latest notes about bugs and changes and so forth:

http://dev.dota2.com/forumdisplay.php?f=411
