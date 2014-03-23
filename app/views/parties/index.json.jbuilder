json.array!(@parties) do |party|
  json.extract! party, 
    :id, 
    :size, 
    :profile_ids, 
    :winrate, 
    :wins, 
    :count, 
    :strict_winrate, 
    :strict_wins,
    :strict_count
  json.url party_url(party)
end
