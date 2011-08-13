class Event::InvitePeople::AddInvitee extends Backbone.View
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
