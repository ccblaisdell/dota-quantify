class Party
  include Mongoid::Document

  # Game count
  field :count, type: Integer, default: 0
  field :wins, type: Integer, default: 0
  field :strict_count, type: Integer, default: 0
  field :strict_wins, type: Integer, default: 0

  # Number of profiles
  field :size, type: Integer

  has_and_belongs_to_many :profiles
  has_and_belongs_to_many :matches, after_add: :update_counts

  scope :by_size, ->{order_by(:size.desc)}

  # generates a Party for each possible combination of followed profiles
  def self.generate_all
    for i in (2..5)
      for combination in Profile.following.collect{|profile| profile.id}.combination(i).to_a
        Party.generate(combination)
      end
    end    
  end

  # Takes a group of up to 5 profiles and creates a new Party
  def self.generate(profile_ids)
    party = Party.create size: profile_ids.count, profile_ids: profile_ids
    party.matches = Match.all_in(profile_ids: profile_ids)
  end

  def self.collect(profiles)
    parties = []
    for i in (2..profiles.count)
      for combination in profiles.combination(i)
        parties << Party.all(profile_ids: combination.collect{|p|p.id}).where(:profile_ids.with_size => combination.length).first
      end
    end
    parties.compact.reverse
  end

  # Takes a list of profiles and finds (or creates) and returns the Party for that list
  def self.find_or_create_by_profiles(profiles)
    player_profile_ids = profiles.collect {|profile| profile.id}.compact
    parties = Party.all.select {|party| party.profile_ids.sort == player_profile_ids.sort}
    return parties.first unless parties.blank?
    party = Party.create size: profiles.count
    party.profiles = profiles # Profile.find(player_profile_ids)
    party
  end

  # Returns IDs for the Party's profiles
  def profile_ids
    profiles.collect {|profile| profile.id}
  end

  # Calculate winrate
  def winrate(wins=wins, count=count)
    wins.to_f / count.to_f rescue 0
  end

  # Runs after a new match is added to increment counts
  def update_counts(match)
    win = match.won?
    new_attributes = {
      count: count + 1,
      wins: win ? wins + 1 : wins
    }
    if is_strict? match
      new_attributes[:strict_count] = strict_count + 1
      new_attributes[:strict_wins] = strict_wins + 1 if win
    end
    update_attributes new_attributes
  end

  def is_strict?(match)
    match.profiles.following == profiles
  end

  def strict_matches
    matches.select {|match| match.profiles.following == profiles}
  end

  def strict_winrate
    winrate strict_wins, strict_count
  end
end
