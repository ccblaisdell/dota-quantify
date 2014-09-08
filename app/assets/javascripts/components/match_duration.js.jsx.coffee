###* @jsx React.DOM ###

MatchDuration = React.createClass
  render: ->
    `<span className="match-duration">{this.format(this.props.duration)}</span>`

  format: (duration) ->
    formatter = d3.format('02d')
    minutes = formatter Math.floor(duration/60)
    seconds = formatter duration%60
    "#{minutes}:#{seconds}"

window.MatchDuration = MatchDuration
