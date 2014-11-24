React = window.React = require("react")
Timer = require("./ui/Timer")
mountNode = document.getElementById("app")
TodoList = React.createClass(render: ->
  createItem = (itemText) ->
    React.DOM.li null, itemText

  React.DOM.ul null, @props.items.map(createItem)
)
TodoApp = React.createClass(
  getInitialState: ->
    items: []
    text: ""

  onChange: (e) ->
    @setState text: e.target.value
    return

  handleSubmit: (e) ->
    e.preventDefault()
    nextItems = @state.items.concat([@state.text])
    nextText = ""
    @setState
      items: nextItems
      text: nextText

    return

  render: ->
    React.DOM.div null, [
      React.DOM.h3(null, "TODO")
      TodoList(items: @state.items)
      React.DOM.form(
        onSubmit: @handleSubmit
      , [
        React.DOM.input(
          onChange: @onChange
          value: @state.text
        , "")
        React.DOM.button(null, ("Add #" + (@state.items.length + 1)))
      ])
      Timer()
    ]
)
React.renderComponent TodoApp(), mountNode
