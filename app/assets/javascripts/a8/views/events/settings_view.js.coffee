class A8.Views.Events.SettingsView extends Backbone.View
  attendee_list: -> $(".edit_event #invitee_list")
  attendee_quota: -> $(".attendee_quota")

  valid_numbers: (event) ->
    current_value = $(event.target).val()
    $(event.target).val(0) if current_value < 0

  list_attendees: (event) =>
    invitee_list = new String
    for item in this.attendee_list().find("input")
      value = $(item).val()
      invitee_list += "#{value} \n"
    $("#invitee_list").val invitee_list

  initialize: (@el) ->
    this.attendee_quota().click this.valid_numbers
    $("#no_limit").click =>
      $(".attendee_quota_field").toggle()
      this.attendee_quota().val(0)

    $("#submit_event").click => this.list_attendees()

    invite = new A8.Views.Events.InvitePeopleView
    element = invite.render().el
    this.attendee_list().append element
    this

  render: -> this
#= require invite_people/invite_people
