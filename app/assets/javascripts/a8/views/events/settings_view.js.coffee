class A8.Views.Events.SettingsView extends Backbone.View
  attendee_quota: -> $(".attendee_quota")

  previous_attendee_quota: 0

  valid_numbers: (event) ->
    current_value = $(event.target).val()
    $(event.target).val(0) if current_value < 0

  initialize: (@el) ->
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
