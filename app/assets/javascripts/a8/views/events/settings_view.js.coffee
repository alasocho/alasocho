class A8.Views.Events.SettingsView extends Backbone.View
  attendee_quota: -> $(".attendee_quota")

  previous_attendee_quota: 0

  valid_numbers: (event) =>
    current_value = this.attendee_quota().val()
    if current_value < 0
      this.attendee_quota().val(0)
      current_value = 0
    this.watcher.counter_updated current_value

  initialize: (@el, @watcher) ->
    this.valid_numbers()
    this.attendee_quota().click this.valid_numbers
    $("#no_limit").toggle(=>
          value = this.attendee_quota().val()
          this.previous_attendee_quota = value if value > 0
          this.attendee_quota().val(null)
          $(".attendee_quota_field").hide()
      , =>
          this.attendee_quota().val(this.previous_attendee_quota)
          $(".attendee_quota_field").show()
      )

    this

  render: -> this
#= require invite_people/invite_people
