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

  field :won, type: Boolean

  # End of attributes from the Steam API
  
  embeds_many :players
  has_and_belongs_to_many :parties
  has_and_belongs_to_many :profiles
  
  scope :by_date, ->{ order_by(:start.desc) }
  scope :real, ->{ 
    where :duration.gte => 600, 
    :human_players.gte => 9 ,
    :lobby.nin => [
      'Invalid',
      'Practice',
      'Tournament',
      'Tutorial',
      'Co-op with bots'
    ], :mode.nin => [
      '?? INTRO/DEATH ??',
      'The Diretide',
      'Reverse Captains Mode',
      'Greeviling',
      'Tutorial',
      'Mid Only',
      'Compendium Matchmaking',
      'Custom',
      'Ability Draft'
    ]
  }
  scope :wins, ->{ where won: true }
  scope :losses, ->{ where won: false }

  scope :ap, ->{ where mode: "All Pick" }
  scope :rd, ->{ where mode: "Random Draft" }
  scope :sd, ->{ where mode: "Single Draft" }
  scope :cm, ->{ where mode: "Captains Mode" }
  scope :cd, ->{ where mode: "Captains Draft" }
  scope :ar, ->{ where mode: "All Random" }
  scope :ad, ->{ where mode: "Ability Draft" }

  # Did this match count? (best guess)
  def real?
    human_players == 10 \
    && duration >= 600 \
    && !['Invalid','Practice','Tournament','Tutorial','Co-op with bots'].include?(lobby) \
    && !['?? INTRO/DEATH ??','The Diretide','Reverse Captains Mode','Greeviling','Tutorial','Mid Only','Compendium Matchmaking','Custom','Ability Draft'].include?(mode)
  end

  # URLs will use the match_id instead of MongoID BSON ID
  def to_param
    match_id.to_s
  end

  # Get the player record for this profile
  def player(profile)
    players.find_by steam_account_id: profile.steam_account_id
  end

  def followed_players
    profiles.following.collect {|profile| player(profile)}
  end

  def end
    start + duration
  end

  # What team were we on? (result is worthless if we're on both teams)
  def team
    followed_players.first.team unless !followed_players.first
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
    match.associate_with_profiles
    match.determine_win
    match.associate_with_parties
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

  def self.fetch_max(options={})
    puts 'Starting Fetch'
    start = Time.now
    match_max = 100
    while true 
      history = Dota.history(options)
      for history_match in history.matches
        puts "Fetching #{history_match.id}"
        Match.find_or_fetch_from_steam history_match.id
        options[:start_at_match_id] = history_match.id
      end
      break if history.matches.count < match_max
    end
    puts 'Fetch Done in #{Time.now - start}'
  end

  def self.fetch(options={})
    history = Dota.history(options)
    for history_match in history.matches
      Match.find_or_fetch_from_steam history_match.id
    end
  end

  def self.fetch_matches_for_followed(options={})
    for profile in Profile.where follow: true
      Match.fetch_max({account_id: profile.dota_account_id}.merge(options))
    end
  end

  def associate_players(steam_players)
    for steam_player in steam_players
      player = Player.create_from_steam_player(self, steam_player)
    end
  end

  def determine_win
    update_attributes won: (team.downcase == winner.downcase)
  end

  def associate_with_profiles
    for player in players.named
      profile = Profile.find_or_create_by_steam_account_id player.steam_account_id, dota_account_id: player.dota_account_id
      profile.matches << self
    end
  end

  # Find every possible party in this batch of players
  def associate_with_parties
    return nil unless profiles.following.length > 1
    for i in 2..5
      for combination in profiles.following.combination(i)
        Party.find_or_create_by_profiles(combination).matches << self
      end
    end
  end
end
