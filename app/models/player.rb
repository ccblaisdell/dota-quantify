class Player
  include Mongoid::Document
  field :dota_account_id, type: Integer
  field :steam_account_id, type: Integer
  field :slot, type: Integer
  field :hero_id, type: Integer
  field :hero, type: String
  field :kills, type: Integer
  field :deaths, type: Integer
  field :assists, type: Integer
  field :kda, type: Array
  field :leaver_status, type: String
  field :gold, type: Integer
  field :last_hits, type: Integer
  field :denies, type: Integer
  field :gold_spent, type: Integer
  field :hero_damage, type: Integer
  field :tower_damage, type: Integer
  field :hero_healing, type: Integer
  field :level, type: Integer
  field :xpm, type: Integer
  field :gpm, type: Integer
  field :items, type: Array
  field :additional_unit_items, type: Array
  field :additional_unit_names, type: Array
  field :upgrades, type: Array
  field :anonymous, type: Boolean
  field :won, type: Boolean

  belongs_to :match, index: true
  belongs_to :profile, index: true

  after_create :convert_32_bit_account_id_to_64_bit_steam_id
  after_create :associate_with_profile
  after_create :determine_win

  def self.create_from_steam_player(match, steam_player)
    match.players.create({
      dota_account_id: steam_player.id,
      slot: steam_player.slot,
      hero_id: steam_player.hero_id,
      hero: steam_player.hero,
      kills: steam_player.kills,
      deaths: steam_player.deaths,
      assists: steam_player.assists,
      kda: steam_player.kda,
      leaver_status: steam_player.leaver_status,
      gold: steam_player.gold,
      last_hits: steam_player.last_hits,
      denies: steam_player.denies,
      gold_spent: steam_player.gold_spent,
      hero_damage: steam_player.hero_damage,
      tower_damage: steam_player.tower_damage,
      hero_healing: steam_player.hero_healing,
      level: steam_player.level,
      xpm: steam_player.xpm,
      gpm: steam_player.gpm,
      items: steam_player.items
      # additional_unit_items: steam_player.additional_unit_items,
      # additional_unit_names: steam_player.additional_unit_names,
      # upgrades: steam_player.upgrades || [],
    })
  end

  def name
    self.profile.try(:name) || "anonymous"
  end

  # The match API returns a 32 bit dota account ID,
  # which can't directly be used to look up a profile
  # http://dev.dota2.com/showthread.php?t=108926
  # There has got to be a better way
  def convert_32_bit_account_id_to_64_bit_steam_id
    self.update_attributes(anonymous: true) and return if self.dota_account_id == 4294967295 # Means the profile is private
    self.update_attributes(steam_account_id: self.dota_account_id + 76561197960265728)
  end

  def associate_with_profile
    return nil if self.anonymous?
    profile = Profile.find_or_create_by_steam_account_id( self.steam_account_id, {dota_account_id: self.dota_account_id} )
    profile.players << self
  end

  def radiant?
    slot < 128
  end

  def dire?
    slot >= 128
  end

  def determine_win
    # shouldn't need these tries
    update_attributes won: (match.try(:radiant_won?) && radiant?) || (match.try(:dire_won?) && dire?)
  end
end
