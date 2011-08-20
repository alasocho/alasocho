A8.Views.Events ||= {}

class A8.Views.Events.EndDateToggle extends Backbone.View
  events:
    "click .toggle": "toggle"

  toggle: (event) ->
    this.el.toggleClass("hidden")

    if this.form_field.is(":visible")
      this.hide()
    else
      this.show()

  show: ->
    this.form_field.each ->
      el = $(this)
      el.val(el.data("value"))

    this.form_field.show()
    this.$(this.options.always_hide).hide() if this.options.always_hide
    this.toggle_link.html(this.options.hide_date)

  hide: ->
    this.form_field.each ->
      el = $(this)
      el.data("value", el.val())
      el.val("")

    this.form_field.hide()
    this.toggle_link.html(this.options.show_date)

  render: ->
    this.toggle_link = $("<a href='javascript:;' class='toggle'/>")
    this.form_field = this.$("*:not(.toggle)")

    $(this.el).prepend(this.toggle_link)

    if this.model.end_at()
      this.show()
    else
      this.el.addClass("hidden")
      this.hide()

    this
