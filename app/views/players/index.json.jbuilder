json.array!(@players) do |player|
  json.extract! player, :id, :steam_profile_id, :slot, :hero_id, :hero, :kills, :deaths, :assists, :kda, :leaver_status, :gold, :last_hits, :denies, :gold_spent, :hero_damage, :tower_damage, :hero_healing, :level, :xpm, :gpm, :items, :addition_unit_items, :additional_unit_names, :upgrades
  json.url player_url(player, format: :json)
end
