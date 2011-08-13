class Event::Settings extends Backbone.View
  events: {
    'click #event_attendee_quota' : 'valid_numbers'
    'submit .edit_event' : 'list_attendees'
  }

  attendee_list: -> $(".edit_event #invitee_list")

  valid_numbers: (event) ->
    current_value = $(event.target).val()
    $(event.target).val(0) if current_value < 0

  list_attendees: (event) ->
    for item in attendee_list.find("input")
      console.log item

    false

  initialize: ->
    invite = new Event::InvitePeople
    element = invite.render().el
    this.attendee_list().append element
    this

  render: -> this
#= require invite_people/invite_people
