module PlayersHelper
  def player_hero_avatar(player)
    image_tag Hero.avatar_for(player.hero_id), class: "hero-avatar"
  end

  def player_kda(player)
    player.kda
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
end
