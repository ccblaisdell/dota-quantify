json.array!(@parties) do |party|
  json.extract! party, 
    :id, 
    :size, 
    :profile_ids, 
    :winrate, 
    :count, 
    :wins, 
    :strict_winrate, 
    :strict_count,
    :strict_wins
  json.url party_url(party, format: :json)
end
