module ApplicationHelper
  def dotabuff_link(target, path='')
    return link_to "View on dotabuff", dotabuff_url("players/#{target.dota_account_id}#{path}") if target.class == Profile
    return link_to "View on dotabuff", dotabuff_url("matches/#{target.match_id}#{path}") if target.class == Match
  end

  def dotabuff_url(path)
    "http://dotabuff.com/" + path
  end
end
