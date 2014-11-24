var React = window.React = require('react'),
    Timer = require("./ui/Timer"),
    mountNode = document.getElementById("app");

var TodoList = React.createClass({
  render: function() {
    var createItem = function(itemText) {
      return React.DOM.li(null, itemText);
    };
    return React.DOM.ul(null, this.props.items.map(createItem));
  }
});
var TodoApp = React.createClass({
  getInitialState: function() {
    return {items: [], text: ''};
  },
  onChange: function(e) {
    this.setState({text: e.target.value});
  },
  handleSubmit: function(e) {
    e.preventDefault();
    var nextItems = this.state.items.concat([this.state.text]);
    var nextText = '';
    this.setState({items: nextItems, text: nextText});
  },
  render: function() {
    return (
      React.DOM.div(null, [
        React.DOM.h3(null, 'TODO'),
        TodoList({items: this.state.items}),
        React.DOM.form({onSubmit: this.handleSubmit}, [
          React.DOM.input({onChange: this.onChange, value: this.state.text}, ""),
          React.DOM.button(null, ('Add #' + (this.state.items.length + 1)))
        ]),
        Timer()
      ])
    );
  }
});


React.renderComponent(TodoApp(), mountNode);

