class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private
  
    helper_method :sort_column
    def sort_column(model, default=nil)
      default ||= model.fields.keys.first
      model.fields.keys.include?(params[:sort]) ? params[:sort] : default
    end

    helper_method :sort_direction
    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end

    def get_kda_max(players)
      k = players.max(:kills)
      d = players.max(:deaths)
      a = players.max(:assists)
      @kda_max = [k, d, a].max
    end
end
