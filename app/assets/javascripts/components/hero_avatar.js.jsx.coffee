###* @jsx React.DOM ###

HeroAvatar = React.createClass
  render: ->
    return false unless this.props.hero_id 
    `<img src={this.imagePath()} className={this.classes()} />`

  classes: ->
    ["hero-avatar", this.props.className].join ' '

  imagePath: -> this.props.hero_avatar

  heroName: (id) -> da.heroes[id][0]

window.HeroAvatar = HeroAvatar
