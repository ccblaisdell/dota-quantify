class PartiesController < ApplicationController
  before_action :set_party, only: [:show]

  def index
    if request.format == 'json'
      @parties = Party.by_size
    else
      @profiles = Profile.following
      @profiles_json = @profiles.to_json except: [:match_ids]
    end
  end

  def show
    @matches = @party.matches.by_date.page params[:page]
  end

  private

    def set_party
      @party = Party.find(params[:id])
    end
end
