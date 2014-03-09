class Player
  include Mongoid::Document
  field :steam_profile_id, type: Integer
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

  embedded_in :match, inverse_of: :players

  def self.create_from_steam_player(match, steam_player)
    match.players.create({
      steam_profile_id: steam_player.id,
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
end
