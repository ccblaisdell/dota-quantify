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
    fields = [
      :kda_ratio, 
      :kills, 
      :deaths, 
      :assists, 
      :won, 
      :outcome, 
      :xpm, 
      :gpm, 
      :duration, 
      :start,
      :adjusted_start
    ]
    if @profile
      @players = @profile.players.where(hero_id: @hero[:id]).only(fields)
    else
      @players = Player.where(hero_id: @hero[:id]).only(fields)
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
