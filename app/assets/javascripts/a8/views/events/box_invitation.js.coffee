A8.Views.Events ?= {}

class A8.Views.Events.BoxInvitation extends Backbone.View
  this.count = 0

  tagName: "li"
  className: "invitation"

  template: $("[data-template-for='Invitation']").html()

  events:
    "click .delete": "remove"

  initialize: ->
    @model.bind("error", _.bind(@_highlight_error, this))

  render: ->
    invite = _.template(
      @template,
      email: @model.escape("email")
      raw_email: @model.get("email")
      index: A8.Views.Events.BoxInvitation.count++
    )

    $(@el).attr("tabindex", 0).append(invite)

  remove: ->
    @model.destroy()
    super()

  _highlight_error: ->
    $(@el).addClass("error")
