class PlayersController < ApplicationController
  def index
    filter_players
    sort_players
    paginate_players
    get_kda_max(@players)
  end

  private

  def sort_players
    @players = @players.order_by([sort_column(Player, :start), sort_direction])
  end

  def filter_players
    profile_ids = Profile.following.pluck(:steam_account_id)
    match_ids = Match.real.pluck(:id)

    @players = Player.where(
      :steam_account_id.in => profile_ids, 
      :match_id.in => match_ids
    )
    filter_numerics
    filter_hero
    filter_outcome
    filter_party_size
    filter_profiles
    filter_items
  end

  def filter_items
    return if params[:filter_items].to_a.empty?
    @players = @players.all(items: params[:filter_items])
  end

  def filter_profiles
    return if params[:profiles].to_a.empty?
    ids = Profile.find(params[:profiles]).collect {|p| p.steam_account_id}
    @players = @players.in(steam_account_id: ids)
  end

  def filter_party_size
  end

  def filter_outcome
    @players = @players.where(won: params[:filter_outcome] == "won") unless params[:filter_outcome].blank?
  end

  def filter_numerics
    return if [:filter_criteria, :filter_key, :filter_limit].any? {|key| params[key].blank?}
    @players = @players.try( params[:filter_criteria], { params[:filter_key].to_sym => params[:filter_limit] } )    
  end

  def filter_hero
    @players = @players.where(hero_id: params[:filter_hero]) unless params[:filter_hero].blank?
  end

  def paginate_players
    @players = @players.page(params[:page]).per(50)
  end
end
