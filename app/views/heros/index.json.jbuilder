json.array!(@heros) do |hero|
  json.extract! hero, :id, :name, :type
  json.url hero_url(hero, format: :json)
end
