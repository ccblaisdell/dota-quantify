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

  field :start, type: Time # copied from Match, for sorting

  # TODO: Copy these fields from match for sorting and filtering
  field :start, type: Time
  field :lobby, type: String
  field :mode, type: String
  field :winner, type: String
  field :duration, type: Integer
  field :won, type: Boolean

  FILTERABLE_BY_NUMBER = [
    ["Kills", :kills],
    ["Assists", :assists],
    ["Deaths", :deaths],
    ["Gold", :gold],
    ["Last hits", :last_hits],
    ["Denies", :denies],
    ["Gold spent", :gold_spent],
    ["Hero damage", :hero_damage],
    ["Tower damage", :tower_damage],
    ["Hero healing", :hero_healing],
    ["Level", :level],
    ["XPM", :xpm],
    ["GPM", :gpm]
  ]

  belongs_to :match

  scope :named, ->{ where :dota_account_id.ne => 4294967295 } # non-anonymous
  scope :radiant, ->{ where :slot.lte => 127 }
  scope :dire, ->{ where :slot.gte => 128 }
  scope :by_slot, ->{ order_by(:slot.asc) }

  def self.attributes_from_steam_players(players, match)
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
        upgrades: player.upgrades,

        # copied from match, for sorting
        start: match.start,
        lobby: match.lobby,
        mode: match.mode,
        winner: match.winner,
        duration: match.duration
        # won: match.won # copied later
      }
    end
  end

  def self.following
    steam_account_ids = Profile.following.collect {|profile| profile.steam_account_id}
    self.where :steam_account_id.in => steam_account_ids
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
    return nil if dota_account_id.nil?
    dota_account_id + 76561197960265728
  end

  def anonymous?
    self.dota_account_id == 4294967295 # Means the profile is private    
  end

  def profile
    Profile.find_by steam_account_id: steam_account_id unless steam_account_id.nil?
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

  ## Guessing roles

  def role
    # check hero
    # check gpm
    # check profile
    # check items
    # check xpm
    # kda?
    # last hits?

    # we should assign a numeric value to each of the things above, tally the result,
    # then rank the players on each team by that value. Assume 3 cores and 2 supports.

    # For example:
    # logan, CM, 3/7/13, 21LH, 273XPM, 335GPM, [Tranquil Boots, Mekansm, Black King Bar, Observer Ward, Smoke of Deceit, Town Portal Scroll]
    # 10.0: HERO - cm is a 10 on the 1-10 support scale (from Hero.rb)
    #  8.0: GPM - 335, lowest, 67% of the mean (498) 
    #  9.0: PROFILE
    #  6.8: ITEMS - tranqs(7), mek(7), bkb(3), obs(10), tp(5), smoke(9)
    #  9.0 : XPM - 273, lowest, about half the mean (520)
    #  ===
    #  8.6 : Compare this to the other scores. In the event of ties, break them by

    # Hero  Player                         Level  K D  A   Gold  LH DN XPM GPM HD  HH  TD  Items
    # Bristleback Roamin Ronin  Roamin Ronin  17  5 8 11  14.7k 142  2 474 458 14.1k 0 661 Sange and YashaPower TreadsVanguardMedallion of CourageBlade Mail
    # Crystal Maiden  losandro  losandro      12  3 7 13  10.7k  21  0 273 335 4.2k  491 139 Tranquil BootsMekansmBlack King BarObserver WardSmoke of DeceitTown Portal Scroll
    # Death Prophet mgrif mgrif               18  7 8 15  15.7k  93  4 580 491 16k 597 2.1k  Magic WandBottlePhase BootsTown Portal ScrollBloodstoneForce Staff
    # Disruptor hoplyte hoplyte               15  4 6 12  11.0k  34  1 382 343 4.3k  0 252 Boots of TravelPipe of InsightEnergy BoosterTown Portal ScrollSentry Ward
    # Morphling Dialuposaurus Dialuposaurus   23 16 1  6  27.6k 227  7 890 862 17.6k 0 9k  Ethereal BladeBoots of TravelUltimate OrbLinken's SphereManta StyleHand of Midas
    ""
  end
end
