json.array!(@matches) do |match|
  player = match.player(@profile)
  json.outcome link_to(match_outcome(match), match)
  json.hero "#{hero_avatar player.hero_id} #{player.hero}"
  json.mode match_mode(match)
  json.time match_time(match)
  json.extract! player,
    :level,
    :kda_ratio,
    :net_worth,
    :last_hits,
    :denies,
    :xpm,
    :gpm
  json.hero_healing number_to_human(player.hero_damage)
  json.hero_healing number_to_human(player.hero_healing)
  json.hero_healing number_to_human(player.tower_damage)
  json.items player_items(player)
end
