module PlayersHelper
  def player_hero_avatar(player)
    player.hero
  end

  def player_kda(player)
    player.kda
  end
end
