###* @jsx React.DOM ###

PlayerOutcome = React.createClass
  render: ->
    classes = "match-outcome match-outcome-#{this.props.outcome}"
    `<span className={classes}>{this.props.outcome}</span>`

window.PlayerOutcome = PlayerOutcome
