class ReportsController < ApplicationController
  def show
    find_report_period
    @matches = Match.between(@from, @to).by_date
    @players = @matches.all.collect {|m| m.followed_players}.flatten
  end

  private

  def find_report_period
    case params[:type]
      when "daily"
        @from = Time.new params[:year], params[:month], params[:day]
        @to = @from + 24.hours
      when "weekly"
        @from = Time.new(params[:year], params[:month], params[:day]).beginning_of_week
        @to = @from + 1.week
      when "monthly"
        @from = Time.new(params[:year], params[:month])
        @to = @from + 1.month
      when "yearly"
        @from = Time.new(params[:year])
        @to = @from + 1.year
    end
  end
end
