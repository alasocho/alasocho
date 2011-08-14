class A8.Routers.EventRouter extends Backbone.Router
  initialize: (event_id, @container) ->
    this.invite = new A8.Views.Events.InvitePeopleView(event_id)
    $(".invite_more").click =>
      # TODO: Refactor
      this.invite = new A8.Views.Events.InvitePeopleView(event_id)
      this.invite.container = this.container
      this.invite.container.addClass("show")
      element = this.invite.render().el
      this.invite.update_limit this.counter_value
      this.invite.container.html element
      false

  counter_updated: (value) ->
    this.counter_value = value
    this.invite.update_limit this.counter_value
