json.array!(@matches) do |match|
  json.extract! match, :match_id, :day, :won
  json.url matches_path(date: match.day)
end
