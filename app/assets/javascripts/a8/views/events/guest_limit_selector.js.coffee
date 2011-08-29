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
    @quota     = this.$("#event_attendee_quota").val()
    this.update()

    this

  update: ->
    @selected = this.$(":radio:checked").parents(".form_field").attr("id")

  set_limited: ->
    @limited.attr("checked", "checked")
    @unlimited.removeAttr("checked")
    @quota = this.$("#event_attendee_quota").val()

  try_limited: ->
    this.set_limited() if this.$("#event_attendee_quota").val() isnt @quota
    @quota = this.$("#event_attendee_quota").val()
