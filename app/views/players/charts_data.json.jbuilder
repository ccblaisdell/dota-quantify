json.cache! @players do
  json.cache_collection! @players do |player|
    json.extract! player, 
      :id, 
      :outcome,
      :name,
      :hero_id,
      :mode,
      :adjusted_start,
      :duration,
      :level,
      :kills, 
      :deaths, 
      :assists, 
      :kda_ratio, 
      :last_hits,
      :denies,
      :xpm,
      :gpm,
      :gold,
      :hero_damage,
      :hero_healing,
      :tower_damage,
      :items
    json.url match_url(player.match)
  end
end
