class MatchesController < ApplicationController
  before_action :set_match, only: [:show]

  def fetch
    Match.delay.fetch(params)
    flash[:notice] = "Fetching matches, please refresh the page in a few moments."
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
    @matches = Match.order(:start.desc).page params[:page]
  end

  # GET /matches/1
  # GET /matches/1.json
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_match
      @match = Match.find_or_fetch_from_steam(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def match_params
      params.require(:match).permit(:type, :mode, :date, :region, :duration, :winner)
    end
end
