A8.Views.Events ?= {}

class A8.Views.Events.BoxInvitation extends Backbone.View
  this.count = 0

  tagName: "li"
  className: "invitation"

  events:
    "click .delete": "remove"
    "keypress span": "_edit"
    "keydown span": "_prevent_newlines"
    "blur *": "_update"

  initialize: ->
    @template = $("[data-template-for='Invitation']").html()
    @model.bind("error", _.bind(@_highlight_error, this))
    @model.bind("change", _.bind(@render, this))
    @index = A8.Views.Events.BoxInvitation.count++
    @el = $(@el)

  render: ->
    invite = _.template(
      @template,
      email: @model.escape("email")
      raw_email: @model.get("email")
      index: @index
    )

    @el.html(invite)
    @span = this.$("span")
    @el

  remove: ->
    @model.destroy()
    super()

  _update: ->
    @el.removeClass("error")
    @model.set(email: @span.html())

  _highlight_error: ->
    @el.addClass("error")

  _edit: (event) ->
    return false if event.keyCode is 10 or event.keyCode is 13
    @span.html("<br>").focus() if @span.html().match(/^\s*$/)
    true

  _prevent_newlines: (event) ->
    if event.keyCode is 10 or event.keyCode is 13
      @options.textarea?.focus()
      false
    true
