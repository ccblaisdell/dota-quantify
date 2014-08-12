json.array!(@matches) do |match|
  json.extract! match, :match_id, :day, :won
  json.url report_path(:daily, match.day.year, match.day.month, match.day.day)
end
