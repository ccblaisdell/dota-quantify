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

  belongs_to :match

  scope :named, ->{ where :dota_account_id.ne => 4294967295 } # non-anonymous
  scope :radiant, ->{ where :slot.lte => 127 }
  scope :dire, ->{ where :slot.gte => 128 }
  scope :by_slot, ->{ order_by(:slot.asc) }

  def self.attributes_from_steam_players(players)
    players.collect do |player|
      {
        dota_account_id: player.id,
        steam_account_id: Player.convert_32_bit_account_id_to_64_bit_steam_id(player.id),
        slot: player.slot,
        hero_id: player.hero_id,
        hero: player.hero,
        kills: player.kills,
        deaths: player.deaths,
        assists: player.assists,
        kda: player.kda,
        leaver_status: player.leaver_status,
        gold: player.gold,
        last_hits: player.last_hits,
        denies: player.denies,
        gold_spent: player.gold_spent,
        hero_damage: player.hero_damage,
        tower_damage: player.tower_damage,
        hero_healing: player.hero_healing,
        level: player.level,
        xpm: player.xpm,
        gpm: player.gpm,
        items: player.items,
        # additional_unit_items: player.additional_unit_items,
        # additional_unit_names: player.additional_unit_names,
        upgrades: player.upgrades
      }
    end
  end

  def won?
    match.won?
  end

  def name
    self.profile.try(:name) || "anonymous"
  end

  def kda_ratio
    return kills + assists if deaths < 1
    ((kills.to_f + assists.to_f) / deaths.to_f)
  end

  # The match API returns a 32 bit dota account ID,
  # which can't directly be used to look up a profile
  # http://dev.dota2.com/showthread.php?t=108926
  # There has got to be a better way
  def self.convert_32_bit_account_id_to_64_bit_steam_id(dota_account_id)
    return nil if dota_account_id == 4294967295
    dota_account_id + 76561197960265728
  end

  def anonymous?
    self.dota_account_id == 4294967295 # Means the profile is private    
  end

  def profile
    Profile.find_by steam_account_id: steam_account_id
  end

  def team
    slot < 128 ? "Radiant" : "Dire"
  end

  def net_worth
    gold + gold_spent
  end

  def item_image_paths
    items.collect do |item|
      Item.image(item) unless item == 'emptyitembg'
    end
  end
end
