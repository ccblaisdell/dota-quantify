# json.cache! @players do
  json.array! @players do |player|
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
    json.hero_avatar hero_avatar_path(player.hero_id)
    json.url match_url(player.match)
  end
# end
