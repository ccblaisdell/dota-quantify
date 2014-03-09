json.array!(@profiles) do |profile|
  json.extract! profile, :id, :name, :steam_id, :last_match, :war, :match_count, :wins, :losses
  json.url profile_url(profile, format: :json)
end
