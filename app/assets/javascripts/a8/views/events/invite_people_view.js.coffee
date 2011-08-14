A8.Views.Events ||= {}

class A8.Views.Events.InvitePeopleView extends Backbone.View
  tagName: 'div'
  id: 'invite_people'

  events: {
    'keypress .add_attendee'  : 'enter_pressed'
    'click button#invite'     : 'invite'
    'click button#close_modal': 'end'
  }

  container: null

  template: $("div[data-template-for='InvitePeopleView']").html()

  attendees_count: 0

  initialize: (@event_id) ->
    _.bindAll this, "end_if_escape"
    $(document).keyup(this.end_if_escape)

  update_limit: (value) ->
    template = _.template $("div[data-template-for='AttendeeQuotaView']").html()
    content = template(spots_left: value)
    $(this.el).find(".explanation").html content

  invite: (event) ->
    # TODO: Refactor someday
    invitations = _.map $(this.el).find("input"), (input) => this.validate_email($(input).val())
    ajax = $.post "/events/#{this.event_id}/invite", invitees: JSON.stringify _.compact(invitations)
    ajax.complete => this.end()
    false

  end_if_escape: (event) ->
    if event.keyCode is 27 and this.container
      this.end()

  end: ->
    this.container.removeClass "show"
    this.container.html ""

  validate_email: (string) ->
    filter = /([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+/
    _.first string.match filter if filter.test(string)

  enter_pressed: (event) ->
    if event.keyCode is 13
      this.add_one() if $(event.target).val().length
      false

  add_one: ->
    item = new A8.Views.Events.InvitePeopleView.AddInviteeView({parent: this})
    element = item.render().el
    this.attendees_count++
    $(this.list).append element
    $(element).find("input").focus()

  render: ->
    content = _.template(this.template)
    $(this.el).append content()
    this.list = $(this.el).find(".invitees")
    this.add_one()
    this

class A8.Views.Events.InvitePeopleView.AddInviteeView extends Backbone.View
  tagName: 'li'

  events: {
    'click .remove_attendee': 'remove_attendee'
  }

  template: $("div[data-template-for='AddInviteeView']").html()

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
