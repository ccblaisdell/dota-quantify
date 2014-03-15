class PartiesController < ApplicationController
  def index
    @parties = Party.all
  end
end
