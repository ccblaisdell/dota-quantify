class ReportsController < ApplicationController
  def show
    find_report_period
    @matches = Match.between(@from, @to).real.by_date

    profile_ids = Profile.where(follow: true).pluck(:steam_account_id)
    match_ids = @matches.pluck(:id)
    @players = Player.where(
        :steam_account_id.in => profile_ids, 
        :match_id.in => match_ids)
      .order_by([sort_column(Player, :start), sort_direction])
      
    get_kda_max(@players)
  end

  private

  def find_report_period
    case params[:type]
      when "daily"
        @from = Time.new params[:year], params[:month], params[:day]
        @to = @from + 24.hours
      when "weekly"
        # beginning_of_week returns a monday
        @from = Time.new(params[:year], params[:month], params[:day]).beginning_of_week - 1.day
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
