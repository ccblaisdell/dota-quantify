json.array!(@players) do |player|
  json.extract! player, 
    :id, 
    :kda_ratio, 
    :outcome,
    :xpm,
    :gpm,
    :duration,
    :adjusted_start
end
