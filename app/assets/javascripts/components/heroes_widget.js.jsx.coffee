###* @jsx React.DOM ###

HeroesWidget = React.createClass
  render: ->
    console.log this.props.heroes
    `<select name="heroes-widget" className="heroes-widget" onchange={this.handleChange}>
      {this.props.heroes.map(this.heroWidget)}
    </select>`

  heroWidget: (hero) ->
    `<option value={hero.key} key={hero.key}>{hero.key}</option>`

  handleChange: (e) ->
    console.log this, e.target.value, hero
    hero.filter(e.target.value)
    dc.redrawAll()

window.HeroesWidget = HeroesWidget
