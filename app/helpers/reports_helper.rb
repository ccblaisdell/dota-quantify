module ReportsHelper
  def match_record(matches, record)
    m = matches[0..2].collect do |match| 
      [
        match_link(match), 
        match_duration(match)
      ].join(' ')
    end
    m.join(' ').html_safe
  end

  def player_records(players, record)
    players[0..2].collect {|player| record(player.match, player, record)}.join(' ').html_safe
  end

  def record(match, player=nil, record=nil)
    content_tag :div, class: :match do
      [match_link(match), player_record(player, record)].join(' ').html_safe
    end
  end

  def match_link(match)
    link_to match, class: "match-link" do
      [
        match_outcome(match),
        match_mode(match),
        match_time(match)
      ].join(' ').html_safe
    end
  end

  def player_record(player, record)
    return nil if player.nil?
    content_tag :div, class: "player" do
      [
        hero_avatar(player.hero_id),
        profile_link(player.profile),
        player.send(record)
      ].join(' ').html_safe
    end
  end
end
