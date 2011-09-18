class A8.Views.Events.GuestLimitSelector extends Backbone.View
  events:
    "change :radio": "update"
    "keyup  #event_attendee_quota": "try_limited"
    "change #event_attendee_quota": "set_limited"
    "click  #event_attendee_quota": "set_limited"
    "click  #quota label": "set_limited"

  render: ->
    @unlimited = this.$("#open_event :radio")
    @limited   = this.$("#quota :radio")
    @quota     = this._quota()

    this

  update: ->
    @selected = this.$(":radio:checked").parents(".form_field").attr("id")

  set_limited: ->
    @limited.attr("checked", "checked")
    @unlimited.removeAttr("checked")
    @quota = this._quota()

  try_limited: ->
    this.set_limited() if this._quota() isnt @quota
    @quota = this._quota()

  _quota: ->
    this.$("#event_attendee_quota").val()
