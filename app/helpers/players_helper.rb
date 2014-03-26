module PlayersHelper
  def hero_avatar(hero_id)
    image_tag Hero.avatar_for(hero_id), class: "hero-avatar"
  end

  def player_kda(player)
    player.kda
  end

  def kda_ratio(kills, deaths, assists)
    return number_with_precision (kills + assists), precision: 2 if deaths == 0
    number_with_precision ((kills.to_f + assists.to_f) / deaths.to_f), precision: 2
  end

  def player_items(player)
    items = []
    for item in player.items
      items << item_image(item)
    end
    items.join(' ').html_safe
  end

  def item_image(item)
    return '' if item == 'emptyitembg'
    image_tag Item.image(item), class: "item", alt: item
  end

  def player_ablities(player)
    player.upgrades.collect {|upgrade| Ability.list[ upgrade['ability'].to_s.to_sym ]}
      .reject{ |ability| ability == 'stats' }
      .uniq
  end
end
