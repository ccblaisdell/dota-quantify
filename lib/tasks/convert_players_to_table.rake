task :convert_players_to_table => :environment do
  players_collection = Mongoid.default_session[:players]

  Match.all.each do |match|
    match.players.all.each do |player|
      player.attributes['match_id'] = match.id
      players_collection.insert player.attributes # save children to separate collection
    end

    match.players = nil # remove embedded data
    match.save
  end
end
