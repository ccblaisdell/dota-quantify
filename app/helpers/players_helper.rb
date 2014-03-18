module PlayersHelper
  def player_hero_avatar(player)
    image_tag Hero.avatar_for(player.hero_id), class: "hero-avatar"
  end

  def player_kda(player)
    player.kda
  end
end
