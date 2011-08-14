class A8.Routers.EventRouter extends Backbone.Router
  routes: {
    "/invite_people" : "invite"
  }

  initialize: (event_id) ->
    $(".invite_more").click =>
      this.navigate "/invite_people"
      invite = new A8.Views.Events.InvitePeopleView(event_id)
      invite.container = $("#modal_window")
      invite.container.addClass("show")
      element = invite.render().el
      invite.container.html element
      false

  invite: ->
