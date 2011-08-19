A8.Views.Events ||= {}

class A8.Views.Events.EndDateToggle extends Backbone.View
  events:
    "click .toggle": "toggle"

  toggle: (event) ->
    if this.formField.is(":visible")
      this.hide()
    else
      this.show()

  show: ->
    this.formField.each ->
      el = $(this)
      el.val(el.data("value"))

    this.formField.show()
    this.toggleLink.html(this.options.hideDate)

  hide: ->
    this.formField.each ->
      el = $(this)
      el.data("value", el.val())
      el.val("")

    this.formField.hide()
    this.toggleLink.html(this.options.showDate)

  render: ->
    this.toggleLink = $("<a href='javascript:;' class='toggle'/>")
    this.formField = this.$("*:not(.toggle)")

    $(this.el).prepend(this.toggleLink)

    if this.model.end_at()
      this.show()
    else
      this.hide()

    this
