###* @jsx React.DOM ###

PlayerOutcome = React.createClass
  render: ->
    classes = "match-outcome match-outcome-#{this.props.outcome}"
    `<a href={this.props.url}>
      <span className={classes}>{this.props.outcome}</span>
    </a>`

window.PlayerOutcome = PlayerOutcome
