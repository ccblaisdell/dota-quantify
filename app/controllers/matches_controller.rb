class MatchesController < ApplicationController
  before_action :set_match, only: [:show]

  def fetch
    Match.delay.fetch(params)
    flash[:notice] = "Fetching matches, please refresh the page in a few moments."
    redirect_to action: 'index'
  end

  def fetch_recent
    Match.fetch_recent_for_followed
    redirect_to action: 'index'
  end

  def fetch_for_followed
    Match.delay.fetch_matches_for_followed
    flash[:notice] = "Fetching matches, please refresh the page in a few moments."
    redirect_to action: 'index'
  end

  # GET /matches
  # GET /matches.json
  def index
    @matches = Match.by_date.on_date(params[:date]).page(params[:page])
  end

  def calendar
    @matches = Match.only(:match_id, :start, :won, :profile_ids).by_date.by_profiles(params[:profile_ids])
  end

  def export
    @matches = Match.by_date
    render 'index'
  end

  # GET /matches/1
  # GET /matches/1.json
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_match
      @match = Match.includes(:players).find_by(match_id: params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def match_params
      params.require(:match).permit(:match_id)
    end
end
