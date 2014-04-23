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
  
  has_many :players
  has_and_belongs_to_many :parties
  has_and_belongs_to_many :profiles

  accepts_nested_attributes_for :players
  
  scope :by_date, ->{ order_by(:start.desc) }
  scope :real, ->{ 
    where :duration.gte => 600, 
    :human_players.gte => 9,
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
  scope :between, ->(start, stop) { where(start: {'$gte' => start, '$lte' => stop}) }
  scope :on_date, ->(date) do
    return if date.nil?
    # Mar 28th will yield all games from 5am Mar 28 to 4:59am Mar 29
    start = date.to_time +  5.hours
    stop  = date.to_time + 29.hours
    where(
      start: {'$gte' => start, '$lte' => stop},
    )
  end
  scope :by_profiles, ->(profiles) {
    return if profiles.nil?
    where(:profile_ids.all => profiles) 
  }

  scope :ap, ->{ where mode: "All Pick" }
  scope :rd, ->{ where mode: "Random Draft" }
  scope :sd, ->{ where mode: "Single Draft" }
  scope :cm, ->{ where mode: "Captains Mode" }
  scope :cd, ->{ where mode: "Captains Draft" }
  scope :ar, ->{ where mode: "All Random" }
  scope :ad, ->{ where mode: "Ability Draft" }

  def ad?
    mode == "AD"
  end

  def day
    (start - 12.hours).to_date
  end

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
    players.where :steam_account_id.in => profiles.following.only(:steam_account_id).map(&:steam_account_id)
  end

  def end
    start + duration
  end

  # What team were we on? (result is worthless if we're on both teams)
  def team
    followed_players.first.try(:team)
  end

  def ranked?
    lobby == 'Ranked'
  end

  def self.find_or_fetch_from_steam(match_id)
    self.find_by(match_id: match_id) || Match.create_from_steam_match(Dota.match(match_id))
  end

  def self.create_from_steam_match(steam_match)
    match = Match.create Match.attributes_from_steam_match(steam_match)
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
      league_id: match.league_id,
      players_attributes: Player.attributes_from_steam_players(match.players, match)
    }
  end

  MATCH_MAX = 100
  def self.fetch_max(options={})
    count = 0
    while true 
      history = Dota.history(options)
      for history_match in history.matches
        count = count + 1
        logger.debug "Fetching #{history_match.id} for #{options[:dota_account_id]}(#{count})"
        begin
          Match.delay.find_or_fetch_from_steam history_match.id
          options[:start_at_match_id] = history_match.id
        rescue
          logger.debug "Fetch failed for match #{history_match.id}, continuing"
          next
        end
      end
      break if history.matches.count < MATCH_MAX 
    end
  end

  def self.fetch(options={})
    history = Dota.history(options)
    for history_match in history.matches
      Match.find_or_fetch_from_steam history_match.id
    end
  end

  def self.fetch_matches_for_followed(options={})
    for profile in Profile.following
      Match.delay.fetch_max({account_id: profile.dota_account_id}.merge(options))
    end
  end

  def self.fetch_recent_for_followed(options={})
    Profile.following.each { |profile| Match.fetch({account_id: profile.dota_account_id, matches_requested: 20}.merge(options)) }
  end

  def determine_win
    update_attributes won: (team.try(:downcase) == winner.downcase)
  end

  def associate_with_profiles
    ids = players.named.collect {|p| p.steam_account_id}
    self.profiles = Profile.in(steam_account_id: ids)
    self.save
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

  def party
    Party.find_or_create_by_profiles profiles.following
  end

  def mode
    case read_attribute(:mode)
    when "All Pick"
      "AP"
    when "All Random"
      "AR"
    when "Ability Draft"
      "AD"
    when "Random Draft"
      "RD"
    when "Single Draft"
      "SD"
    when "Captains Draft"
      "CD"
    when "Captains Mode"
      "CM"
    else
      read_attribute(:mode)
    end
  end
end
