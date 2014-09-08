###* @jsx React.DOM ###

PlayerTableItem = React.createClass
  render: -> `<tr>
      <td>{this.props.outcome}</td>
      <td>{this.props.duration}</td>
      <td>{this.props.start}</td>
      <td>{this.props.gpm}</td>
      <td>{this.props.xpm}</td>
    </tr>`