class MatchUpdateJob
  include SuckerPunch::Job
  def perform(options={})
    ::Match.fetch_recent_for_followed(options)
  end
end
