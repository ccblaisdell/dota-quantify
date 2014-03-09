class Match
  include Mongoid::Document

  # The following attributes are from the Steam API

  field :match_id, type: Integer
  field :seq_num, type: Integer
  field :start, type: Time
  field :lobby, type: String
  field :mode, type: String
  field :winner, type: String
  field :duration, type: Integer

  field :first_blood, type: Integer
  field :dire_tower_status, type: Integer
  field :radiant_tower_status, type: Integer
  field :dire_barracks_status, type: Integer
  field :radiant_barracks_status, type: Integer

  field :season, type: Integer
  field :human_players, type: Integer
  field :positive_votes, type: Integer
  field :negative_votes, type: Integer
  field :cluster, type: Integer
  field :league_id, type: Integer

  # End of attributes from the Steam API
  
  # has many players

  def self.find_or_fetch_from_steam(match_id)
    self.find_by(match_id: match_id) || Match.create_from_steam_match(Dota.match(match_id))
  end

  def self.create_from_steam_match(match)
    Match.create Match.attributes_from_steam_match(match)
  end

  def self.attributes_from_steam_match(match)
    {
      match_id: match.id,
      seq_num: match.seq_num,
      start: match.start,
      lobby: match.lobby,
      mode: match.mode,
      winner: match.winner,
      duration: match.duration,
      first_blood: match.first_blood,
      dire_tower_status: match.dire_tower_status,
      radiant_tower_status: match.radiant_tower_status,
      dire_barracks_status: match.radiant_barracks_status,
      season: match.season,
      human_players: match.human_players,
      positive_votes: match.positive_votes,
      negative_votes: match.negative_votes,
      cluster: match.cluster,
      league_id: match.league_id
    }
  end
end
