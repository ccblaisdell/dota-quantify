module ApplicationHelper
  def dotabuff_link(target, path='')
    return link_to "View on dotabuff", dotabuff_url("players/#{target.dota_account_id}#{path}") if target.class == Profile
    return link_to "View on dotabuff", dotabuff_url("matches/#{target.match_id}#{path}") if target.class == Match
  end

  def dotabuff_url(path)
    "http://dotabuff.com/" + path
  end
  
  def menu(*links)
    content_tag :p, links.join(' | ').html_safe
  end

  def sortable(model, column, text=nil)
    text ||= column.titleize
    direction = (column == sort_column(model) && sort_direction == "desc") ? "asc" : "desc"
    link_to text, params.merge(sort: column, direction: direction, page: nil)
  end

  def time_ago(time)
    return time_ago_in_words(time) + ' ago' if Time.now.day == (time - 5.hours).day && Time.now - time < 24.hours
    format = "%a %-m/%-d"
    format += "/%y" if time.year != Time.now.year
    format += " %l:%M%p"
    time.strftime format
  end
end
