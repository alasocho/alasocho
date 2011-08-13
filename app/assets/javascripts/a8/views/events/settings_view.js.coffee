class A8.Views.Events.SettingsView extends Backbone.View
  attendee_quota: -> $(".attendee_quota")

  valid_numbers: (event) ->
    current_value = $(event.target).val()
    $(event.target).val(0) if current_value < 0

  initialize: (@el) ->
    this.attendee_quota().click this.valid_numbers
    $("#no_limit").click =>
      $(".attendee_quota_field").toggle()
      this.attendee_quota().val(0)

    this

  render: -> this
#= require invite_people/invite_people
