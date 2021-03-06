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

  # Show time ago in words if the game occured earlier today (ex. about 2 hours ago)
  # Otherwise show ex. Mon 3/31 1:09pm
  def time_ago(time)
    return time_ago_in_words(time) + ' ago' if Time.now.day == (time - 5.hours).day && Time.now - time < 24.hours
    format = "%a %-m/%-d"
    format += "/%y" if time.year != Time.now.year
    format += " %l:%M%p"
    time.strftime format
  end

  def bar(target, field, max)
    content_tag :div, class: "bar" do
      content_tag :div, '', class: "bar-segment bar-segment--#{field}", style: "width: #{(target.send(field).to_f / max.to_f * 100)}%;"
    end
  end

  def spinner
    spin = <<-eos
<div class="spinner-container">
  <svg class="spinner" width="65px" height="65px" viewBox="0 0 66 66" xmlns="http://www.w3.org/2000/svg">
    <circle class="path" fill="none" stroke-width="6" stroke-linecap="round" cx="33" cy="33" r="30"></circle>
  </svg>
</div>
    eos
    spin.html_safe
  end
end
