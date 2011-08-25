A8.Views.Events ?= {}

class A8.Views.Events.BoxInvitation extends Backbone.View
  this.pepe = 0

  tagName: "li"
  className: "invitation"

  template: $("[data-template-for='Invitation']").html()

  events:
    "click .delete": "remove"

  render: ->
    invite = _.template(
      @template,
      email: @model.escape("email")
      raw_email: @model.get("email")
      index: A8.Views.Events.BoxInvitation.pepe++
    )

    $(@el).attr("tabindex", 0).append(invite)

  remove: ->
    @model.destroy()
    super()
