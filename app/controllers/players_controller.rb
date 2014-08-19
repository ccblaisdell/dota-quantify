class PlayersController < ApplicationController
  def index
    profile_ids = Profile.where(follow: true).pluck(:steam_account_id)
    match_ids = Match.real.pluck(:id)
    @players = Player.where(
        :steam_account_id.in => profile_ids, 
        :match_id.in => match_ids
      ).order_by([sort_column(Player, :start), sort_direction])
      .page(params[:page])
    get_kda_max(@players)
  end
end
