A8.Views.Events ||= {}

class A8.Views.Events.InvitePeopleView extends Backbone.View
  tagName: 'ul'

  events: {
    'keypress .add_attendee'  : 'enter_pressed'
    'click button#invite'     : 'invite'
    'click button#close_modal': 'end'
  }

  container: null

  event_id: $("#event_id").val()

  template: "
    <h1>Invite new users</h1>
    <button id='invite'>Invite</button>
    <button id='close_modal'>close</button>
      "

  attendees_count: 0

  initialize: ->
    this.bind('add', this.add_one, this)
    this.bind('reset', this.add_all, this)
    this.bind('all', this.render, this)

    content = _.template(this.template)
    $(this.el).append content

    this.add_one()
    this

  invite: (event) ->
    # TODO: Refactor someday
    invitations = _.map $(this.el).find("input"), (input) -> $(input).val()
    ajax = $.post "/events/#{this.event_id}/invite", invitees: JSON.stringify invitations
    ajax.complete => this.end()
    false

  end: ->
    this.container.removeClass "show"
    this.container.html ""

  enter_pressed: (event) ->
    if event.keyCode is 13
      this.add_one() if $(event.target).val().length
      false

  add_one: ->
    item = new A8.Views.Events.InvitePeopleView.AddInviteeView({parent: this})
    element = item.render().el
    this.attendees_count++
    $(this.el).append element
    $(element).find("input").focus()

  render: ->
    this

class A8.Views.Events.InvitePeopleView.AddInviteeView extends Backbone.View
  tagName: 'li'

  events: {
    'click .remove_attendee': 'remove_attendee'
  }

  template: "<input class='add_attendee'> <button class='remove_attendee'>-</button>"

  initialize: (@options) ->
    content = _.template(this.template)
    $(this.el).append content
    this

  remove_attendee: (event) ->
    unless this.options.parent.attendees_count is 1
      $(this.el).remove()
      this.options.parent.attendees_count--
    false

  render: ->
    this
