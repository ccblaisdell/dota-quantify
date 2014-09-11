###* @jsx React.DOM ###

NamesWidget = React.createClass
  render: ->
    `<select name="names-widget" ref="select" className="names-widget" onChange={this.handleChange} onFilterAll={this.handleFilterAll}>
      {this.option('blank', '' ,'')}
      {this.props.profiles.map(this.nameWidget)}
    </select>`

  nameWidget: (name) -> 
    this.option(name.key, name.key, name.key)

  option: (key, value, text) -> 
    `<option key={key} value={value}>{text}</option>`

  handleChange: (e) ->
    if e.target.value then profile.filter(e.target.value) else profile.filterAll()
    dc.redrawAll()

  handleFilterAll: (e) -> 
    this.reset()
    profile.filterAll()

  reset: -> $(this.refs.select.getDOMNode()).val('')

  componentDidMount: -> $(document).on 'filterAll', this.handleFilterAll

  componentWillUnmount: -> $(document).off 'filterAll', this.handleFilterAll

window.NamesWidget = NamesWidget
