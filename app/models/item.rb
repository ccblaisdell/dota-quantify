require "open-uri"

class Item
  ITEMS = {
    "Abyssal Blade" => "item_abyssal_blade",
    "Aegis" => "item_aegis",
    "Tango" => "item_tango",
    "Arcane Boots" => "item_arcane_boots",
    "Armlet of Mordiggian" => "item_armlet",
    "Assault Cuirass" => "item_assault",
    "Skull Basher" => "item_basher",
    "Belt of Strength" => "item_belt_of_strength",
    "Battlefury" => "item_bfury",
    "Black King Bar" => "item_black_king_bar",
    "Blade Mail" => "item_blade_mail",
    "Blade of Alacrity" => "item_blade_of_alacrity",
    "Blades of Attack" => "item_blades_of_attack",
    "Blink Dagger" => "item_blink",
    "Bloodstone" => "item_bloodstone",
    "Boots of Speed" => "item_boots",
    "Band of Elvenskin" => "item_boots_of_elves",
    "Bottle" => "item_bottle",
    "Bracer" => "item_bracer",
    "Iron Branch" => "item_branches",
    "Broadsword" => "item_broadsword",
    "Buckler" => "item_buckler",
    "Butterfly" => "item_butterfly",
    "Chainmail" => "item_chainmail",
    "Cheese" => "item_cheese",
    "Circlet" => "item_circlet",
    "Clarity" => "item_clarity",
    "Claymore" => "item_claymore",
    "Cloak" => "item_cloak",
    "Animal Courier" => "item_courier",
    "Eul's Scepter of Divinity" => "item_cyclone",
    "Dagon" => "item_dagon",
    "Demon Edge" => "item_demon_edge",
    "Desolator" => "item_desolator",
    "Diffusal Blade" => "item_diffusal_blade",
    "Divine Rapier" => "item_rapier",
    "Drum of Endurance" => "item_ancient_janggo",
    "Dust of Appearance" => "item_dust",
    "Eaglesong" => "item_eagle",
    "Energy Booster" => "item_energy_booster",
    "Ethereal Blade" => "item_ethereal_blade",
    "Healing Salve" => "item_flask",
    "Flying Courier" => "item_flying_courier",
    "Force Staff" => "item_force_staff",
    "Gauntlets of Strength" => "item_gauntlets",
    "Gem of True Sight" => "item_gem",
    "Ghost Scepter" => "item_ghost",
    "Gloves of Haste" => "item_gloves",
    "Daedalus" => "item_greater_crit",
    "Hand of Midas" => "item_hand_of_midas",
    "Headdress" => "item_headdress",
    "Heart of Tarrasque" => "item_heart",
    "Heaven's Halberd" => "item_heavens_halberd",
    "Helm of Iron Will" => "item_helm_of_iron_will",
    "Helm of the Dominator" => "item_helm_of_the_dominator",
    "Hood of Defiance" => "item_hood_of_defiance",
    "Hyperstone" => "item_hyperstone",
    "Shadow Blade" => "item_invis_sword",
    "Javelin" => "item_javelin",
    "Crystalys" => "item_lesser_crit",
    "Satanic" => "item_lifesteal",
    "Maelstrom" => "item_maelstrom",
    "Magic Stick" => "item_magic_stick",
    "Magic Wand" => "item_magic_wand",
    "Manta Style" => "item_manta",
    "Mantle of Intelligence" => "item_mantle",
    "Mask of Madness" => "item_mask_of_madness",
    "Medallion of Courage" => "item_medallion_of_courage",
    "Mekansm" => "item_mekansm",
    "Mithril Hammer" => "item_mithril_hammer",
    "Mjollnir" => "item_mjollnir",
    "Monkey King Bar" => "item_monkey_king_bar",
    "Mystic Staff" => "item_mystic_staff",
    "Necronomicon" => "item_necronomicon",
    "Null Talisman" => "item_null_talisman",
    "Oblivion Staff" => "item_oblivion_staff",
    "Ogre Axe" => "item_ogre_axe",
    "Orb of Venom" => "item_orb_of_venom",
    "Orchid Malevolence" => "item_orchid",
    "Perseverance" => "item_pers",
    "Phase Boots" => "item_phase_boots",
    "Pipe of Insight" => "item_pipe",
    "Platemail" => "item_platemail",
    "Point Booster" => "item_point_booster",
    "Poor Man's Shield" => "item_poor_mans_shield",
    "Power Treads" => "item_power_treads",
    "Quarterstaff" => "item_quarterstaff",
    "Quelling Blade" => "item_quelling_blade",
    "Radiance" => "item_radiance",
    "Divine Rapier" => "item_rapier",
    "Reaver" => "item_reaver",
    "Refresher Orb" => "item_refresher",
    "Sacred Relic" => "item_relic",
    "Ring of Aquila" => "item_ring_of_aquila",
    "Ring of Basilius" => "item_ring_of_basilius",
    "Ring of Health" => "item_ring_of_health",
    "Ring of Protection" => "item_ring_of_protection",
    "Ring of Regen" => "item_ring_of_regen",
    "Robe of the Magi" => "item_robe",
    "Rod of Atos" => "item_rod_of_atos",
    "Sange" => "item_sange",
    "Sange and Yasha" => "item_sange_and_yasha",
    "Satanic" => "item_satanic",
    "Scythe of Vyse" => "item_sheepstick",
    "Shiva's Guard" => "item_shivas_guard",
    "Eye of Skadi" => "item_skadi",
    "Slippers of Agility" => "item_slippers",
    "Smoke of Deceit" => "item_smoke_of_deceit",
    "Sage's Mask" => "item_sobi_mask",
    "Shadow Amulet" => "item_shadow_amulet",
    "Soul Booster" => "item_soul_booster",
    "Soul Ring" => "item_soul_ring",
    "Linken's Sphere" => "item_sphere",
    "Staff of Wizardry" => "item_staff_of_wizardry",
    "Stout Shield" => "item_stout_shield",
    "Talisman of Evasion" => "item_talisman_of_evasion",
    "Tango" => "item_tango",
    "Teleport Scroll" => "item_tpscroll",
    "Tranquil Boots" => "item_tranquil_boots",
    "Boots of Travel" => "item_travel_boots",
    "Ultimate Orb" => "item_ultimate_orb",
    "Aghanim's Scepter" => "item_ultimate_scepter",
    "Urn of Shadows" => "item_urn_of_shadows",
    "Vanguard" => "item_vanguard",
    "Veil of Discord" => "item_veil_of_discord",
    "Vitality Booster" => "item_vitality_booster",
    "Vladmir's Offering" => "item_vladmir",
    "Void Stone" => "item_void_stone",
    "Observer Ward" => "item_ward_observer",
    "Sentry Ward" => "item_ward_sentry",
    "Wraith Band" => "item_wraith_band",
    "Yasha" => "item_yasha"
  }

  # Download item images
  def self.download_images
    ITEMS.each_pair do |name, id|
      item = Item.item_name(id)
      Item.download_image(item + Item.image_suffix)
    end
  end

  def self.download_image(filename)
    File.open(Rails.root.join('app','assets','images','items',filename), 'wb') do |fo|
      fo.puts open('http://cdn.dota2.com/apps/dota2/images/items/' + filename).read 
    end
  end

  def self.item_name(item)
    item.gsub('item_','')
  end

  def self.image(item)
    'items/' + item + Item.image_suffix
  end

  def self.image_suffix
    '_lg.png'
  end
end