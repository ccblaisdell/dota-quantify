###* @jsx React.DOM ###

HeroAvatar = React.createClass
  render: ->
    return false unless this.props.hero_id 
    `<img src={this.imagePath()} className={this.classes()} />`

  classes: ->
    ["hero-avatar", this.props.className].join ' '

  imagePath: ->
    "/assets/heroes/#{this.heroName(this.props.hero_id)}_sb.png"

  heroName: (id) -> da.heroes[id][0]

window.HeroAvatar = HeroAvatar
