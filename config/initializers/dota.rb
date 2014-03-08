Dota.configure do |config|
  config.api_key = Figaro.env.steam_web_api_key
end
