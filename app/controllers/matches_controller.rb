class MatchesController < ApplicationController
  before_action :set_match, only: [:show, :edit, :update, :destroy]

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

  # PATCH/PUT /matches/1
  # PATCH/PUT /matches/1.json
  def update
    respond_to do |format|
      if @match.update(match_params)
        format.html { redirect_to @match, notice: 'Match was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @match.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /matches/1
  # DELETE /matches/1.json
  def destroy
    @match.destroy
    respond_to do |format|
      format.html { redirect_to matches_url }
      format.json { head :no_content }
    end
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
