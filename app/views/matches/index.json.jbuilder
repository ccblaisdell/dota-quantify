json.array!(@matches) do |match|
  json.extract! match, :id, :type, :mode, :date, :region, :duration, :winner
  json.url match_url(match, format: :json)
end
