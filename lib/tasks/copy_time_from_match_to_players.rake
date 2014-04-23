task :copy_time_from_match_to_players => :environment do
  players_collection = Mongoid.default_session[:players]

  Match.all.each do |match|
    match.players.update_all start: match.start
  end
end
