class Party
  include Mongoid::Document

  # Game count
  field :count, type: Integer, default: 0
  field :wins, type: Integer, default: 0

  # Number of profiles
  field :size, type: Integer

  has_and_belongs_to_many :profiles
  has_many :matches, after_add: :update_counts

  scope :by_size, ->{order_by(:size.desc)}

  # generates a Party for each possible combination of followed profiles
  def self.generate_all
    for i in (2..5)
      for combination in Profile.following.combination(i).to_a
        Party.generate(combination)
      end
    end    
  end

  # Takes a group of up to 5 profiles and creates a new Party
  def self.generate(profiles)
    party = Party.create
    party.size = profiles.count
    party.profiles = profiles.to_a
    party.save
  end

  # Takes a list of players and finds (or creates) and returns the Party for that list
  def self.find_or_create_by_players(players)
    player_profile_ids = players.collect {|player| player.profile.try(:id)}.compact
    parties = Party.all.select {|party| party.profile_ids.sort == player_profile_ids.sort}
    return parties.first unless parties.blank?
    party = Party.create size: players.count
    party.profiles = Profile.find(player_profile_ids)
    party
  end

  # Returns IDs for the Party's profiles
  def profile_ids
    profiles.collect {|profile| profile.id}
  end

  # Calculate winrate
  def winrate
    ((wins.to_f / count.to_f) * 100).to_i rescue 0
  end

  # Runs after a new match is added to increment counts
  def update_counts(match)
    new_wins = match.followed_players.first.won? ? wins + 1 : wins
    new_count = count + 1
    update_attributes wins: new_wins, count: new_count
  end
end
