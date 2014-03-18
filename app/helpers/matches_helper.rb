module MatchesHelper
  def match_outcome(match)
    text = (match.won? ? "Won" : "Lost")
    content_tag :span, text, class: "match-outcome match-outcome-#{text.downcase}"
  end

  def match_time(match)
    content_tag :span, "#{time_ago_in_words match.start} ago", class: "match-time"
  end

  def match_mode(match)
    content_tag :span, match.mode, class: "match-mode"
  end
end
