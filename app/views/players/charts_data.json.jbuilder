json.cache! @players do
  json.cache_collection! @players do |player|
    json.extract! player, 
      :id, 
      :outcome,
      :name,
      :hero_id,
      :adjusted_start,
      :duration,
      :kills, 
      :deaths, 
      :assists, 
      :kda_ratio, 
      :xpm,
      :gpm
    json.hero_avatar hero_avatar_path(player.hero_id)
    json.url match_url(player.match) if player.match
  end
end
