###* @jsx React.DOM ###

HeroesWidget = React.createClass
  render: ->
    `<select name="heroes-widget" ref="select" className="heroes-widget" onChange={this.handleChange} onFilterAll={this.handleFilterAll}>
      {this.option('blank', '' ,'')}
      {this.props.heroes.map(this.heroWidget)}
    </select>`

  heroWidget: (hero) -> 
    hero_name = if da.heroes[hero.key] then da.heroes[hero.key][1] else "--no hero--"
    this.option(hero.key, hero.key, "#{hero_name} (#{hero.value})")

  option: (key, value, text) -> 
    `<option key={key} value={value}>{text}</option>`

  handleChange: (e) ->
    if e.target.value then hero.filter(e.target.value) else hero.filterAll()
    dc.redrawAll()

  handleFilterAll: (e) -> 
    this.reset()
    hero.filterAll()

  reset: -> $(this.refs.select.getDOMNode()).val('')

  componentDidMount: -> $(document).on 'filterAll', this.handleFilterAll

  componentWillUnmount: -> $(document).off 'filterAll', this.handleFilterAll

window.HeroesWidget = HeroesWidget
