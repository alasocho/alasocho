class A8.Routers.EventRouter extends Backbone.Router
  routes: {
    "/invite_people" : "invite"
  }

  initialize: ->
    $("#invite_more").click =>
      this.navigate "/invite_people"
      invite = new A8.Views.Events.InvitePeopleView
      element = invite.render().el
      $("#modal_window").html element
      false

  invite: ->
