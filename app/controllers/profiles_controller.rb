class ProfilesController < ApplicationController
  before_action :set_profile, only: [:show, :edit, :update, :destroy]

  # GET /profiles
  # GET /profiles.json
  def index
    @profiles = Profile.following.page params[:page]
  end

  def all
    @profiles = Profile.page params[:page]
    render 'index'
  end

  def dashboard
    @profiles = Profile.following
    @matches = Match.by_date.limit(10)
    @ap = Match.ap
    @sd = Match.sd
    @rd = Match.rd
    @ar = Match.ar
    @cm = Match.cm
  end

  # GET /profiles/1
  # GET /profiles/1.json
  def show
    @matches = @profile.matches.by_date.limit(10)
  end

  # DELETE /profiles/1
  # DELETE /profiles/1.json
  def destroy
    @profile.destroy
    respond_to do |format|
      format.html { redirect_to profiles_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_profile
      @profile = Profile.find_by(dota_account_id: params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def profile_params
      params.require(:profile).permit(:name, :steam_profile_id, :dota_account_id, :follow)
    end
end
