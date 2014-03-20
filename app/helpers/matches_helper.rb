module MatchesHelper
  def match_outcome(match)
    text = (match.won? ? "Won" : "Lost")
    content_tag :span, text, class: "match-outcome match-outcome-#{text.downcase}"
  end

  def match_time(match)
    content_tag :span, "#{time_ago_in_words match.end} ago", class: "match-time"
  end

  def match_mode(match)
    content_tag :span, match.mode, class: "match-mode"
  end

  def match_duration(match)
    duration = format("%02d:%02d", (match.duration/60), (match.duration%60))
    content_tag :span, duration, class: "match-duration"
  end

  def match_lobby(match)
    content_tag :span, match.lobby, class: "match-lobby"
  end
end
