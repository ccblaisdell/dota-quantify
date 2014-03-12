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
	- bundle install

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
