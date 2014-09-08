json.array!(@players) do |player|
  json.extract! player, 
    :id, 
    :kills, 
    :deaths, 
    :assists, 
    :kda_ratio, 
    :outcome,
    :xpm,
    :gpm,
    :duration,
    :adjusted_start
end
