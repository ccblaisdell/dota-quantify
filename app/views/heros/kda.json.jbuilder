json.array!(@players) do |player|
  json.extract! player, :id, :kda_ratio
end
