class A8.Routers.EventRouter extends Backbone.Router
  routes: {
    "/invite_people" : "invite"
  }

  initialize: ->
    $("#invite_more").click =>
      this.navigate "/invite_people"
      invite = new A8.Views.Events.InvitePeopleView
      invite.container = $("#modal_window")
      element = invite.render().el
      invite.container.html element
      false

  invite: ->
