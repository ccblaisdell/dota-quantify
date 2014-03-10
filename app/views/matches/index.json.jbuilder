json.array!(@matches) do |match|
  json.extract! match, :match_id, :seq_num, :start, :lobby, :mode, :winner, :duration, :first_blood, :dire_tower_status, :radiant_tower_status, :dire_barracks_status, :radiant_barracks_status, :season, :human_players, :positive_votes, :negative_votes, :cluster, :league_id, :players
  json.url match_url(match, format: :json)
end
