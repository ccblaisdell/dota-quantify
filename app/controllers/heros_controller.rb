class HerosController < ApplicationController
  before_filter :get_profile, except: [:index]
  before_filter :get_hero, except: [:index]

  # GET /heros
  def index
  end

  # GET /heros/1
  def show
  end

  def kda
    if @profile
      @players = @profile.players.real.where(hero_id: @hero[:id])
    else
      @players = Player.following.real.where(hero_id: @hero[:id])
      # @players = Player.following.real
    end
  end

  private

  def get_profile
    @profile = Profile.find_by(dota_account_id: params[:profile_id])
  end

  def get_hero
    @hero = Hero.find(params[:id])
  end
end
