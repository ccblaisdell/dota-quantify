class PartiesController < ApplicationController
  before_action :set_party, only: [:show, :edit, :update, :destroy]

  def index
    @parties = Party.by_size
  end

  def show
    @matches = @party.matches.real.by_date.page params[:page]
  end

  private

    def set_party
      @party = Party.find(params[:id])
    end
end
