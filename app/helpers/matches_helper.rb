module MatchesHelper
  def match_outcome(match)
    return if match.nil?
    text = (match.won? ? "Won" : "Lost")
    content_tag :span, text, class: "match-outcome match-outcome-#{text.downcase}"
  end

  def match_time(match)
    return if match.nil?
    content_tag :span, time_ago(match.end), class: "match-time"
  end

  def match_mode(match)
    return if match.nil?
    content_tag :span, match.mode, class: "match-mode"
  end

  def match_duration(match)
    return if match.nil?
    duration = format("%02d:%02d", (match.duration/60), (match.duration%60))
    content_tag :span, duration, class: "match-duration"
  end

  def match_lobby(match)
    return if match.nil?
    content_tag :span, match.lobby, class: "match-lobby"
  end

  def match_party(match)
    return content_tag :small, "No party data" unless !match.profiles.try(:empty?)
    return party_link match.parties.by_size.first if match.profiles && match.profiles.following.length > 1 && match.parties
    avatar match.profiles.following.first
  end

  def match_heroes(match, team=nil)
    players = team.nil? ? match.players : (team == :radiant ? match.players.radiant : match.players.dire)
    players.collect { |player| hero_avatar player.hero_id, class: ("hero-avatar-dim" unless player.profile.try(:follow?)) }.join(' ').html_safe
  end
end
