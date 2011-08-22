A8.Views.Events ||= {}

class A8.Views.Events.EndDateToggle extends Backbone.View
  events:
    "click .toggle": "toggle"

  toggle: (event) ->
    $(@el).toggleClass("hidden")

    if @form_field.is(":visible")
      this.hide()
    else
      this.show()
      this.$(":input:visible:first").focus()

  show: ->
    this._restore_values()
    @form_field.show()
    this.$(@options.always_hide).hide() if @options.always_hide
    @toggle_link.html(@options.hide_date)

  hide: ->
    this._store_values()
    @form_field.hide()
    @toggle_link.html(@options.show_date)

  render: ->
    @toggle_link = $("<a href='javascript:;' class='toggle'/>")
    @form_field = this.$("*:not(.toggle)")
    el = $(@el)

    el.prepend(@toggle_link)

    if @model.end_at()
      this.show()
    else
      el.addClass("hidden")
      this.hide()

    this

  _store_values: ->
    this.form_field.each ->
      el = $(this)
      el.data("value", el.val())
      el.val("")

  _restore_values: ->
    this.form_field.each ->
      el = $(this)
      el.val(el.data("value")) unless el.val().length
