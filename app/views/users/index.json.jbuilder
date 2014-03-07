json.array!(@users) do |user|
  json.extract! user, :id, :name, :steam_id, :last_match, :war, :match_count, :wins, :losses
  json.url user_url(user, format: :json)
end
