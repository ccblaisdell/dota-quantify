class Profile
  include Mongoid::Document
  field :steam_account_id, type: Integer
  field :dota_account_id, type: Integer
  field :name, type: String
  field :real_name, type: String
  field :steam_clan_id, type: Integer
  field :country_code, type: String
  field :state_code, type: String
  field :access_state, type: String
  field :configured, type: Boolean
  field :last_login, type: Time
  field :profile_url, type: String
  field :small_avatar_url, type: String
  field :big_avatar_url, type: String
  field :commentable, type: Boolean
  field :follow, type: Boolean, default: false
  field :nickname, type: String

  # game user is currently playing
  field :game_id, type: Integer
  field :game_title, type: String
  field :game_server_ip, type: String

  field :last_match, type: Date
  
  field :match_count, type: Integer
  field :wins, type: Integer
  field :losses, type: Integer
  
  field :real_match_count, type: Integer
  field :real_wins, type: Integer
  field :real_losses, type: Integer

  field :war, type: Integer

  has_and_belongs_to_many :matches
  has_and_belongs_to_many :parties

  scope :following, ->{where(follow: true)}

  def to_param
    dota_account_id.to_s
  end

  def self.find_or_new_from_steam_account_id(steam_account_id)
    self.find_by(steam_account_id: steam_account_id) || self.new(self.profile_attributes_from_steam_profile( Dota.profiles(steam_account_id)[0] ))
  end

  def self.find_or_create_by_steam_account_id(steam_account_id, additional_attributes={})
    self.find_by(steam_account_id: steam_account_id) || self.create(self.profile_attributes_from_steam_profile( Dota.profiles(steam_account_id)[0], additional_attributes ))
  end

  def self.profile_attributes_from_steam_profile(steam_profile, additional_attributes={})
    {
      steam_account_id: steam_profile.id,
      name: steam_profile.person_name,
      real_name: steam_profile.real_name,
      steam_clan_id: steam_profile.clan_id,
      country_code: steam_profile.country_code,
      state_code: steam_profile.state_code,
      access_state: steam_profile.access_state,
      configured: steam_profile.configured?,
      last_login: steam_profile.last_login,
      profile_url: steam_profile.profile_url,
      small_avatar_url: steam_profile.small_avatar_url,
      big_avatar_url: steam_profile.big_avatar_url,
      commentable: steam_profile.commentable?
    }.merge additional_attributes
  end

  def players
    Player.where steam_account_id: steam_account_id
  end

  def heroes
    map = %Q{
      function() {
        if (this.hero_id !== 0) {
          emit(this.hero_id, { 
            kills: this.kills,
            deaths: this.deaths,
            assists: this.assists,
            gold: this.gold,
            gold_spent: this.gold_spent,
            last_hits: this.last_hits,
            denies: this.denies,
            hero_damage: this.hero_damage,
            tower_damage: this.tower_damage,
            hero_healing: this.hero_healing,
            xpm: this.xpm,
            gpm: this.gpm
          });
        }
      }
    }

    reduce = %Q{
      function(key, values) {
        var result = {count: values.length};
        for(var k in values[0]){
          result[k] = 0;
        }

        values.forEach(function(value) {
          for(var k in value) {
            result[k] += value[k];
          }
        });

        return result;
      }
    }

    results = players.map_reduce(map, reduce).out(inline: 1).to_a
    heroes = results.collect do |r|
      {
        hero_id: r["_id"].to_i,
        count: (r["value"]["count"] || 1).to_i,
        kills: r['value']['kills'].to_i,
        deaths: r['value']['deaths'].to_i,
        assists: r['value']['assists'].to_i,
        gold: r['value']['gold'].to_i,
        gold_spent: r['value']['gold_spent'].to_i,
        last_hits: r['value']['last_hits'].to_i,
        denies: r['value']['denies'].to_i,
        hero_damage: r['value']['hero_damage'].to_i,
        tower_damage: r['value']['tower_damage'].to_i,
        hero_healing: r['value']['hero_healing'].to_i,
        xpm: r['value']['xpm'].to_i,
        gpm: r['value']['gpm'].to_i
      }
    end
    heroes.sort { |a,b| b[:count] <=> a[:count] }
  end

  # Trying to compare map reduce to a ruby way
  def slow_heroes
    result = {}
    players.distinct(:hero_id).each do |hero_id|
      hero = {kills: 0, deaths: 0, assists: 0, count: 0}

      players.where(hero_id: hero_id).each do |player|
        hero[:kills] += player[:kills]
        hero[:deaths] += player[:deaths]
        hero[:assists] += player[:assists]
        hero[:count] += 1
      end

      result[hero_id] = hero
    end
    result
  end

  def count_games
    w   = 0
    l   = 0
    mc  = 0
    rw  = 0
    rl  = 0
    rmc = 0
    
    for match in matches
      mc +=1
      match.won? ? w += 1 : l += 1

      next unless match.real?
      
      rmc +=1
      match.won? ? rw += 1 : rl += 1
    end

    update_attributes match_count: mc, wins: w, losses: l, real_match_count: rmc, real_wins: rw, real_losses: rl
  end

  def self.index(steam_account_id)
    ind = self.following.pluck(:steam_account_id).index(steam_account_id)
    ind ? ind : 0
  end
end
