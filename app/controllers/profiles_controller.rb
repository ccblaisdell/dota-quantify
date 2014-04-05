class ProfilesController < ApplicationController
  before_action :set_profile, only: [:show, :edit, :update, :heroes, :matches]

  # GET /profiles
  # GET /profiles.json
  def index
    @profiles = Profile.following.page params[:page]
  end

  def export
    @profiles = Profile.all
    render 'index'
  end

  def dashboard
  end

  # GET /profiles/1
  # GET /profiles/1.json
  def show
    @matches = @profile.matches.by_date.limit(10)
  end

  def heroes
    @heroes = @profile.heroes
  end

  def matches
    @players = @profile.players.order_by([sort_column(Player, :id), sort_direction]).page(params[:page])
  end

  def update
    @profile.update_attributes profile_params
    redirect_to 'show'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_profile
      @profile = Profile.find_by(dota_account_id: params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def profile_params
      params.require(:profile).permit(:name, :steam_profile_id, :dota_account_id, :follow, :nickname)
    end
end
