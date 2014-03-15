class PartiesController < ApplicationController
  before_action :set_party, only: [:show, :edit, :update, :destroy]

  def index
    @parties = Party.all
  end

  def show
  end

  private

    def set_party
      @party = Party.find(params[:id])
    end
end
