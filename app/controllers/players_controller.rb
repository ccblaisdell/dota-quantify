class PlayersController < ApplicationController
  before_action :set_player, only: [:update]
  def index
    filter_players
    sort_players
    paginate_players
    get_kda_max(@players)
  end

  def charts
  end

  def charts_data
    # @players = Player.following.real.in(hero_id: 0..10)
    # @players = Player.following.real#.where(hero_id: 106)
    # @players = Player.between(
    #   Time.now - 6.months,
    #   Time.now
    # ).following.real
    @players = Player.following.real.by_date.limit(2000)
  end

  def update
    @player.update_attributes profile_params
    render text: @player.role and return if request.xhr?
    redirect_to :back
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_player
    @player = Player.find_by(id: params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def profile_params
    params.require(:player).permit(:role)
  end

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
