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
  
  has_many :players
  belongs_to :party
  has_and_belongs_to_many :profiles

  # This should do real matches only, right now it sucks
  default_scope ->{ where :human_players.gte => 9 }
  
  scope :by_date, ->{order_by(:start.desc)}

  after_create :associate_with_profiles
  after_create :associate_with_party

  def to_param
    match_id.to_s
  end

  def followed_players
    self.players.collect {|player| player if player.profile.try(:follow?)}.compact
  end

  def won?(player)
    player.won?
  end

  def radiant_won?
    winner == 'radiant'
  end

  def dire_won?
    winner == 'dire'
  end

  def ranked?
    lobby == 'Ranked'
  end

  def self.find_or_fetch_from_steam(match_id)
    self.find_by(match_id: match_id) || Match.create_from_steam_match(Dota.match(match_id))
  end

  def self.create_from_steam_match(steam_match)
    match = Match.create Match.attributes_from_steam_match(steam_match)
    match.associate_players(steam_match.players)
    match
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

  def self.fetch(options={})
    history = Dota.history(options)
    for history_match in history.matches
      Match.find_or_fetch_from_steam history_match.id
    end
  end

  def self.fetch_matches_for_followed(options={})
    for profile in Profile.where follow: true
      Match.fetch({account_id: profile.dota_account_id}.merge(options))
    end
  end

  def associate_players(steam_players)
    for steam_player in steam_players
      player = Player.create_from_steam_player(self, steam_player)
    end
  end

  def associate_with_profiles
    for player in players
      profiles << player.profile
    end
  end

  def associate_with_party
    party = Party.find_by_players followed_players if followed_players.length > 1
    party.matches << self if party
  end
end
