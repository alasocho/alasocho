class Event::InvitePeople extends Backbone.View
  tagName: 'ul'

  events: {
    'keypress .add_attendee' : 'enter_pressed'
  }

  attendees_count: 0

  initialize: ->
    this.bind('add', this.add_one, this)
    this.bind('reset', this.add_all, this)
    this.bind('all', this.render, this)

    this.add_one()
    this


  enter_pressed: (event) ->
    if event.keyCode is 13
      this.add_one() if $(event.target).val().length
      false

  add_one: ->
    item = new Event::InvitePeople::AddInvitee({parent: this})
    element = item.render().el
    this.attendees_count++
    $(this.el).append element
    $(element).find("input").focus()

  render: ->
    this

#= require invite_people/add_invitee
