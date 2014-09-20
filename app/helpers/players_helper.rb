module PlayersHelper
  def hero_avatar(hero_id, options={})
    options[:class] = [options[:class], "hero-avatar"].join(' ')
    image_tag Hero.avatar_for(hero_id), options unless hero_id == 0
  end

  def hero_avatar_path(hero_id)
    asset_path Hero.avatar_for(hero_id)
  end

  def player_kda(player)
    player.kda
  end

  def kda_ratio(kills, deaths, assists)
    return kills + assists if deaths < 1
    ((kills.to_f + assists.to_f) / deaths)
  end

  def player_items(player)
    items = []
    for item in player.items
      items << item_image(item) unless item.nil?
    end
    items.join('').html_safe
  end

  def item_image(item)
    return '' if item == 'emptyitembg'
    image_tag Item.image(item), class: "item", alt: item
  end

  def ability_image(id)
    image_tag Ability.image_url(id.to_s.to_sym), title: Ability.list[id.to_s.to_sym]
  end

  def player_abilities(player)
    abilities = player.upgrades.collect{|upgrade| upgrade['ability']}.uniq.collect do |id|
      ability_image(id) unless Ability.stats?(id)
    end
    content_tag :span, abilities.join('').html_safe, class: "ability-draft-abilities"
  end

  def players_menu
    menu link_to("Overview", players_path),
      link_to("Charts", charts_players_path)
  end
end
