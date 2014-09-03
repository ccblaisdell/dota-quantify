json.array!(@parties) do |party|
  json.extract! party, 
    :id, 
    :size
  json.party party_link(party)
  json.extract! party,
    :winrate, 
    :wins, 
    :count, 
    :difference,
    :strict_winrate, 
    :strict_wins,
    :strict_count,
    :strict_difference,
    :profile_ids
end
