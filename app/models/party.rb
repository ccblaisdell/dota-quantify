class Party
  include Mongoid::Document

  # cache the winrate
  # field :winrate, type: Float

  has_and_belongs_to_many :profiles
  has_many :matches

  # generates a Party for each possible combination of followed profiles
  def self.generate_for_followed
    for i in (2..5)
      for combination in Profile.following.combination(i).to_a
        Party.generate(combination)
      end
    end    
  end

  def self.generate(profiles)
    party = Party.create
    party.profiles = profiles.to_a
    party.save
  end

  def self.find_by_players(players)
    player_profile_ids = players.collect {|player| player.profile.try(:id)}.compact
    parties = Party.all.select {|party| party.profile_ids.sort == player_profile_ids.sort}
    parties.first
    # Party.all.select {|party| party.profile_ids.sort == player_profile_ids.sort}.first
  end

  def profile_ids
    profiles.collect {|profile| profile.id}
  end

  def winrate
    ((wins.length.to_f / matches.length.to_f) * 100).to_i rescue 0
  end

  def wins
    matches.select {|match| match.followed_players.first.won?}
  end
end
